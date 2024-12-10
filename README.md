# AdBlock Detecter Flutter Web
[![GitHub followers](https://img.shields.io/github/followers/cr0manty.svg?style=social&label=Follow)](https://github.com/cr0manty)

## Features

- **Browser extensions** detection (like **AdBlock, Adblock Plus, uBlock, etc.**)
- **Brave browser** shields detection
- **Opera browser** adblocker detection
- **uBlock origin** detection


## Use this package as a library

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  adblock_detecter: ^0.1.0
```

You can install packages from the command line with Flutter:
```bash
$ flutter pub get
```

Import in your project:
```dart
import 'package:adblock_detecter/adblock_detecter.dart';
```

## Sample Usage

| Methods                       | Return                         | Description                                                       |
| :---------------------------- |:-------------------------------|:------------------------------------------------------------------|
| `detectAnyAdblocker()`        | *Future(detected=true/false)*  | perform all available checks below until at least one is positive |
| `detectDomAdblocker()`        | *true/false*                   | detect if a browser extension is hiding ads from the DOM          |
| `detectBraveShields()`        | *Future(detected=true/false)*  | detect if Brave browser shields seems to be activated             |
| `detectOperaAdblocker()`      | *Future(detected=true/false)*  | detect if Opera browser adblocker seems to be activated           |
| `uBlockOriginDetection()`      | *true/false*                   | detect if uBlock Origin seems to be activated                     |
