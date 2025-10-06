import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:p_g_planning/l10n/app_localizations.dart';
import 'package:p_g_planning/model/empLoginConfig.dart';
import 'package:p_g_planning/model/locale.dart';
import 'package:p_g_planning/model/two_FAuth_stepObject.dart';
import 'package:p_g_planning/model/two_FAuth_validation.dart';
import 'package:p_g_planning/model/usuario_pemp.dart';
import 'package:p_g_planning/model/parametros/parametros.dart';
import 'package:device_info/device_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:p_g_planning/servicio_cache.dart';

import '/components/menu_lateral_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'inicio_model.dart';
export 'inicio_model.dart';

import 'package:webview_flutter/webview_flutter.dart' as webview;
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InicioWidget extends StatefulWidget {
  const InicioWidget({Key? key}) : super(key: key);

  @override
  _InicioWidgetState createState() => _InicioWidgetState();
}

class _InicioWidgetState extends State<InicioWidget>
    with WidgetsBindingObserver {
  late InicioModel _model;

  /// Variables
  EmpLoginConfig? empLoginConfig;
  Usuario_pemp? usuario_pemp;
  bool estadoLogin = false;

  Widget? contenidoActual;

  late TextEditingController editArea;
  bool cargando = false;

  /// Variables para controlar los biometricos
  final LocalAuthentication _localAuth = LocalAuthentication();
  List<BiometricType> biometricTypes = [];
  bool _isBiometricSupported = false;
  bool _isBiometricEnabled = false;
  bool isWaitingAuth = false;
  bool authCancel = false;

  String? _checkToken;
  String? _userEmail;
  String? _pass;

  Timer? temporizador;

  BuildContext? dcontext;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InicioModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController1Validator = (p0, p1) {
      _model.textController1!.text = p1!;
      return p1;
    };
    _model.textController2Validator = (p0, p1) {
      _model.textController2!.text = p1!;
      return p1;
    };

    editArea = TextEditingController();

    comprobarBioMetricos();
    obtenerMetodosBiometricos();

    cargarParametros();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    scaffoldKey.currentState!.closeDrawer();
  }

  /// Funcion que comprueba si existen actualizaciones disponibles
  ///
  void checkForNewAppUpdateAvailability() {
    if (isAndroid) {
    } else if (isiOS) {}
  }

  /// Funcion que comprueba si el dispositivo tiene medios biometricos configurados
  ///
  Future<void> comprobarBioMetricos() async {
    try {
      _isBiometricSupported = await _localAuth.canCheckBiometrics;
      setState(() {});
    } on PlatformException catch (e) {
      _isBiometricSupported = false;
    }
  }

  /// Funcion que comprueba los medios biometricos que tiene instalado el disposivo
  ///
  Future<void> obtenerMetodosBiometricos() async {
    try {
      biometricTypes = await _localAuth.getAvailableBiometrics();
      if (biometricTypes.isEmpty) {
        _isBiometricEnabled = false;
      } else {
        _isBiometricEnabled = true;
        if (estadoLogin) {
          await autenticacionBiometrica();
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
      biometricTypes = [];
    }

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  /// Funcion que autentica al usuario mediante una clave biometrica
  ///
  Future<void> autenticacionBiometrica() async {
    setState(() {
      isWaitingAuth = true;
    });

    try {
      final autentificado = await _localAuth.authenticate(
          localizedReason: "Autentificar con Huella o Face ID",
          options: const AuthenticationOptions(
              stickyAuth: true, biometricOnly: true));

      if (autentificado) {
        validarYComprobarDatos("fingerprint");
      } else {
        setState(() {
          authCancel = true;
        });

        temporizador = Timer(const Duration(seconds: 5), () {
          setState(() {
            authCancel = false;
          });
        });

        // Error
        if (kDebugMode) {
          print("Mal Autentificado");
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    setState(() {
      isWaitingAuth = false;
    });
  }

  ///
  ///
  void annotateBiometricUnlock(String emailUser, String checkToken,
      TwoFAuth_validation? twoFAuth_validation) async {
    comprobarCredenciales();

    temporizador = Timer(const Duration(seconds: 2), () async {
      if (dcontext != null) {
        Navigator.pop(dcontext!);
      }
      var body = {"emailEmp": emailUser, "token": checkToken};
      if (twoFAuth_validation != null) {
        body.addAll({
          "twoFAuth_code": twoFAuth_validation.getCode(),
          "twoFAuth_timestamp": twoFAuth_validation.getTimestamp(),
          "twoFAuth_window": twoFAuth_validation.getFAuth_window(),
          "twoFAuth_recallCRC": twoFAuth_validation.getRecallCRC()
        });
      }
      if (isAndroid) {
        body.addAll({"origin": "APP_ANDROID"});
      } else if (isiOS) {
        body.addAll({"origin": "APP_IOS"});
      }
      Response request = await post(
          Uri.parse(
              Parametros.URL_ANDROIDPOST_LOGED_EMP_ANNOTATE_BIOMETRIC_UNLOCK),
          body: body);

      var jsonData = jsonDecode(request.body);

      print(jsonData);

      if (jsonData["resultado"] == "ok") {
        print(jsonData);
        usuario_pemp = Usuario_pemp.fromBD(jsonData['usuario']);

        if (usuario_pemp != null) {
          if (usuario_pemp!.isTwoFAuth_required() &&
              (usuario_pemp!.isTwoFAuth_configured() == false)) {
            //es necesario configurar la autenticacion en 2 pasos
            _showTwoAuthDialog(
                context, usuario_pemp!.twoFAuth_stepConfig!, "biometrics");
          } else {
            //Continuar con las acciones necesarias tras el desbloqueo con huella (o abrir sesion o saltar a la configuración
            if (empLoginConfig != null && empLoginConfig!.getIsLogged()!) {
              if (empLoginConfig!.estaTotalmenteConfigurado()) {
                setState(() {
                  cargando = true;
                });
                temporizador = Timer(const Duration(seconds: 2), () {
                  context.pushNamed("MenuPrincipal", queryParameters: {
                    'usuario_pemp': jsonEncode(usuario_pemp!.toJson()),
                    'empLoginConfig': jsonEncode(empLoginConfig!.toJson())
                  });
                });
              } else {
                if (usuario_pemp!.necesitaConfiguracion()) {
                  context.pushNamed("Configuracion");
                } else {
                  temporizador = Timer(const Duration(seconds: 2), () {
                    context.pushNamed("MenuPrincipal", queryParameters: {
                      'usuario_pemp': jsonEncode(usuario_pemp!.toJson()),
                      'empLoginConfig': jsonEncode(empLoginConfig!.toJson())
                    });
                  });
                }
              }
            } else {
              //el login no tiene acceso a nada, mostrar error y cerrar login
              if (kDebugMode) {
                print(
                    'el login no tiene acceso a nada, mostrar error y cerrar login');
              }
            }
          }
        } else {
          // El parse del JSON del usuario devuelve null
        }
      } else if (jsonData["resultado"] == "error") {
        String r_str = jsonData["result_str"];
        Map<String, String> args = {'titulo': 'Error en el login'};
        if (r_str == "TOKEN_USER_NOT_MATCH") {
          args.addAll({'texto': 'El usuario y/o contraseña no son válidos.'});
          args.addAll({'tipo': 'TOKEN_USER_NOT_MATCH'});
          _showAlertDialog(context, args);
        } else if (r_str == "USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND") {
          args.addAll({
            'texto':
                'El usuario no ha sido encontrado o ha caducado, vuelva a logearse.'
          });
          args.addAll({'tipo': 'USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND'});
          _showAlertDialog(context, args);
        } else if (r_str == "NEED_UNLOCK_WITH_PASSWORD") {
          args.addAll({'texto': 'Se necesita un un desbloqueo con contraseña'});
          args.addAll({'tipo': 'NEED_UNLOCK_WITH_PASSWORD'});
          _showAlertDialog(context, args);
        } else if (r_str == "EXPIRED_PASSWORD") {
          _showRenewPassDialog(context, emailUser);
        } else if (r_str == "2FAuth_REQUIRED") {
          var result = jsonData['2FAuthData'];

          _showTwoAuthDialog(
              context, TwoFAuth_stepObject.fromBD(result), "biometrics");
        }
      } else if (jsonData["resultado"] == "exception") {
        // Excepcion
      }
    });
  }

  /// Funcion que carga los parametros del usuario almacenados en cache
  ///
  void cargarParametros() {
    if (ServicioCache.prefs.getString("empLoginConfig") != null) {
      empLoginConfig = EmpLoginConfig.fromJSON(
          json.decode(ServicioCache.prefs.getString("empLoginConfig")!));
      if (empLoginConfig!.getIsLogged() != null) {
        if (empLoginConfig!.getUserEmail() != null &&
            empLoginConfig!.getIsLogged()!) {
          // Cargar pantalla de unlock
          estadoLogin = true;
        } else {
          // Cambiar pantalla de login
          estadoLogin = false;
        }
      }

      setState(() {});
    } else {
      estadoLogin = false;
    }
  }

  /// Funcion
  ///
  void validarYComprobarDatos(String metodo) {
    Map<String, String> args = {'titulo': 'Error en el login'};
    if (metodo == "password") {
      _pass = _model.textController2.text;
      if (empLoginConfig != null && empLoginConfig!.getIsLogged()!) {
        //estado de bloqueo, la session esta abierta, hace falta comprobar contraseña contra
        //token, no es un login completo
        //Email guardado

        _userEmail = empLoginConfig!.getUserEmail();
        _checkToken = empLoginConfig!.getToken();

        if (_userEmail!.isEmpty || _checkToken!.isEmpty) {
          // Error no esta en cache
          // Mostrar mensaje de error
          args.addAll({'texto': 'Error de cache'});
          _showAlertDialog(context, args);
        } else {
          comprobarCredenciales();

          temporizador = Timer(const Duration(seconds: 2), () {
            comprobarUsuario(null);
          });
        }
      } else {
        //login completo desde 0.
        //Email introducido por el usuario
        _userEmail = _model.textController1.text;
        //checkToken = null;
        if (_userEmail!.isEmpty && _pass!.isEmpty) {
          // Error no introducido email ni contraseña
          args.addAll({'texto': 'Introduce un email y una contraseña'});
          _showAlertDialog(context, args);
        } else if (_userEmail!.isEmpty) {
          // Error no introducido email
          args.addAll({'texto': 'Introduce un email'});
          _showAlertDialog(context, args);
        } else if (_pass!.isEmpty) {
          // Error no introducida contraseña
          args.addAll({'texto': 'Introduce una contraseña'});
          _showAlertDialog(context, args);
        } else {
          comprobarCredenciales();

          temporizador = Timer(const Duration(seconds: 2), () {
            comprobarUsuario(null);
          });
        }
      }
    } else if (metodo == "fingerprint") {
      if (empLoginConfig != null && empLoginConfig!.getIsLogged()!) {
        String emailUser = empLoginConfig!.getUserEmail()!;
        String checkToken = empLoginConfig!.getToken()!;
        if (emailUser.isEmpty && checkToken.isEmpty) {
          // Sesion caducada
          if (kDebugMode) {
            print('Sesion caducada');
          }

          args.addAll({'texto': 'Sesion caducada'});
          _showAlertDialog(context, args);
        } else {
          annotateBiometricUnlock(emailUser, checkToken, null);
        }
      } else {
        // Error
        if (kDebugMode) {
          print('La sesión ha caducado, debe realizar un login completo.');
        }

        ServicioCache.prefs.clear();
        usuario_pemp = null;
        empLoginConfig = null;
        cargarParametros();
        setState(() {});

        // Avisar con dialog
        args.addAll({
          'texto': 'La sesión ha caducado, debe realizar un login completo.'
        });
        _showAlertDialog(context, args);
      }
    } else {
      // Error
      // Avisar con dialog
      args.addAll({'texto': 'Metodo de login no reconocido'});
      _showAlertDialog(context, args);
    }
  }

  ///
  ///
  void comprobarUsuario(TwoFAuth_validation? twoFAuth_data) async {
    // Establecemos el estado del menu en sharedpreferences
    ServicioCache.prefs.setString(
        "estadoMenu", _model.menuLateralModel.estadoMenuLateral.name);

    try {
      String passMD5 = md5.convert(utf8.encode("PGP$_pass")).toString();
      String passSHA256 = sha256.convert(utf8.encode("PGP$_pass")).toString();
      checkUser(_userEmail!, _pass!, passMD5, passSHA256, _pass!, _checkToken,
          twoFAuth_data);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  ///
  ///
  void checkUser(
      String email,
      String pass,
      String passMD5,
      String passSHA256,
      String passUserToReencode,
      String? checkToken,
      TwoFAuth_validation? twoFAuth_data) async {
    String device_name = "";
    String API_call_url = "";
    var params = {};

    params.addAll({
      "emailEmp": email,
      "passEmp": passMD5,
      "passEmp2": passSHA256,
      "passEmp_save": passUserToReencode,
    });

    if (checkToken == null) {
      // Obtenemos el nombre del dispositivo
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      try {
        if (isiOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          device_name = iosInfo.utsname.machine;
        } else {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          device_name = androidInfo.model;
        }
        params.addAll({"device_name": device_name});
        API_call_url = Parametros.URL_ANDROIDPOST_LOGIN_CHECK;
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    } else {
      params.addAll({"token": checkToken});
      API_call_url = Parametros.URL_ANDROIDPOST_LOGED_EMP_CHECK;
    }

    if (isAndroid) {
      params.addAll({"origin": "APP_ANDROID"});
    } else if (isiOS) {
      params.addAll({"origin": "APP_IOS"});
    }

    if (twoFAuth_data != null) {
      params.addAll({
        "twoFAuth_code": twoFAuth_data.getCode(),
        "twoFAuth_timestamp": twoFAuth_data
            .getTimestamp(), //timestamp que envió el servidor del momento en que fué validado el código de cara a replicar la validación
        "twoFAuth_window": twoFAuth_data.getFAuth_window(),
        "twoFAuth_recallCRC": twoFAuth_data.getRecallCRC(),
      });
    }

    try {
      Response request = await post(Uri.parse(API_call_url), body: params);
      var jsonData = jsonDecode(request.body) as Map<String, dynamic>;
      if (jsonData["resultado"] == "ok") {
        if (jsonData["usuario"] != null) {
          print(jsonData["usuario"]);
          // Creamos un Usuario_pemp con los datos
          usuario_pemp = Usuario_pemp.fromBD(jsonData["usuario"]);

          ServicioCache.prefs
              .setString("usuario_pemp", jsonEncode(usuario_pemp!.toJson()));

          if (dcontext != null) {
            Navigator.pop(dcontext!);
          }

          //una vez que tenemos el usuario, existen 2 opciones
          // 1 - Es requerida la autenticacion en 2 pasos y no esta configurada --> saltar a la configuracion
          // 2 - Saltar a la configuración del puesto (seleccionar encuadre de sesion)...
          if (usuario_pemp != null) {
            if ((usuario_pemp!.isTwoFAuth_required()) &&
                !(usuario_pemp!.isTwoFAuth_configured())) {
              //es necesario configurar la autenticacion en 2 pasos
              _showTwoAuthDialog(
                  context, usuario_pemp!.twoFAuth_stepConfig!, "password");
            } else {
              setState(() {
                cargando = true;
              });
              temporizador = Timer(const Duration(seconds: 2), () async {
                //podemos saltar a la configuración del puesto
                if (empLoginConfig != null && empLoginConfig!.isLogged!) {
                  if (empLoginConfig!.estaTotalmenteConfigurado()) {
                    _model.menuLateralModel.estadoMenuLateral =
                        EstadoMenuLateral.accesoConLog;
                    ServicioCache.prefs.setString("estadoMenu",
                        _model.menuLateralModel.estadoMenuLateral.name);
                    context.pushNamed("MenuPrincipal", queryParameters: {
                      'usuario_pemp': jsonEncode(usuario_pemp!.toJson()),
                      'empLoginConfig': jsonEncode(empLoginConfig!.toJson())
                    });
                  } else {
                    context.pushNamed("Configuracion");
                  }
                } else {
                  if (usuario_pemp!.getListaEmpresas().isEmpty == false) {
                    empLoginConfig = EmpLoginConfig(usuario_pemp!.code,
                        usuario_pemp!.email, usuario_pemp!.token, false);

                    if (usuario_pemp!.necesitaConfiguracion()) {
                      ServicioCache.prefs.setString("empLoginConfig",
                          jsonEncode(empLoginConfig!.toJson()));

                      context.pushNamed("Configuracion");
                    } else {
                      // Establecemos la configuracion unica del usuario
                      empLoginConfig!
                          .setEmployeeName(usuario_pemp!.getUsuarioUnico());
                      empLoginConfig!.setConfiguracionUnica(usuario_pemp!);
                      empLoginConfig!.setIsLogged(true);

                      String API_call_url =
                          Parametros.URL_ANDROIDPOST_CONFIG_EMPLOYEE;
                      Response request =
                          await post(Uri.parse(API_call_url), body: {
                        "token": usuario_pemp!.token,
                        "idEmpresa":
                            empLoginConfig!.getSelectedEmpresaID().toString(),
                        "idArea":
                            empLoginConfig!.getSelectedAreaID().toString(),
                        "idFile":
                            empLoginConfig!.getSelectedFileID().toString(),
                        "idEmpleadoPlan":
                            empLoginConfig!.getSelectedEmpleadoID().toString()
                      });

                      var jsonData =
                          jsonDecode(request.body) as Map<String, dynamic>;

                      if (jsonData['resultado'] == 'ok') {
                        _model.menuLateralModel.estadoMenuLateral =
                            EstadoMenuLateral.accesoConLog;
                        ServicioCache.prefs.setString("estadoMenu",
                            _model.menuLateralModel.estadoMenuLateral.name);
                        // Guardar en empLoginConfig
                        ServicioCache.prefs.setString("empLoginConfig",
                            jsonEncode(empLoginConfig!.toJson()));

                        context.pushNamed("MenuPrincipal", queryParameters: {
                          'usuario_pemp': jsonEncode(usuario_pemp!.toJson()),
                          'empLoginConfig': jsonEncode(empLoginConfig!.toJson())
                        });
                      } else if (jsonData['resultado'] == 'error') {
                      } else if (jsonData['resultado'] == 'exception') {}
                    }
                  } else {
                    //el login no tiene acceso a nada, mostrar error y cerrar login
                  }
                }
              });
            }
          } else {
            if (kDebugMode) {
              print(
                  "resultadoLogin: El parse del JSON del usuario devuelve null");
            }
          }
        } else {
          // No ha devuelto usuario
        }
      } else if (jsonData["resultado"] == "error") {
        setState(() {
          cargando = false;
        });

        String r_str = jsonData["result_str"];
        Map<String, String> args = {'titulo': 'Error en el login'};

        //CODIGOS DE ERROR DEL LOGIN COMPLETO DE USUARIO
        if (r_str == "ERROR_REGISTERING_USER") {
          // Mostrar mensaje de error
          args.addAll({
            'texto':
                'Ocurrió un error al registrar el usuario, vuelva a intentarlo y si el problema persiste contacte con soporte.'
          });
          args.addAll({'tipo': 'ERROR_REGISTERING_USER'});
          _showAlertDialog(context, args);
        } else if (r_str == "USER_OR_PASS_NOT_VALID") {
          // Mostrar mensaje de error
          args.addAll({'texto': 'El usuario y/o contraseña no son válidos.'});
          args.addAll({'tipo': 'USER_OR_PASS_NOT_VALID'});
          _showAlertDialog(context, args);
        } else if (r_str == "TOKEN_USER_NOT_MATCH") {
          // Mostrar mensaje de error
          args.addAll({'texto': 'El usuario y/o contraseña no son válidos.'});
          args.addAll({'tipo': 'TOKEN_USER_NOT_MATCH'});
          _showAlertDialog(context, args);
        } else if (r_str == "UNLOCK_PASS_NOT_MATCH") {
          // Mostrar mensaje de error
          args.addAll({'texto': 'La contraseña no es válida.'});
          args.addAll({'tipo': 'UNLOCK_PASS_NOT_MATCH'});
          _showAlertDialog(context, args);
        } else if (r_str == "USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND") {
          // Mostrar mensaje de error
          args.addAll({
            'texto':
                'El usuario no ha sido encontrado o ha caducado, vuelva a logearse.'
          });
          args.addAll({'tipo': 'USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND'});
          _showAlertDialog(context, args);
        } else if (r_str == "EXPIRED_PASSWORD") {
          // Mostrar dialogo de cambio de password
          _showRenewPassDialog(context, email);
        } else if (r_str == "2FAuth_REQUIRED") {
          // Recibimos los parametros de la configuracion en dos pasos
          var result = jsonData['2FAuthData'];

          // Mostrar dialogo de la autentificacion en dos pasos
          _showTwoAuthDialog(
              context, TwoFAuth_stepObject.fromBD(result), "password");

          // Volvemos a llamar a la función con los datos de la autenficacion
          //checkUser(email, pass, passMD5, passSHA256, passUserToReencode, checkToken, twoFAuth_data);
        } else {}
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  ///
  ///
  Future<void> comprobarCredenciales() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          dcontext = context;
          return Dialog(
            key: const ValueKey('comprobarCredenciales'),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              //height: MediaQuery.sizeOf(context).height * 0.8,
              //width: MediaQuery.sizeOf(context).width * 0.75,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 30, 20, 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 20, 10),
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(15, 134, 208, 1),
                      ),
                    ),
                    SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        child: Text(
                          AppLocalizations.of(context)!.verificandoUser,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  /// Funcion que cambio la contraseña del portal de pgplanning. Se usa cuando la clave expira.
  ///
  void _changeAdminPassword(String userEmail, String oldPass, String newPass,
      String newPassCopy) async {
    String oldPassEnc = md5.convert(utf8.encode("PGP$oldPass")).toString();
    String oldPassEnc2 = sha256.convert(utf8.encode("PGP$oldPass")).toString();

    Response request = await post(
        Uri.parse(Parametros.URL_ANDROID_POST_CHANGE_EMP_PWD),
        body: {
          "emailUser": userEmail,
          "oldPassword": oldPassEnc,
          "oldPassword2": oldPassEnc2,
          "plainNewPassword": newPass,
          "plainNewPassword2": newPassCopy
        });

    var jsonData = jsonDecode(request.body) as Map<String, dynamic>;

    if (jsonData["resultado"] == "ok") {
      _model.textController1.text = '';
      _model.textController2.text = '';
      if (dcontext != null) {
        Navigator.pop(dcontext!);
      }
    } else if (jsonData["resultado"] == "error") {
      String r_str = jsonData["result_str"];
      Map<String, String> args = {'titulo': 'Error en el login'};
      if (r_str == "WEAK_PASSWORD_STRENGTH") {
        //La nueva contraseña no cumple los requisitos de complejidad.
        args.addAll({
          'texto':
              'La nueva contraseña no cumple los requisitos de complejidad.'
        });
        args.addAll({'tipo': 'WEAK_PASSWORD_STRENGTH'});
        _showAlertDialog(context, args);
      } else if (r_str == "ERROR_SAVING_TRY_AGAIN") {
        args.addAll({
          // Ha ocurrido un error al intentar guardar la nueva contraseña.
          'texto':
              'Ha ocurrido un error al intentar guardar la nueva contraseña.'
        });
        args.addAll({'tipo': 'ERROR_SAVING_TRY_AGAIN'});
        _showAlertDialog(context, args);
      } else if (r_str == "PASSWORD_RECENTLY_USED") {
        //La nueva contraseña no cumple el requisito de historico de contraseñas
        args.addAll({
          'texto':
              'La nueva contraseña no cumple el requisito de historico de contraseñas.'
        });
        args.addAll({'tipo': 'PASSWORD_RECENTLY_USED'});
        _showAlertDialog(context, args);
      } else if (r_str == "NEW_PASSWORDS_NOT_MATCH") {
        // La nueva contraseña y su repeticion no coinciden
        args.addAll(
            {'texto': 'La nueva contraseña y su repeticion no coinciden.'});
        args.addAll({'tipo': 'NEW_PASSWORDS_NOT_MATCH'});
        _showAlertDialog(context, args);
      } else if (r_str == "USER_OR_PASS_NOT_VALID") {
        // La actual contraseña no es correcta
        args.addAll({'texto': 'La actual contraseña no es correcta.'});
        args.addAll({'tipo': 'USER_OR_PASS_NOT_VALID'});
        _showAlertDialog(context, args);
      } else {
        //error desconocido???
      }
    }
  }

  ///
  ///
  void _showAlertDialog(BuildContext context, Map<String, String> args) {
    if (dcontext != null) {
      Navigator.of(dcontext!).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor:
              const Color(0xFF0A2C4E), // azul oscuro similar al header
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF0A2C4E),
                  Color(0xFF1B73C0)
                ], // degradado azul
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.white.withOpacity(0.9),
                  size: 48,
                ),
                const SizedBox(height: 12),
                Text(
                  args['titulo'] ?? "Título",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  args['texto'] ?? "Contenido del mensaje",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Aceptar',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        SystemNavigator.pop();
      },
      child: GestureDetector(
        onTap: () => _model.unfocusNode.canRequestFocus
            ? FocusScope.of(context).requestFocus(_model.unfocusNode)
            : FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          drawer: WebViewAware(
              child: Drawer(
            elevation: 16.0,
            child: wrapWithModel(
              model: _model.menuLateralModel,
              updateCallback: () => setState(() {}),
              child: const MenuLateralWidget(isWebView: false),
            ),
          )),
          body: SafeArea(
            top: isAndroid,
            bottom: isAndroid,
            right: isAndroid,
            left: isAndroid,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(23, 36, 41, 1),
                    Color.fromRGBO(9, 114, 150, 1),
                    Color.fromRGBO(0, 164, 220, 1)
                  ],
                  //stops: [0.0, 0.3, 0.8],
                  begin: AlignmentDirectional(-1.0, -1.0),
                  end: AlignmentDirectional(1.0, 1.0),
                ),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0.00, -1.00),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: (cargando)
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 10.0),
                      child: Material(
                        elevation: 10,
                        child: Container(
                          width: double.infinity,
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? ((isiOS)
                                  ? (MediaQuery.sizeOf(context).height * 0.08 +
                                      MediaQuery.of(context).padding.top)
                                  : MediaQuery.sizeOf(context).height * 0.08)
                              : ((isiOS)
                                  ? (MediaQuery.sizeOf(context).height * 0.16 +
                                      MediaQuery.of(context).padding.top)
                                  : MediaQuery.sizeOf(context).height * 0.16),
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(8, 42, 71, 1)),
                          alignment: const AlignmentDirectional(0.00, 0.00),
                          child: Padding(
                            padding: (isiOS)
                                ? EdgeInsetsDirectional.fromSTEB(
                                    0, MediaQuery.of(context).padding.top, 0, 0)
                                : const EdgeInsetsDirectional.all(0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FlutterFlowIconButton(
                                  borderColor: Colors.transparent,
                                  borderRadius: 20.0,
                                  borderWidth: 0.0,
                                  buttonSize: 60.0,
                                  icon: FaIcon(
                                    FontAwesomeIcons.bars,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    scaffoldKey.currentState!.openDrawer();
                                  },
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.75,
                                  child: Padding(
                                    padding:
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.portrait)
                                            ? const EdgeInsets.all(0)
                                            : const EdgeInsets.all(8),
                                    child: Image(
                                        fit: (MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait)
                                            ? BoxFit.fitWidth
                                            : BoxFit.fitHeight,
                                        image: const AssetImage(
                                            'assets/images/logotipo_pgplanning_blanco_plano.png')),
                                  ),
                                )
                              ]
                                  .divide(const SizedBox(width: 15.0))
                                  .addToStart(const SizedBox(width: 10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    (cargando)
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: (MediaQuery.of(context).orientation ==
                                          Orientation.portrait)
                                      ? MediaQuery.sizeOf(context).width * 0.85
                                      : MediaQuery.sizeOf(context).width * 0.5,
                                  child: const Image(
                                      fit: BoxFit.fitWidth,
                                      image: AssetImage(
                                          'assets/images/logotipo_pgplanning_72dp.png')),
                                ),
                                Container(
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .sincroDatos,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(4, 4, 4, 20),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 30, 10),
                                              child: CircularProgressIndicator(
                                                color: Color.fromRGBO(
                                                    15, 134, 208, 1),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.6,
                                                child: Text(
                                                  "(2/2) ${AppLocalizations.of(context)!.recuperarSecciones}",
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                            child: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? contenidoPrincipal()
                                : SingleChildScrollView(
                                    child: contenidoPrincipal(),
                                  ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contenidoPrincipal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: (isWaitingAuth && !authCancel && isAndroid)
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
          child: SizedBox(
            height: (MediaQuery.of(context).orientation == Orientation.portrait)
                ? MediaQuery.sizeOf(context).height * 0.12
                : MediaQuery.sizeOf(context).height * 0.24,
            child: const Image(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/profile.png')),
          ),
        ),
        (estadoLogin)
            ? Text(
                AppLocalizations.of(context)!.saludo,
                style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              )
            : Container(),
        (estadoLogin)
            ? Text(
                empLoginConfig!.getEmployeeName()!,
                style: const TextStyle(
                    fontSize: 16, color: Color.fromRGBO(255, 255, 255, 1)),
              )
            : Container(),
        (estadoLogin)
            ? Text(
                "<${empLoginConfig!.getUserEmail()!}>",
                style: const TextStyle(
                    fontSize: 16, color: Color.fromRGBO(255, 255, 255, 1)),
              )
            : Container(),
        (estadoLogin)
            ? Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: FFButtonWidget(
                  onPressed: () {
                    var locale = Locale(Platform.localeName);
                    Provider.of<LocaleModel>(context, listen: false)
                        .set(locale);
                    ServicioCache.prefs.setString(
                        'language', locale.languageCode.split('_')[0]);
                    ServicioCache.prefs.clear();
                    usuario_pemp = null;
                    empLoginConfig = null;
                    isWaitingAuth = false;
                    authCancel = false;
                    cargarParametros();
                    setState(() {});
                  },
                  text: AppLocalizations.of(context)!.otroUsuario,
                  options: FFButtonOptions(
                    width: 180.0,
                    height: 30.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: const Color.fromRGBO(255, 159, 34, 1),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                        ),
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              )
            : Container(),
        (!estadoLogin)
            ? Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: SizedBox(
                  height: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? MediaQuery.sizeOf(context).height * 0.04
                      : MediaQuery.sizeOf(context).height * 0.08,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _model.textController1,
                    focusNode: _model.textFieldFocusNode1,
                    cursorColor: const Color.fromRGBO(255, 159, 34, 1),
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromRGBO(224, 224, 224, 1)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(255, 159, 34, 1))),
                      hintText: AppLocalizations.of(context)!.pistaEmail,
                      hintStyle: const TextStyle(
                          color: Color.fromRGBO(224, 224, 224, 1)),
                    ),
                    style: const TextStyle(
                        color: Color.fromRGBO(224, 224, 224, 1)),
                  ),
                ),
              )
            : Container(),
        (authCancel)
            ? Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Column(children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 202, 202, 1),
                        border: Border(
                          bottom: BorderSide(
                              width: 1, color: Color.fromRGBO(254, 83, 83, 1)),
                          right: BorderSide(
                              width: 1, color: Color.fromRGBO(254, 83, 83, 1)),
                          left: BorderSide(
                              width: 1, color: Color.fromRGBO(254, 83, 83, 1)),
                          top: BorderSide(
                              width: 1, color: Color.fromRGBO(254, 83, 83, 1)),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 3, 10, 3),
                      child: Text(
                        AppLocalizations.of(context)!.cancelarBiometricos,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromRGBO(132, 0, 0, 1), fontSize: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: FFButtonWidget(
                        onPressed: () async {
                          if (temporizador != null) {
                            temporizador!.cancel();
                          }

                          setState(() {
                            authCancel = false;
                            isWaitingAuth = false;
                          });
                        },
                        text: AppLocalizations.of(context)!.usoPass,
                        options: FFButtonOptions(
                          width: 150.0,
                          height: 30.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: const Color.fromRGBO(255, 159, 34, 1),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(20.0),
                        )),
                  ),
                ]),
              )
            : ((estadoLogin &&
                    _isBiometricSupported &&
                    _isBiometricEnabled &&
                    isWaitingAuth)
                ? Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                        child: Text(
                          AppLocalizations.of(context)!.pistaBiometricos,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () {},
                        text: AppLocalizations.of(context)!.usoPass,
                        options: FFButtonOptions(
                          width: 140.0,
                          height: 30.0,
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: const Color.fromRGBO(255, 159, 34, 1),
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      )
                    ],
                  )
                : Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20.0, 15.0, 20.0, 16.0),
                    child: Column(children: [
                      (estadoLogin &&
                              _isBiometricSupported &&
                              _isBiometricEnabled &&
                              !isWaitingAuth)
                          ? Column(children: [
                              FFButtonWidget(
                                  onPressed: () async {
                                    _model.textController1.text = '';
                                    _model.textController2.text = '';
                                    await autenticacionBiometrica();
                                  },
                                  text: AppLocalizations.of(context)!
                                      .usoBiometricos,
                                  options: FFButtonOptions(
                                    width: 150.0,
                                    height: 30.0,
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    iconPadding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                    color:
                                        const Color.fromRGBO(255, 159, 34, 1),
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          color: Colors.white,
                                        ),
                                    elevation: 3.0,
                                    borderRadius: BorderRadius.circular(20.0),
                                  )),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 8, 0, 10),
                                child: Text(
                                  AppLocalizations.of(context)!.usoPassAcceso,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(255, 255, 255, 1)),
                                ),
                              ),
                            ])
                          : Container(),
                      SizedBox(
                        height: (MediaQuery.of(context).orientation ==
                                Orientation.portrait)
                            ? MediaQuery.sizeOf(context).height * 0.04
                            : MediaQuery.sizeOf(context).height * 0.08,
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: _model.textController2,
                          focusNode: _model.textFieldFocusNode2,
                          obscureText: !_model.passwordVisibility,
                          cursorColor: const Color.fromRGBO(255, 159, 34, 1),
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 224, 224, 1)),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 159, 34, 1))),
                            hintText: AppLocalizations.of(context)!.pistaPass,
                            hintStyle: const TextStyle(
                                color: Color.fromRGBO(224, 224, 224, 1)),
                          ),
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1)),
                          validator: _model.textController2Validator
                              .asValidator(context),
                        ),
                      ),
                    ]),
                  )),
        (authCancel)
            ? Container()
            : ((estadoLogin &&
                    _isBiometricSupported &&
                    _isBiometricEnabled &&
                    isWaitingAuth)
                ? Container()
                : FFButtonWidget(
                    onPressed: () async {
                      validarYComprobarDatos("password");
                    },
                    text: AppLocalizations.of(context)!.btnAcceso,
                    options: FFButtonOptions(
                      width: 100.0,
                      height: 44.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      iconPadding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 0.0),
                      color: const Color.fromRGBO(15, 134, 208, 1),
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                              ),
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  )),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          child: InkWell(
            onTap: () async {
              final Uri url = Uri.parse(Parametros.RECOVER_PASS_URL);
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw Exception('Could not launch $url');
              }
            },
            child: Text(AppLocalizations.of(context)!.btnRecuperarPass,
                style: const TextStyle(
                    fontSize: 18, color: Color.fromRGBO(255, 255, 255, 1))),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.all(10),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.6,
            //height: MediaQuery.sizeOf(context).height * 0.2,
            child: const Image(
                fit: BoxFit.fitWidth,
                image:
                    AssetImage('assets/images/logotipo_pgplanning_72dp.png')),
          ),
        )
      ],
    );
  }

  Future<void> _showTwoAuthDialog(BuildContext context,
      TwoFAuth_stepObject twoFAuth_stepObject, String metodo) async {
    late final webview.PlatformWebViewControllerCreationParams params;
    if (webview.WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const webview.PlatformWebViewControllerCreationParams();
    }

    final webview.WebViewController controller =
        webview.WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(webview.JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        webview.NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (webview.WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (webview.NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return webview.NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return webview.NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'flutter_androidAppVersionInfo',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          var json = await androidAppVersionInfo();
          if (kDebugMode) {
            print("flutter_androidAppVersionInfo: ${message.message}");
          }

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "androidAppVersionInfo", "response": $json}))''');
        },
      )
      ..addJavaScriptChannel(
        'flutter_androidGetUserLanguage',
        onMessageReceived: (webview.JavaScriptMessage message) {
          if (kDebugMode) {
            print("flutter_androidGetUserLanguage: ${message.message}");
          }

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify( {‘questionAnswered’: ‘androidGetUserLanguage, ‘response’: ‘es_ES’}))''');
        },
      )
      ..addJavaScriptChannel(
        'flutter_androidGetUserTimeZone',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print("flutter_androidGetUserTimeZone: ${message.message}");
          }

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify({‘questionAnswered’: ‘androidGetUserTimeZone, ‘response’: ‘Europe/Madrid }))''');
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onSuccess2FAuthCodeProcess',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print(
                "flutter_2FAuth_onSuccess2FAuthCodeProcess: ${message.message}");
          }

          var data = TwoFAuth_validation.fromBD(jsonDecode(message.message));

          Navigator.pop(context);
          if (metodo == "password") {
            comprobarUsuario(data);
          } else if (metodo == "biometrics") {
            annotateBiometricUnlock(
                empLoginConfig!.userEmail!, empLoginConfig!.token!, data);
          }
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onSuccess2FAuthConfigured',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print(
                "flutter_2FAuth_onSuccess2FAuthConfigured: ${message.message}");
          }

          // Borramos el email y contraseña del usuario
          _model.textController1.text = '';
          _model.textController2.text = '';

          // Cerramos el dialog que contiene el WebView
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onSuccess2FAuthDeletion',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print("flutter_2FAuth_onSuccess2FAuthDeletion: ${message.message}");
          }
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthDeletion',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print("flutter_2FAuth_onClose2FAuthDeletion: ${message.message}");
          }
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthConfiguration',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print(
                "flutter_2FAuth_onClose2FAuthConfiguration: ${message.message}");
          }
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthByNoRecoverableError',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print(
                "flutter_2FAuth_onClose2FAuthByNoRecoverableError: ${message.message}");
          }

          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthCodeProcess',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print(
                "flutter_2FAuth_onClose2FAuthCodeProcess: ${message.message}");
          }
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_retrieveValidationConfig',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          if (kDebugMode) {
            print(
                "flutter_2FAuth_retrieveValidationConfig: ${message.message}");
          }

          Map<String, dynamic> json = {};

          for (var param in twoFAuth_stepObject.twoFAuth_step_params) {
            json[param.name] = param.value;
          }

          json['deviceTZ'] = DateTime.now().timeZoneName;

          if (isiOS) {
            json['typeAPP'] = 'IOS';
          } else if (isAndroid) {
            json['typeAPP'] = 'ANDROID';
          }

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "2FAuth_retrieveValidationConfig", "response": ${jsonEncode(json)}}))''');
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_printToConsoleLog',
        onMessageReceived: (webview.JavaScriptMessage message) {
          if (kDebugMode) {
            print("flutter_2FAuth_printToConsoleLog: ${message.message}");
          }
        },
      )
      ..loadRequest(Uri.parse(twoFAuth_stepObject.twoFAuth_step_url));
    return showDialog(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 40, 10, 40),
          child: SizedBox(
            child: webview.WebViewWidget(
              controller: controller,
            ),
          ),
        );
      },
    );
  }

  Future<String> androidAppVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String versionCode = packageInfo.buildSignature;

    try {
      Map<String, dynamic> returnInfo = {};
      returnInfo['APPLICATION_ID'] = packageName;
      returnInfo['VERSION_CODE'] = buildNumber;
      returnInfo['VERSION_NAME'] = version;

      /*int availableVersionCode = mActivity.getAppUpdateVersionCodeAvailable();

    if (availableVersionCode == 0) {
      returnInfo.put("updateAvailable", false);
    } else if (availableVersionCode > 0 ) {
      returnInfo.put("updateAvailable", true);
      returnInfo.put("updateNewVersion", availableVersionCode);
    }*/

      return jsonEncode(returnInfo);
    } on PlatformException catch (err) {
      return "error";
    }
  }

  Future<void> _showRenewPassDialog(BuildContext context, String email) async {
    TextEditingController passOldController = TextEditingController();
    TextEditingController passNewController = TextEditingController();
    TextEditingController passNewRController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 27, 66, 88),
                    Color.fromARGB(255, 24, 83, 104),
                    Color.fromARGB(255, 2, 119, 158)
                  ],
                  stops: [0.0, 0.3, 0.8],
                  begin: AlignmentDirectional(-1.0, -0.94),
                  end: AlignmentDirectional(1.0, 0.94),
                )),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Image(
                          image: AssetImage('assets/images/ic_renew_pass.png')),
                    ),
                    const Text(
                      'Cambio de contraseña',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Text(
                        'Para cambiar su contraseña, debe introducir la contraseña actual y la nueva. Recuerde que la nueva contraseña debe ser de al menos 8 caracteres y contener mayúsculas, minúsculas y dígitos del 0 al 9.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                      child: Text(
                        'Usuario: $email', // ${empLoginConfig!.getEmployeeName()}',
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                      child: TextField(
                        controller: passOldController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Contraseña antigua',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                      child: TextField(
                          controller: passNewController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: 'Contraseña nueva',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                      child: TextField(
                        controller: passNewRController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Repetir contraseña',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ),
                    Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FFButtonWidget(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              text: 'Cancelar',
                              options: FFButtonOptions(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                    ),
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                if (passOldController.text != '' &&
                                    passNewController.text != '' &&
                                    passNewRController.text != '') {
                                  // Codificamos las claves
                                  _changeAdminPassword(
                                      email, //empLoginConfig!.getUserEmail()!,
                                      passOldController.text,
                                      passNewController.text,
                                      passNewRController.text);
                                  Navigator.pop(context);
                                }
                              },
                              text: 'Cambiar clave',
                              options: FFButtonOptions(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                    ),
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
