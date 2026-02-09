
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeController with ChangeNotifier {
  Locale? _appLocale;

  Locale? get appLocale => _appLocale;

  void changeLanguage(Locale type) async {
    print('Changing language to: $type');

    SharedPreferences sp = await SharedPreferences.getInstance();
    _appLocale = type;

    // Set the language code based on the locale
    String languageCode = type.languageCode;
    await sp.setString("language_code", languageCode);

    notifyListeners(); // Notify listeners about the language change
  }

  // Add a method to get the saved language
  Future<void> loadLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? languageCode = sp.getString('language_code');
    _appLocale = languageCode != null ? Locale(languageCode) : Locale('en'); // Default to English if no language is saved
    // Update the app's locale
    notifyListeners();
  }

  // Add methods for changing language to specific locales
  void changeToEnglish() => changeLanguage(const Locale('en'));
  void changeToArabic() => changeLanguage(const Locale('ar'));

}
