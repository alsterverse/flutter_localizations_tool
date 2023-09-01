import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart' as yaml;

void run(String l10nPath) {
  final (arbsPath, templateArbFileName) = _readl10nYAML(l10nPath);
  final templateArb = _jsonFromJsonFile("$arbsPath/$templateArbFileName", true).data;

  // arb files except the template file
  final arbs = (Directory(arbsPath).listSync()
        ..removeWhere(
          (e) => e.path.endsWith(templateArbFileName),
        ))
      .map((e) => _jsonFromJsonFile(e.path, false))
      .toList();

  const jsonEncoder = JsonEncoder.withIndent("  ");
  for (final arb in arbs) {
    final json = buildArbFile(arb.data, templateArb);
    final jsonString = jsonEncoder.convert(json);
    arb.file.writeAsStringSync("$jsonString\n");
  }
}

final placeholderRegex = RegExp(r'({\s?\w+\s?})');
JSON buildArbFile(JSON oldData, JSON templateData) {
  final LinkedHashMap<String, dynamic> newData = LinkedHashMap();
  for (final key in templateData.keys) {
    if (key.startsWith("@")) {
      newData[key] = oldData[key] ?? templateData[key];
    } else {
      if (templateData.containsKey("@$key")) {
        newData[key] = oldData[key] ??
            placeholderRegex
                .allMatches(templateData[key])
                .map(
                  (e) => e[0]!,
                )
                .toList()
                .join(" ");
      } else {
        newData[key] = oldData[key] ?? "";
      }
    }
  }
  return newData;
}

// MARK: - Utils

typedef JSON = Map<String, dynamic>;

({JSON data, File file}) _jsonFromJsonFile(String path, bool p) {
  final file = File(path);
  final jsonString = file.readAsStringSync();
  LinkedHashMap<String, dynamic> json = LinkedHashMap();
  // fetch root keys because JsonDecoder.receiver receives nested parameters which would otherwise flatten them out
  final keys = JSON.from(jsonDecode(jsonString)).keys;
  // Use JsonDecoder to keep order of keys in file
  final decoder = JsonDecoder((key, value) {
    if (key == null) return value;
    if (keys.contains(key)) json[key.toString()] = value;
    return value;
  });
  decoder.convert(jsonString);
  return (data: json, file: file);
}

(String arbsPath, String templateArb) _readl10nYAML(String path) {
  final l10nData = yaml.loadYaml(File(path).readAsStringSync());
  final arbsPath = l10nData["arb-dir"] as String;
  final templateArbFileName = l10nData["template-arb-file"] as String;
  return (arbsPath, templateArbFileName);
}
