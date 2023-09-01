import 'dart:convert';

import 'package:flutter_localizations_tool/flutter_localizations_tool.dart';
import 'package:test/test.dart';

void main() {
  test('Test missing strings', () {
    final template = {
      "foo": "bar",
    };
    expect(buildArbFile({}, template), {
      "foo": "",
    });
  });

  test('Test new strings with previous strings', () {
    final template = {
      "foo": "bar",
      "baz": "qux",
    };
    final arb = {
      "foo": "foobar",
    };
    expect(buildArbFile(arb, template), {
      "foo": "foobar",
      "baz": "",
    });
  });

  test('Test removing strings', () {
    final template = {
      "foo": "bar",
    };
    final arb = {
      "foo": "bar",
      "baz": "qux",
    };
    expect(buildArbFile(arb, template), {
      "foo": "bar",
    });
  });
  test('Test key order', () {
    final template = {
      "baz": "qux",
      "foo": "bar",
    };
    final arb = {
      "foo": "bar",
      "baz": "qux",
    };
    final newArb = buildArbFile(arb, template);
    expect(jsonEncode(newArb), jsonEncode(template));
    expect(jsonEncode(newArb), isNot(jsonEncode((arb))));
  });

  test('Test missing placeholders', () {
    final template = {
      "foo": "bar, {baz}",
      "@foo": {
        "placeholders": {
          "baz": {
            "type": "String",
          }
        }
      }
    };
    expect(buildArbFile({}, template), {
      "foo": "{baz}",
      "@foo": {
        "placeholders": {
          "baz": {
            "type": "String",
          }
        }
      }
    });
  });
}
