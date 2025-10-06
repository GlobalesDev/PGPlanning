// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get saludo => 'Buenos días,';

  @override
  String get otroUsuario => 'Entrar con otro usuario';

  @override
  String get pistaEmail => 'Introduzca su email';

  @override
  String get cancelarBiometricos =>
      'El usuario ha cancelado la operacion de acceso mediante biométricos';

  @override
  String get usoPass => 'Usar contraseña';

  @override
  String get usoPassAcceso => 'Introduzca la contraseña de acceso';

  @override
  String get pistaPass => 'Introduzca su contraseña';

  @override
  String get pistaBiometricos => 'Pase el dedo por el sensor de su dispositivo';

  @override
  String get usoBiometricos => 'Usar biométricos';

  @override
  String get btnAcceso => 'Acceder';

  @override
  String get btnRecuperarPass => '¿Recuperar contraseña?';

  @override
  String get sincroDatos => 'Sincronizando datos';

  @override
  String get recuperarSecciones => 'Recuperando datos de secciones.';

  @override
  String get verificandoUser => 'Verificando datos, por favor espere.';

  @override
  String get selectEmpresa => 'Seleccione Empleado';

  @override
  String get selectArea => 'Seleccione Area';

  @override
  String get selectFile => 'Seleccione Planificacion';

  @override
  String get selectEmpleado => 'Seleccione Empleado';

  @override
  String get aceptarM => 'ACEPTAR';

  @override
  String get user => 'Usuario';

  @override
  String get empresa => 'Empresa';

  @override
  String get area => 'Area';

  @override
  String get planificacion => 'Planificación';

  @override
  String get ultimaConexion => 'Última conexión';

  @override
  String get inicioSesion => 'Inicio sesión';

  @override
  String get cerrarSesion => 'Cerrar sesión';

  @override
  String get cambiarClave => 'Cambiar clave';

  @override
  String get cambiarPlan => 'Cambiar plan';

  @override
  String get reconfigAuth2 => 'Reconfigurar aut. 2-pasos';

  @override
  String get eliminarAuth2 => 'Eliminar aut. 2-pasos';

  @override
  String get inicio => 'Inicio';

  @override
  String get principal => 'Principal';

  @override
  String get planificacionCaducada =>
      'Esta planificación ya no esta en vigor (ha caducado)';

  @override
  String get cambiarPlanificacion => 'Cambiar planificación';

  @override
  String get tituloCambioClave => 'Generar / Cambiar clave de descarga';

  @override
  String get cuerpoCambioClave =>
      'Para generar/cambiar su clave de descarga, debe introducir la contraseña actual de acceso al portal del empleado y la nueva clave de descarga, por duplicado. Recuerde que la nueva clave debe ser de al menos 4 caracteres.';

  @override
  String get contraUser => 'Contraseña de usuario';

  @override
  String get claveDescarga => 'Clave descarga';

  @override
  String get repetirClave => 'Repetir clave';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get idioma => 'Idioma';

  @override
  String get cargando => 'Cargando...';
}
