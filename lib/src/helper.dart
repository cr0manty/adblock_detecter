import 'dart:html';
import 'dart:js' as js;

import 'package:http/http.dart' as http;

class Helper {
  /// Create a DOM element that should be seen as an ad by adblockers
  /// return [Element]
  Element createBaitElement() {
    final bait = document.createElement('div');

    bait.setAttribute(
      'class',
      'pub_300x250 pub_300x250m pub_728x90 text-ad textAd '
          'text_ad text_ads text-ads text-ad-links ad-text '
          'adSense adBlock adContent adBanner',
    );
    bait.setAttribute(
      'style',
      'width: 1px !important; height: 1px !important;'
          ' position: absolute !important; left: -10000px !important;'
          ' top: -1000px !important;',
    );

    return bait;
  }

  /// Check if a DOM element seems to be blocked by an adblocker or not
  bool doesElementIsBlocked(Element? element) {
    if (element?.offsetParent == null ||
        element?.offsetHeight == 0 ||
        element?.offsetLeft == 0 ||
        element?.offsetTop == 0 ||
        element?.offsetWidth == 0 ||
        element?.clientHeight == 0 ||
        element?.clientWidth == 0) {
      return true;
    } else if (element != null) {
      final elemCS = element.getComputedStyle();
      if (elemCS.getPropertyValue('display') == 'none' ||
          elemCS.getPropertyValue('visibility') == 'hidden') {
        return true;
      }
    }

    return false;
  }

  /// Check if Brave is the current browser
  bool isBraveBrowser() {
    // TODO: add cheking for brave browser
    final agent = window.navigator.userAgent.toLowerCase();
    final chrom = RegExp('chrome|crios');
    final edge = RegExp('edge|opr');

    final isChrome = chrom.hasMatch(agent) && !edge.hasMatch(agent);
    final isBrave = isChrome && (window.navigator.mimeTypes?.isEmpty ?? true);
    return isBrave;
  }

  /// Check if Opera is the current browser
  bool isOperaBrowser() {
    final regExp = RegExp('Opera|OPR');
    final isMatching = regExp.hasMatch(window.navigator.userAgent);

    return isMatching;
  }

  /// Create and execute an HTTP request that should be blocked by an adblocker
  Future<http.Response> createBaitRequest() {
    final url = Uri.parse(
      'https://raw.githubusercontent.com/wmcmurray/just-detect-adblock/master/baits/pagead2.googlesyndication.com',
    );

    /// NOTE : it will generate traffic only when brave shields are off tho,
    /// because the request is not actually sent when the url is being blocked
    return http.get(url);
  }

  /// NOTE : brave seems to let blocked requests return
  /// a valid HTTP status code,
  /// but the content returned is empty, so we check if
  /// we see the content that we know is in our bait file
  Future<bool> doesBaitRequestIsBlockedByBrave() async {
    final response = await createBaitRequest();

    final regExp = RegExp(r'^thistextshouldbethere(\n|)$');
    final isMatching = regExp.hasMatch(response.body);

    return response.statusCode == 200 && !isMatching;
  }

  /// NOTE : opera seems to set the HTTP status code to 0
  /// and empty content, so we check if we see the content
  /// that we know is in our bait file
  Future<bool> doesBaitRequestIsBlockedByOpera() async {
    final response = await createBaitRequest();

    final regExp = RegExp(r'^thistextshouldbethere(\n|)$');
    final isMatching = regExp.hasMatch(response.body);

    return response.statusCode == 0 && !isMatching;
  }

  bool uBlockOriginDetection() {
    // Define a JavaScript function `uBlockActive` in the global context
    js.context['uBlockActive'] = () {
      // Attempt to retrieve the `adsbygoogle` object from the
      // global JavaScript context
      final adsbygoogle = js.context['adsbygoogle'];

      // Check if the `adsbygoogle` object exists and has a `push`
      // method with non-empty content
      if (adsbygoogle != null &&
          adsbygoogle.callMethod('push', []).length > 0) {
        // If ads are present, uBlock Origin is not active
        return false;
      }
      // If no ads are detected, assume uBlock Origin is active
      return true;
    };

    // Call the `uBlockActive` JavaScript function and return its result
    return js.context.callMethod('uBlockActive');
  }
}
