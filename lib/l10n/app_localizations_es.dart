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
  String get aceptar => 'Aceptar';

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

  @override
  String get errorLogin => 'Error en el login';

  @override
  String get incorrectPassword => 'Contraseña incorrecta';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordRequirementsNotMet =>
      'La contraseña no cumple los requisitos';

  @override
  String get passwordRequirementsDetail =>
      'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un carácter especial';

  @override
  String get changePassword => 'Cambio de contraseña';

  @override
  String get close => 'Cerrar';

  @override
  String get passwordChangedInfo =>
      'Debe cambiar la contraseña para acceder al sistema.';

  @override
  String get repeatPassword => 'Repetir contraseña';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get passwordNoSpaces => 'La contraseña no puede contener espacios';

  @override
  String get processing => 'Procesando...';

  @override
  String get passwordExpired => 'Su contraseña ha caducado.';

  @override
  String get change => 'Cambiar';

  @override
  String get errorRegisteringUser =>
      'Ocurrió un error al registrar el usuario, vuelva a intentarlo y si el problema persiste contacte con soporte.';

  @override
  String get userOrPassNotValid => 'El usuario y/o contraseña no son válidos.';

  @override
  String get unlockPassNotMatch => 'La contraseña no es válida.';

  @override
  String get userAssociatedWithTokenNotFound =>
      'El usuario no ha sido encontrado o ha caducado, vuelva a logearse.';

  @override
  String get needUnlockWithPassword =>
      'Se necesita un un desbloqueo con contraseña';

  @override
  String get errorEmailAndPasswordRequired =>
      'Introduce un email y una contraseña';

  @override
  String get errorEmailRequired => 'Introduce un email';

  @override
  String get errorPasswordRequired => 'Introduce una contraseña';

  @override
  String get errorSessionExpired => 'Sesion caducada';

  @override
  String get errorSessionMustLogin =>
      'La sesión ha caducado, debe realizar un login completo.';

  @override
  String get errorLoginMethodNotRecognized => 'Metodo de login no reconocido';

  @override
  String get errorCache => 'Error de cache';

  @override
  String get passwordUpdatedTitle => 'Contraseña actualizada';

  @override
  String get passwordUpdatedText =>
      'Su contraseña ha sido actualizada satisfactoriamente, puede volver a logearse con la nueva contraseña.';

  @override
  String get weakPasswordStrength =>
      'La nueva contraseña no cumple los requisitos de complejidad.';

  @override
  String get errorSavingTryAgain =>
      'Ha ocurrido un error al intentar guardar la nueva contraseña.';

  @override
  String get passwordRecentlyUsed =>
      'La nueva contraseña no cumple el requisito de historico de contraseñas.';

  @override
  String get newPasswordsNotMatch =>
      'La nueva contraseña y su repeticion no coinciden.';

  @override
  String get userOrPassNotValidCurrent =>
      'La actual contraseña no es correcta.';

  @override
  String get errorNewPass => 'Error en el cambio de contraseña';
}
