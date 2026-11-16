import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/models/course.dart';

/// Transient files only. The repository supplies fresh authorized URLs per open.
class CourseFileService {
  CourseFileService({Future<Directory> Function()? temporaryDirectory})
    : _temporaryDirectory = temporaryDirectory ?? getTemporaryDirectory;
  final Future<Directory> Function() _temporaryDirectory;
  int _generation = 0;
  String? _account;
  Future<void> _cleanup = Future.value();
  Future<Directory> _root() async =>
      Directory('${(await _temporaryDirectory()).path}/poodle-course-view');
  Future<void> reset(String? account) {
    _generation++;
    _account = account;
    _cleanup = _cleanup.catchError((_) {}).then((_) async {
      final root = await _root();
      if (await root.exists()) await root.delete(recursive: true);
    });
    return _cleanup;
  }

  Future<String> prepare(CourseFile file, FileAccess access) async {
    final generation = _generation;
    final account = _account;
    if (account == null) throw CourseFailure.cancelled;
    await _cleanup;
    Uint8List bytes;
    if (access.asset != null) {
      bytes = (await rootBundle.load(access.asset!)).buffer.asUint8List();
    } else {
      if (!access.expiresAt.isAfter(DateTime.now())) throw CourseFailure.file;
      final uri = Uri.parse(access.url);
      const local = ['localhost', '127.0.0.1', '10.0.2.2', '::1'];
      if (uri.userInfo.isNotEmpty ||
          (uri.scheme != 'https' &&
              !(uri.scheme == 'http' && local.contains(uri.host)))) {
        throw CourseFailure.file;
      }
      final client = http.Client();
      try {
        final request = http.Request('GET', uri)..followRedirects = false;
        final response = await client
            .send(request)
            .timeout(const Duration(seconds: 30));
        if (response.statusCode != 200 ||
            (response.contentLength ?? 0) > 25 * 1024 * 1024) {
          throw CourseFailure.file;
        }
        final builder = BytesBuilder();
        await for (final chunk in response.stream.timeout(
          const Duration(seconds: 30),
        )) {
          builder.add(chunk);
          if (builder.length > 25 * 1024 * 1024) throw CourseFailure.file;
        }
        bytes = builder.takeBytes();
      } finally {
        client.close();
      }
    }
    if (generation != _generation) throw CourseFailure.cancelled;
    if (bytes.isEmpty ||
        bytes.length > 25 * 1024 * 1024 ||
        (file.sizeBytes > 0 && bytes.length != file.sizeBytes) ||
        (file.checksum.isNotEmpty &&
            sha256.convert(bytes).toString() != file.checksum)) {
      throw CourseFailure.file;
    }
    final pdf = file.mimeType == 'application/pdf';
    final markdown = file.mimeType == 'text/markdown';
    if (!markdown &&
        !pdf &&
        file.mimeType !=
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document') {
      throw CourseFailure.file;
    }
    if (markdown) utf8.decode(bytes);
    if (!markdown &&
        (pdf
            ? !(bytes.length >= 5 &&
                  String.fromCharCodes(bytes.take(5)) == '%PDF-')
            : !(bytes.length >= 4 && bytes[0] == 0x50 && bytes[1] == 0x4b))) {
      throw CourseFailure.file;
    }
    final root = await _root();
    final directory = Directory(
      '${root.path}/${sha256.convert(utf8.encode(account))}',
    );
    await directory.create(recursive: true);
    final target = File(
      '${directory.path}/${sha256.convert(bytes)}.${pdf
          ? 'pdf'
          : markdown
          ? 'md'
          : 'docx'}',
    );
    await target.writeAsBytes(bytes, flush: true);
    if (generation != _generation) {
      if (await target.exists()) await target.delete();
      throw CourseFailure.cancelled;
    }
    return target.path;
  }

  Future<void> openDocument(String path) async {
    final result = await OpenFilex.open(
      path,
      type:
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    );
    if (result.type == ResultType.noAppToOpen) throw CourseFailure.noHandler;
    if (result.type != ResultType.done) throw CourseFailure.file;
  }
}
