import 'dart:io';
import 'dart:typed_data';

Future<StudioAudioClip> cacheStudioAudio(Uint8List bytes) async {
  final directory = await Directory.systemTemp.createTemp('poodle-studio-');
  final file = File.fromUri(directory.uri.resolve('overview.mp3'));
  try {
    await file.writeAsBytes(bytes);
    return StudioAudioClip(file.uri, directory);
  } catch (_) {
    await directory.delete(recursive: true);
    rethrow;
  }
}

class StudioAudioClip {
  const StudioAudioClip(this.uri, this._directory);

  final Uri uri;
  final Directory _directory;

  Future<void> dispose() async {
    try {
      await _directory.delete(recursive: true);
    } on FileSystemException {
      // The OS can purge temporary storage itself.
    }
  }
}
