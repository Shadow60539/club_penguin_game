
import 'package:social_media_game/domain/chat/word_list.dart';

/// Bad Word Filter
class BadWordFilter {
  /// isProfane returns a boolean value representing if the string provided contains a profane word
  bool isProfane(String stringToTest) {
    final lowerCaseStringToTest = stringToTest.toLowerCase();
    return wordList
        .where((word) => lowerCaseStringToTest.contains(word))
        .isNotEmpty;
  }

  /// replace tests a string, replacing bad words with an asterisk length string of equal length
  static String clean(String stringToObfuscate) {
    final listToTest = stringToObfuscate.split(' ');
    final clean = listToTest.map((e) {
      if (wordSet.contains(e.toLowerCase())) {
        return e.replaceAll(RegExp('.'), '*');
      }
      return e;
    });

    return clean.join(' ');
  }
}
