import 'dart:convert';

/// Database storage advertises the configured server host, which may be
/// loopback in development. Reuse the API host only for that same HTTP server.
String resolveDownloadUrl({
  required String downloadUrl,
  required String serverUrl,
}) {
  final download = Uri.tryParse(downloadUrl);
  final server = Uri.tryParse(serverUrl);
  if (download == null ||
      server == null ||
      download.scheme != 'http' ||
      server.scheme != 'http' ||
      download.userInfo.isNotEmpty ||
      server.userInfo.isNotEmpty ||
      download.port != server.port ||
      !{'localhost', '127.0.0.1', '::1'}.contains(download.host)) {
    return downloadUrl;
  }
  return download.replace(host: server.host).toString();
}

/// Serverpod's upload description contains a signed URL. Only rewrite a local
/// URL for the same API port; retain its path, query and all other fields.
String resolveUploadDescription({
  required String description,
  required String serverUrl,
}) {
  final fields = jsonDecode(description) as Map<String, dynamic>;
  final url = fields['url'] as String;
  final reachable = resolveDownloadUrl(downloadUrl: url, serverUrl: serverUrl);
  if (reachable == url) return description;
  return jsonEncode({...fields, 'url': reachable});
}

/// Resolves the bundled development URL for the current client platform.
///
/// An explicit SERVER_URL is left untouched so physical devices can use a LAN
/// address or Android's `adb reverse` port forwarding.
String resolveServerUrl({
  required String bundledUrl,
  required String explicitUrl,
  required bool isAndroidNative,
}) {
  if (explicitUrl.isNotEmpty || !isAndroidNative) {
    return explicitUrl.isNotEmpty ? explicitUrl : bundledUrl;
  }

  final uri = Uri.tryParse(bundledUrl);
  if (uri == null ||
      uri.scheme != 'http' ||
      !{'localhost', '127.0.0.1', '::1'}.contains(uri.host)) {
    return bundledUrl;
  }
  return uri.replace(host: '10.0.2.2').toString();
}
