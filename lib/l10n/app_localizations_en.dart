// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get saludo => 'Welcome,';

  @override
  String get otroUsuario => 'Login with another user';

  @override
  String get pistaEmail => 'Enter your email';

  @override
  String get cancelarBiometricos =>
      'The user has canceled the biometric login operation';

  @override
  String get usoPass => 'Use password';

  @override
  String get usoPassAcceso => 'Enter the login password';

  @override
  String get pistaPass => 'Enter your password';

  @override
  String get pistaBiometricos =>
      'Swipe your finger across the sensor on your device';

  @override
  String get usoBiometricos => 'Use biometrics';

  @override
  String get btnAcceso => 'Login';

  @override
  String get btnRecuperarPass => 'Recover password?';

  @override
  String get sincroDatos => 'Synchronizing data';

  @override
  String get recuperarSecciones => 'Retrieving data from sections.';

  @override
  String get verificandoUser => 'Verifying data, please wait.';

  @override
  String get selectEmpresa => 'Select Employee';

  @override
  String get selectArea => 'Select Area';

  @override
  String get selectFile => 'Select Planning';

  @override
  String get selectEmpleado => 'Select Employee';

  @override
  String get aceptarM => 'ACCEPT';

  @override
  String get user => 'User';

  @override
  String get empresa => 'Company';

  @override
  String get area => 'Area';

  @override
  String get planificacion => 'Planning';

  @override
  String get ultimaConexion => 'Last connection';

  @override
  String get inicioSesion => 'Login';

  @override
  String get cerrarSesion => 'Logout';

  @override
  String get cambiarClave => 'Change key';

  @override
  String get cambiarPlan => 'Change planning';

  @override
  String get reconfigAuth2 => 'Reconfigure 2-step aut.';

  @override
  String get eliminarAuth2 => 'Delete 2-step aut.';

  @override
  String get inicio => 'Home';

  @override
  String get principal => 'Main';

  @override
  String get planificacionCaducada =>
      'This planning is no longer in effect (it has expired)';

  @override
  String get cambiarPlanificacion => 'Change planning';

  @override
  String get tituloCambioClave => 'Generate / Change download key';

  @override
  String get cuerpoCambioClave =>
      'To generate/change your download key, you must enter the current password for accessing the employee portal and the new download key, twice. Remember that the new key must be at least 4 characters long.';

  @override
  String get contraUser => 'User\'s password';

  @override
  String get claveDescarga => 'Download key';

  @override
  String get repetirClave => 'Repeat key';

  @override
  String get cancelar => 'Cancel';

  @override
  String get idioma => 'Language';

  @override
  String get cargando => 'Loading...';
}
