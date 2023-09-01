The official generator of `flutter_localizations` package doesnt add missing translation strings into the non-template language files.

This tool fixes that while making sure the language files
keep the same key order of the template file. It also deletes keys that doesnt exist in the template file. newly added strings will be empty unless it contains a {palceholder}. In that case it will extract all placeholders.

Call in a terminal inside the project root directory. If the l10n.yaml file has another name or lies in another directory than root then pass the relative path to the l10n.yaml file.

Install under `dev_dependencies`
```yaml
flutter_localizations_tool:
  git:
    url: https://github.com/alsterverse/flutter_localizations_tool
```

and use as `dart run flutter_localizations_tool [l10n.yaml path]`.
