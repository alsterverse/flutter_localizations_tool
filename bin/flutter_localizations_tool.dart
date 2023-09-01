import "dart:io";
import 'package:flutter_localizations_tool/flutter_localizations_tool.dart' show run;

void main(List<String> args) {
  final res = Process.runSync("flutter", ["gen-l10n"]);
  if (res.stderr.toString() != "") {
    throw res.stderr;
  }
  run(args.firstOrNull ?? "l10n.yaml");
}
