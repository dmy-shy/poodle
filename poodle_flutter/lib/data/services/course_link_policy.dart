/// Only explicit HTTPS destinations without embedded credentials may be opened.
Uri? courseLinkUri(String? value) {
  if (value == null || value.isEmpty || RegExp(r'[\s\\]').hasMatch(value)) {
    return null;
  }
  try {
    final uri = Uri.parse(value);
    if (uri.scheme != 'https' ||
        uri.host.isEmpty ||
        uri.host.contains('%') ||
        uri.userInfo.isNotEmpty ||
        uri.port < 1 ||
        uri.port > 65535) {
      return null;
    }
    return uri;
  } on FormatException {
    return null;
  }
}
