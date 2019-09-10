/*
 * Copyright (c) 2015-2019 StoneHui
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gank/i10n/localization_intl.dart';
import 'package:provide/provide.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {

  static ThemeData _createThemeData(Color primaryColor) {
    return ThemeData(primarySwatch: primaryColor);
  }

  static final Map<String, ThemeData> themeMap = {
    "blue": _createThemeData(Colors.blue),
    "indigo": _createThemeData(Colors.indigo),
    "cyan": _createThemeData(Colors.cyan),
    "yellow": _createThemeData(Colors.yellow),
    "lime": _createThemeData(Colors.lime),
    "amber": _createThemeData(Colors.amber),
    "orange": _createThemeData(Colors.orange),
    "red": _createThemeData(Colors.red),
    "pink": _createThemeData(Colors.pink),
    "purple": _createThemeData(Colors.purple),
    "green": _createThemeData(Colors.green),
    "teal": _createThemeData(Colors.teal),
  };

  static final Map<String, Locale> localeMap = {
    "中文简体": Locale("zh", "CN"),
    "English (US)": Locale("en", "US"),
  };

  ThemeData theme;
  Locale locale;
}

class SettingModel extends Settings with ChangeNotifier {
  final String _keyTheme = "Theme";
  final String _keyLocale = "Locale";

  SettingModel() {
    _init();
  }

  void _init() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    theme = Settings.themeMap[preferences.get(_keyTheme) ?? Settings.themeMap.keys.first];
    locale = Settings.localeMap[preferences.get(_keyLocale) ?? Settings.localeMap.keys.first];
    notifyListeners();
  }

  Future setTheme(BuildContext context, ThemeData themeData) async {
    if (!Settings.themeMap.containsValue(themeData)) {
      throw Exception(GankLocalizations.of(context).themeError);
    }
    this.theme = themeData;

    for (String themeName in Settings.themeMap.keys) {
      if (Settings.themeMap[themeName] == themeData) {
        (await SharedPreferences.getInstance()).setString(_keyTheme, themeName);
        break;
      }
    }

    notifyListeners();
  }

  Future setLocale(BuildContext context, Locale locale) async {
    if (!Settings.localeMap.containsValue(locale)) {
      throw Exception(GankLocalizations.of(context).localeError);
    }
    this.locale = locale;

    for (String localeName in Settings.localeMap.keys) {
      if (Settings.localeMap[localeName] == locale) {
        (await SharedPreferences.getInstance()).setString(_keyLocale, localeName);
        break;
      }
    }

    notifyListeners();
  }
}

class Store {
  static ProviderNode init({Widget child, dispose = true}) {
    final providers = Providers()..provide(Provider.value(SettingModel()));
    return ProviderNode(child: child, providers: providers, dispose: dispose);
  }

  static Provide<T> connect<T>({ValueBuilder<T> builder, Widget child, ProviderScope scope}) {
    return Provide<T>(builder: builder, child: child, scope: scope);
  }

  static T value<T>(BuildContext context, {ProviderScope scope}) {
    return Provide.value<T>(context, scope: scope);
  }
}