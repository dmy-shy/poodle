import 'dart:typed_data';

Future<StudioAudioClip> cacheStudioAudio(Uint8List bytes) async =>
    StudioAudioClip(Uri.dataFromBytes(bytes, mimeType: 'audio/mpeg'));

class StudioAudioClip {
  const StudioAudioClip(this.uri);

  final Uri uri;

  Future<void> dispose() async {}
}
