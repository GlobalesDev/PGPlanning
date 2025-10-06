// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get saludo => 'Bem-vindo,';

  @override
  String get otroUsuario => 'Entrar com outro utilizador';

  @override
  String get pistaEmail => 'Introduza o seu e-mail';

  @override
  String get cancelarBiometricos =>
      'O utilizador cancelou a operação de entrada por biometria';

  @override
  String get usoPass => 'Usar palavra-passe';

  @override
  String get usoPassAcceso => 'Introduza a palavra-passe de entrada';

  @override
  String get pistaPass => 'Introduza a sua palavra-passe';

  @override
  String get pistaBiometricos =>
      'Passe o dedo sobre o sensor do seu dispositivo';

  @override
  String get usoBiometricos => 'Use biometria';

  @override
  String get btnAcceso => 'Entrar';

  @override
  String get btnRecuperarPass => 'Recuperar a palavra-passe?';

  @override
  String get sincroDatos => 'A sincronizar dados';

  @override
  String get recuperarSecciones => 'A recuperar dados das secções.';

  @override
  String get verificandoUser => 'A verificar dados, por favor aguarde.';

  @override
  String get selectEmpresa => 'Selecione Colaborador';

  @override
  String get selectArea => 'Selecione a Área';

  @override
  String get selectFile => 'Selecione a Planificação';

  @override
  String get selectEmpleado => 'Selecione o Colaborador';

  @override
  String get aceptarM => 'ACEITAR';

  @override
  String get user => 'Utilizador';

  @override
  String get empresa => 'Empresa';

  @override
  String get area => 'Área';

  @override
  String get planificacion => 'Planificação';

  @override
  String get ultimaConexion => 'Última ligação';

  @override
  String get inicioSesion => 'Entrar';

  @override
  String get cerrarSesion => 'Sair';

  @override
  String get cambiarClave => 'Alterar chave';

  @override
  String get cambiarPlan => 'Alterar planificação';

  @override
  String get reconfigAuth2 => 'Reconfigurar aut. 2-passos';

  @override
  String get eliminarAuth2 => 'Eliminar aut. 2-passos';

  @override
  String get inicio => 'Início';

  @override
  String get principal => 'Principal';

  @override
  String get planificacionCaducada =>
      'Esta planificação já não está em vigor (caducou)';

  @override
  String get cambiarPlanificacion => 'Alterar a planificação';

  @override
  String get tituloCambioClave => 'Gerar / Alterar a chave de transferência';

  @override
  String get cuerpoCambioClave =>
      'Para gerar/alterar a sua chave de transferência, deve introduzir a palavra-passe atual de acesso ao portal do colaborador e a nova chave de transferência, duas vezes. Lembre-se de que a nova chave deve ter pelo menos 4 caracteres.';

  @override
  String get contraUser => 'Palavra-passe do utilizador';

  @override
  String get claveDescarga => 'Chave de transferência';

  @override
  String get repetirClave => 'Repetir a chave';

  @override
  String get cancelar => 'Cancelar';

  @override
  String get idioma => 'Língua';

  @override
  String get cargando => 'Carregamento...';
}
