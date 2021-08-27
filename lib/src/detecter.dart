import 'dart:async';
import 'dart:html';

import 'package:adblock_detecter/src/helper.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class AdBlockDetecter {
  final _helper = Helper();

  /// Registers this class
  static void registerWith(Registrar registrar) {}

  Future<bool> get detectAnyAdblocker async {
    /// check dom adblockers first
    if (detectDomAdblocker) {
      return true;
    }

    /// try to detect other blockers
    if (await detectBraveShields) {
      return true;
    }

    if (await detectOperaAdblocker) {
      return true;
    }

    return false;
  }

  /// Detect if an ad blocker is blocking ads in the DOM itself
  bool get detectDomAdblocker {
    // that's a legacy Ad Block Plus check
    //  I don't think this attribute is set anymore, but I am keeping it anyway
    if (document.body?.getAttribute('abp') != null) {
      return true;
    }

    // try to lure adblockers into a trap
    final bait = _helper.createBaitElement();
    document.body?.append(bait);
    final detected = _helper.doesElementIsBlocked(bait);
    bait.remove();

    return detected;
  }

  /// Standalone check to detect if brave browser shields seems to be activated
  Future<bool> get detectBraveShields {
    final isBrave = _helper.isBraveBrowser();

    if (isBrave) {
      return _helper.doesBaitRequestIsBlockedByBrave();
    }

    return Future.value(false);
  }

  /// Standalone check to detect if opera adblocker seems to be activated
  Future<bool> get detectOperaAdblocker {
    final isOpera = _helper.isOperaBrowser();

    if (isOpera) {
      return _helper.doesBaitRequestIsBlockedByOpera();
    }

    return Future.value(false);
  }
}
