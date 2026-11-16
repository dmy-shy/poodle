import 'package:flutter_test/flutter_test.dart';
import 'package:poodle_flutter/server_url.dart';

void main() {
  test('signed local upload URL uses the reachable API host', () {
    const description =
        '{"type":"binary","url":"http://localhost:8080/serverpod_cloud_storage?method=upload&key=secret","method":"POST","headers":{"x-test":"value"}}';
    expect(
      resolveUploadDescription(
        description: description,
        serverUrl: 'http://10.0.2.2:8080/',
      ),
      '{"type":"binary","url":"http://10.0.2.2:8080/serverpod_cloud_storage?method=upload&key=secret","method":"POST","headers":{"x-test":"value"}}',
    );
    expect(
      resolveUploadDescription(
        description: description,
        serverUrl: 'https://api.example.com/',
      ),
      description,
    );
  });

  test(
    'authorized local download uses the reachable API host and preserves token',
    () {
      expect(
        resolveDownloadUrl(
          downloadUrl:
              'http://localhost:8080/serverpod_cloud_storage?method=temporaryFile&key=secret',
          serverUrl: 'http://10.0.2.2:8080/',
        ),
        'http://10.0.2.2:8080/serverpod_cloud_storage?method=temporaryFile&key=secret',
      );
      expect(
        resolveDownloadUrl(
          downloadUrl: 'https://storage.example.com/file?key=secret',
          serverUrl: 'http://10.0.2.2:8080/',
        ),
        'https://storage.example.com/file?key=secret',
      );
      expect(
        resolveDownloadUrl(
          downloadUrl: 'http://localhost:9000/file',
          serverUrl: 'http://10.0.2.2:8080/',
        ),
        'http://localhost:9000/file',
      );
    },
  );
  test('Android emulator uses host loopback for bundled local API URL', () {
    expect(
      resolveServerUrl(
        bundledUrl: 'http://localhost:8080/',
        explicitUrl: '',
        isAndroidNative: true,
      ),
      'http://10.0.2.2:8080/',
    );
    expect(
      resolveServerUrl(
        bundledUrl: 'http://127.0.0.1:8080/api',
        explicitUrl: '',
        isAndroidNative: true,
      ),
      'http://10.0.2.2:8080/api',
    );
  });

  test('web and iOS keep the bundled URL', () {
    expect(
      resolveServerUrl(
        bundledUrl: 'http://localhost:8080/',
        explicitUrl: '',
        isAndroidNative: false,
      ),
      'http://localhost:8080/',
    );
  });

  test('explicit URL takes precedence for physical Android devices', () {
    expect(
      resolveServerUrl(
        bundledUrl: 'http://localhost:8080/',
        explicitUrl: 'http://192.168.1.15:8080/',
        isAndroidNative: true,
      ),
      'http://192.168.1.15:8080/',
    );
  });

  test('remote bundled hosts are not rewritten', () {
    expect(
      resolveServerUrl(
        bundledUrl: 'https://api.example.com:8443/v1/',
        explicitUrl: '',
        isAndroidNative: true,
      ),
      'https://api.example.com:8443/v1/',
    );
  });
}
