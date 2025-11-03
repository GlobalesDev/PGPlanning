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
  String get aceptar => 'Aceitar';

  @override
  String get user => 'Usuário';

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

  @override
  String get errorLogin => 'Erro no login';

  @override
  String get incorrectPassword => 'Palavra-passe incorreta';

  @override
  String get passwordsDoNotMatch => 'As palavras-passe não coincidem';

  @override
  String get passwordRequirementsNotMet =>
      'A palavra-passe não cumpre os requisitos';

  @override
  String get passwordRequirementsDetail =>
      'A palavra-passe deve ter pelo menos 8 caracteres, uma maiúscula, uma minúscula, um número e um carácter especial';

  @override
  String get changePassword => 'Alterar palavra-passe';

  @override
  String get close => 'Fechar';

  @override
  String get passwordChangedInfo =>
      'Tem de alterar a palavra-passe para aceder ao sistema.';

  @override
  String get repeatPassword => 'Repetir palavra-passe';

  @override
  String get newPassword => 'Nova palavra-passe';

  @override
  String get passwordNoSpaces => 'A palavra-passe não pode conter espaços';

  @override
  String get processing => 'A processar...';

  @override
  String get passwordExpired => 'A sua palavra-passe expirou.';

  @override
  String get change => 'Alterar';

  @override
  String get errorRegisteringUser =>
      'Ocorreu um erro ao registar o utilizador, tente novamente e se o problema persistir contacte o suporte.';

  @override
  String get userOrPassNotValid =>
      'O utilizador e/ou palavra-passe não são válidos.';

  @override
  String get unlockPassNotMatch => 'A palavra-passe não é válida.';

  @override
  String get userAssociatedWithTokenNotFound =>
      'O utilizador não foi encontrado ou expirou, volte a iniciar sessão.';

  @override
  String get needUnlockWithPassword =>
      'É necessário desbloquear com palavra-passe';

  @override
  String get errorEmailAndPasswordRequired =>
      'Introduza um e-mail e uma palavra-passe';

  @override
  String get errorEmailRequired => 'Introduza um e-mail';

  @override
  String get errorPasswordRequired => 'Introduza uma palavra-passe';

  @override
  String get errorSessionExpired => 'Sessão expirada';

  @override
  String get errorSessionMustLogin =>
      'A sessão expirou, deve iniciar sessão novamente.';

  @override
  String get errorLoginMethodNotRecognized => 'Método de login não reconhecido';

  @override
  String get errorCache => 'Erro de cache';

  @override
  String get passwordUpdatedTitle => 'Senha atualizada';

  @override
  String get passwordUpdatedText =>
      'Sua senha foi atualizada com sucesso, você pode fazer login novamente com a nova senha.';

  @override
  String get weakPasswordStrength =>
      'A nova senha não atende aos requisitos de complexidade.';

  @override
  String get errorSavingTryAgain =>
      'Ocorreu um erro ao tentar salvar a nova senha.';

  @override
  String get passwordRecentlyUsed =>
      'A nova senha não atende ao requisito de histórico de senhas.';

  @override
  String get newPasswordsNotMatch =>
      'A nova senha e sua repetição não coincidem.';

  @override
  String get userOrPassNotValidCurrent => 'A senha atual não está correta.';

  @override
  String get errorNewPass => 'Erro ao alterar a senha';
}
