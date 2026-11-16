import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Use the bundled brand fonts and Flutter SDK's real Roboto instead of Ahem.
Future<void> loadPreviewFonts() async {
  await (FontLoader('MontserratAlternates')
        ..addFont(
          rootBundle.load('assets/fonts/MontserratAlternates-Regular.ttf'),
        )
        ..addFont(
          rootBundle.load('assets/fonts/MontserratAlternates-SemiBold.ttf'),
        ))
      .load();
  final config = File('../.dart_tool/package_config.json');
  final packages =
      (jsonDecode(await config.readAsString())
              as Map<String, dynamic>)['packages']
          as List<dynamic>;
  final flutterPackage = packages.cast<Map<String, dynamic>>().singleWhere(
    (p) => p['name'] == 'flutter',
  );
  final flutter = Uri.directory(
    config.absolute.uri
        .resolve(flutterPackage['rootUri'] as String)
        .toFilePath(),
  );
  final roboto = FontLoader('Roboto');
  for (final name in [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
  ]) {
    final bytes = await File.fromUri(
      flutter.resolve('../../bin/cache/artifacts/material_fonts/$name'),
    ).readAsBytes();
    roboto.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await roboto.load();
  final icons = await File.fromUri(
    flutter.resolve(
      '../../bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
    ),
  ).readAsBytes();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(Future.value(ByteData.sublistView(icons)))).load();
}
