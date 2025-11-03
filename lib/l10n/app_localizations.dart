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

  /// No description provided for @aceptar.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get aceptar;

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

  /// No description provided for @errorLogin.
  ///
  /// In es, this message translates to:
  /// **'Error en el login'**
  String get errorLogin;

  /// No description provided for @incorrectPassword.
  ///
  /// In es, this message translates to:
  /// **'Contraseña incorrecta'**
  String get incorrectPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordRequirementsNotMet.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no cumple los requisitos'**
  String get passwordRequirementsNotMet;

  /// No description provided for @passwordRequirementsDetail.
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial'**
  String get passwordRequirementsDetail;

  /// No description provided for @changePassword.
  ///
  /// In es, this message translates to:
  /// **'Cambio de contraseña'**
  String get changePassword;

  /// No description provided for @close.
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// No description provided for @passwordChangedInfo.
  ///
  /// In es, this message translates to:
  /// **'Debe cambiar la contraseña para acceder al sistema.'**
  String get passwordChangedInfo;

  /// No description provided for @repeatPassword.
  ///
  /// In es, this message translates to:
  /// **'Repetir contraseña'**
  String get repeatPassword;

  /// No description provided for @newPassword.
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get newPassword;

  /// No description provided for @passwordNoSpaces.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no puede contener espacios'**
  String get passwordNoSpaces;

  /// No description provided for @processing.
  ///
  /// In es, this message translates to:
  /// **'Procesando...'**
  String get processing;

  /// No description provided for @passwordExpired.
  ///
  /// In es, this message translates to:
  /// **'Su contraseña ha caducado.'**
  String get passwordExpired;

  /// No description provided for @change.
  ///
  /// In es, this message translates to:
  /// **'Cambiar'**
  String get change;

  /// No description provided for @errorRegisteringUser.
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error al registrar el usuario, vuelva a intentarlo y si el problema persiste contacte con soporte.'**
  String get errorRegisteringUser;

  /// No description provided for @userOrPassNotValid.
  ///
  /// In es, this message translates to:
  /// **'El usuario y/o contraseña no son válidos.'**
  String get userOrPassNotValid;

  /// No description provided for @unlockPassNotMatch.
  ///
  /// In es, this message translates to:
  /// **'La contraseña no es válida.'**
  String get unlockPassNotMatch;

  /// No description provided for @userAssociatedWithTokenNotFound.
  ///
  /// In es, this message translates to:
  /// **'El usuario no ha sido encontrado o ha caducado, vuelva a logearse.'**
  String get userAssociatedWithTokenNotFound;

  /// No description provided for @needUnlockWithPassword.
  ///
  /// In es, this message translates to:
  /// **'Se necesita un un desbloqueo con contraseña'**
  String get needUnlockWithPassword;

  /// No description provided for @errorEmailAndPasswordRequired.
  ///
  /// In es, this message translates to:
  /// **'Introduce un email y una contraseña'**
  String get errorEmailAndPasswordRequired;

  /// No description provided for @errorEmailRequired.
  ///
  /// In es, this message translates to:
  /// **'Introduce un email'**
  String get errorEmailRequired;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In es, this message translates to:
  /// **'Introduce una contraseña'**
  String get errorPasswordRequired;

  /// No description provided for @errorSessionExpired.
  ///
  /// In es, this message translates to:
  /// **'Sesion caducada'**
  String get errorSessionExpired;

  /// No description provided for @errorSessionMustLogin.
  ///
  /// In es, this message translates to:
  /// **'La sesión ha caducado, debe realizar un login completo.'**
  String get errorSessionMustLogin;

  /// No description provided for @errorLoginMethodNotRecognized.
  ///
  /// In es, this message translates to:
  /// **'Metodo de login no reconocido'**
  String get errorLoginMethodNotRecognized;

  /// No description provided for @errorCache.
  ///
  /// In es, this message translates to:
  /// **'Error de cache'**
  String get errorCache;

  /// No description provided for @passwordUpdatedTitle.
  ///
  /// In es, this message translates to:
  /// **'Contraseña actualizada'**
  String get passwordUpdatedTitle;

  /// No description provided for @passwordUpdatedText.
  ///
  /// In es, this message translates to:
  /// **'Su contraseña ha sido actualizada satisfactoriamente, puede volver a logearse con la nueva contraseña.'**
  String get passwordUpdatedText;

  /// No description provided for @weakPasswordStrength.
  ///
  /// In es, this message translates to:
  /// **'La nueva contraseña no cumple los requisitos de complejidad.'**
  String get weakPasswordStrength;

  /// No description provided for @errorSavingTryAgain.
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error al intentar guardar la nueva contraseña.'**
  String get errorSavingTryAgain;

  /// No description provided for @passwordRecentlyUsed.
  ///
  /// In es, this message translates to:
  /// **'La nueva contraseña no cumple el requisito de historico de contraseñas.'**
  String get passwordRecentlyUsed;

  /// No description provided for @newPasswordsNotMatch.
  ///
  /// In es, this message translates to:
  /// **'La nueva contraseña y su repeticion no coinciden.'**
  String get newPasswordsNotMatch;

  /// No description provided for @userOrPassNotValidCurrent.
  ///
  /// In es, this message translates to:
  /// **'La actual contraseña no es correcta.'**
  String get userOrPassNotValidCurrent;

  /// No description provided for @errorNewPass.
  ///
  /// In es, this message translates to:
  /// **'Error en el cambio de contraseña'**
  String get errorNewPass;
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
