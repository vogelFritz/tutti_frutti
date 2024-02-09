import 'package:flutter_test/flutter_test.dart';

int indexOfString(String source, String str) {
  if (source.isEmpty || str.isEmpty) {
    throw Exception('indexOfString used incorrectly');
  }
  String aux = source[0];
  int i = 0;
  while (i < source.length - 1 && !aux.contains(str)) {
    i++;
    aux += source[i];
  }
  if (i < source.length) {
    return i - (str.length - 1);
  }
  return -1;
}

void main() {
  group('func indexOfString -->', () {
    test('source: "emit", str: "emit"', () {
      const String source = 'emit', str = 'emit';
      expect(indexOfString(source, str), 0);
    });
    test('source: "ioeemit", str: "emit"', () {
      const String source = 'ioeemit', str = 'emit';
      expect(indexOfString(source, str), 3);
    });
    test('source: "ioeemitopopop", str: "emit"', () {
      const String source = 'ioeemitopopop', str = 'emit';
      expect(indexOfString(source, str), 3);
    });
    test('source: "", str: "emit"', () {
      const String source = '', str = 'emit';
      expect(() {
        indexOfString(source, str);
      }, throwsException);
    });
  });
}
