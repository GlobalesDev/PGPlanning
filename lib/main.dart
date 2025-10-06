import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:p_g_planning/flutter_flow/textScaleFactorClamper.dart';
import 'package:p_g_planning/l10n/app_localizations.dart';
import 'package:p_g_planning/model/locale.dart';

import 'package:p_g_planning/servicio_cache.dart';
import 'package:provider/provider.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  usePathUrlStrategy();

  await ServicioCache.configurePrefs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    // Si la cache esta vacia significa que es un login nuevo por lo que establemos el
    // idioma del dispositivo como el idioma seleccionado de la app
    var cache = ServicioCache.prefs.getKeys();
    print(cache);
    if (!cache.contains('usuario_pemp')) {
      _locale = Locale(Platform.localeName);
      ServicioCache.prefs
          .setString('language', _locale!.languageCode.split('_')[0]);
    } else {
      var lng = ServicioCache.prefs.getString('language');
      if (lng == null) {
        _locale = Locale(Platform.localeName);
        ServicioCache.prefs
            .setString('language', _locale!.languageCode.split('_')[0]);
      } else {
        _locale = Locale(lng);
        ServicioCache.prefs.setString('language', _locale!.languageCode);
      }
    }

    FlutterNativeSplash.remove();
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(_locale),
      child: TextScaleFactorClamper(
        child: Consumer<LocaleModel>(
          builder: (context, localeModel, child) => MaterialApp.router(
            restorationScopeId: 'app', // Add
            title: 'PGPlanning',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeModel.locale, //_locale,
            theme: ThemeData(
              brightness: Brightness.light,
              scrollbarTheme: const ScrollbarThemeData(),
            ),
            themeMode: _themeMode,
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}
