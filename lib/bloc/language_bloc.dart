import 'package:flutter/foundation.dart';

import '../data/local/shared_prefs.dart';
import '../locale/arabic.dart';
import '../locale/english.dart';
import '../resources/strings.dart';

class LangBloc with ChangeNotifier {
  static const _languagesText = {
    'english': 'English',
    'arabic': 'عربي',
  };

  static const _translations = {
    'english': englishTranslations,
    'arabic': arabicTranslations,
  };

  String _current = 'english';
  Map<Strings, String> _translation = englishTranslations;
  bool? _toApp;

  Future init() async {
    var language = await Prefs.getLanguage();
    var toApp = await Prefs.getAppLanguage();
    _current = language ?? _current;
    _toApp = toApp ?? false;
    if (_toApp!) {
      _translation = _translations[_current] ?? englishTranslations;
    } else {
      _translation = englishTranslations;
    }
  }

  Map<String, String> get languagesText => _languagesText;

  String get currentLanguage => _current;

  String? get currentLanguageText => _languagesText[_current];

  String getString(Strings key) {
    return _translation[key] ?? englishTranslations[key] ?? '**Not defined**';
  }

  String getEnglishString(Strings key) {
    return englishTranslations[key] ?? '**Not defined**';
  }

  Future<void> saveLanguage({
    required String language,
    required bool toApp,
  }) async {
    _toApp = toApp;
    _current = language;

    await Prefs.setLanguage(language);
    await Prefs.setAppLanguage(toApp);

    if (_toApp != null && _toApp!) {
      _translation = _translations[_current] ?? englishTranslations;
    } else {
      _translation = englishTranslations;
    }
    notifyListeners();
  }

  String? get appLanguage =>
      _toApp != null && _toApp! ? languagesText[_current] : 'English';
}
