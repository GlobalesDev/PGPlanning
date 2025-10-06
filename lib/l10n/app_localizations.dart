import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @saludo.
  ///
  /// In es, this message translates to:
  /// **'Buenos días,'**
  String get saludo;

  /// No description provided for @otroUsuario.
  ///
  /// In es, this message translates to:
  /// **'Entrar con otro usuario'**
  String get otroUsuario;

  /// No description provided for @pistaEmail.
  ///
  /// In es, this message translates to:
  /// **'Introduzca su email'**
  String get pistaEmail;

  /// No description provided for @cancelarBiometricos.
  ///
  /// In es, this message translates to:
  /// **'El usuario ha cancelado la operacion de acceso mediante biométricos'**
  String get cancelarBiometricos;

  /// No description provided for @usoPass.
  ///
  /// In es, this message translates to:
  /// **'Usar contraseña'**
  String get usoPass;

  /// No description provided for @usoPassAcceso.
  ///
  /// In es, this message translates to:
  /// **'Introduzca la contraseña de acceso'**
  String get usoPassAcceso;

  /// No description provided for @pistaPass.
  ///
  /// In es, this message translates to:
  /// **'Introduzca su contraseña'**
  String get pistaPass;

  /// No description provided for @pistaBiometricos.
  ///
  /// In es, this message translates to:
  /// **'Pase el dedo por el sensor de su dispositivo'**
  String get pistaBiometricos;

  /// No description provided for @usoBiometricos.
  ///
  /// In es, this message translates to:
  /// **'Usar biométricos'**
  String get usoBiometricos;

  /// No description provided for @btnAcceso.
  ///
  /// In es, this message translates to:
  /// **'Acceder'**
  String get btnAcceso;

  /// No description provided for @btnRecuperarPass.
  ///
  /// In es, this message translates to:
  /// **'¿Recuperar contraseña?'**
  String get btnRecuperarPass;

  /// No description provided for @sincroDatos.
  ///
  /// In es, this message translates to:
  /// **'Sincronizando datos'**
  String get sincroDatos;

  /// No description provided for @recuperarSecciones.
  ///
  /// In es, this message translates to:
  /// **'Recuperando datos de secciones.'**
  String get recuperarSecciones;

  /// No description provided for @verificandoUser.
  ///
  /// In es, this message translates to:
  /// **'Verificando datos, por favor espere.'**
  String get verificandoUser;

  /// No description provided for @selectEmpresa.
  ///
  /// In es, this message translates to:
  /// **'Seleccione Empleado'**
  String get selectEmpresa;

  /// No description provided for @selectArea.
  ///
  /// In es, this message translates to:
  /// **'Seleccione Area'**
  String get selectArea;

  /// No description provided for @selectFile.
  ///
  /// In es, this message translates to:
  /// **'Seleccione Planificacion'**
  String get selectFile;

  /// No description provided for @selectEmpleado.
  ///
  /// In es, this message translates to:
  /// **'Seleccione Empleado'**
  String get selectEmpleado;

  /// No description provided for @aceptarM.
  ///
  /// In es, this message translates to:
  /// **'ACEPTAR'**
  String get aceptarM;

  /// No description provided for @user.
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// No description provided for @empresa.
  ///
  /// In es, this message translates to:
  /// **'Empresa'**
  String get empresa;

  /// No description provided for @area.
  ///
  /// In es, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @planificacion.
  ///
  /// In es, this message translates to:
  /// **'Planificación'**
  String get planificacion;

  /// No description provided for @ultimaConexion.
  ///
  /// In es, this message translates to:
  /// **'Última conexión'**
  String get ultimaConexion;

  /// No description provided for @inicioSesion.
  ///
  /// In es, this message translates to:
  /// **'Inicio sesión'**
  String get inicioSesion;

  /// No description provided for @cerrarSesion.
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get cerrarSesion;

  /// No description provided for @cambiarClave.
  ///
  /// In es, this message translates to:
  /// **'Cambiar clave'**
  String get cambiarClave;

  /// No description provided for @cambiarPlan.
  ///
  /// In es, this message translates to:
  /// **'Cambiar plan'**
  String get cambiarPlan;

  /// No description provided for @reconfigAuth2.
  ///
  /// In es, this message translates to:
  /// **'Reconfigurar aut. 2-pasos'**
  String get reconfigAuth2;

  /// No description provided for @eliminarAuth2.
  ///
  /// In es, this message translates to:
  /// **'Eliminar aut. 2-pasos'**
  String get eliminarAuth2;

  /// No description provided for @inicio.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get inicio;

  /// No description provided for @principal.
  ///
  /// In es, this message translates to:
  /// **'Principal'**
  String get principal;

  /// No description provided for @planificacionCaducada.
  ///
  /// In es, this message translates to:
  /// **'Esta planificación ya no esta en vigor (ha caducado)'**
  String get planificacionCaducada;

  /// No description provided for @cambiarPlanificacion.
  ///
  /// In es, this message translates to:
  /// **'Cambiar planificación'**
  String get cambiarPlanificacion;

  /// No description provided for @tituloCambioClave.
  ///
  /// In es, this message translates to:
  /// **'Generar / Cambiar clave de descarga'**
  String get tituloCambioClave;

  /// No description provided for @cuerpoCambioClave.
  ///
  /// In es, this message translates to:
  /// **'Para generar/cambiar su clave de descarga, debe introducir la contraseña actual de acceso al portal del empleado y la nueva clave de descarga, por duplicado. Recuerde que la nueva clave debe ser de al menos 4 caracteres.'**
  String get cuerpoCambioClave;

  /// No description provided for @contraUser.
  ///
  /// In es, this message translates to:
  /// **'Contraseña de usuario'**
  String get contraUser;

  /// No description provided for @claveDescarga.
  ///
  /// In es, this message translates to:
  /// **'Clave descarga'**
  String get claveDescarga;

  /// No description provided for @repetirClave.
  ///
  /// In es, this message translates to:
  /// **'Repetir clave'**
  String get repetirClave;

  /// No description provided for @cancelar.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancelar;

  /// No description provided for @idioma.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get idioma;

  /// No description provided for @cargando.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get cargando;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
