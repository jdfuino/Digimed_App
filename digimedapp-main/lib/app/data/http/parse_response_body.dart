part of 'http.dart';

dynamic _parseResponseBody(Uint8List responseBody) {
  try {
    return jsonDecode(utf8.decode(responseBody));
  } catch (_) {
    return utf8.decode(responseBody);
  }
}