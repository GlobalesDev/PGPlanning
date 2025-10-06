// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import 'package:p_g_planning/flutter_flow/flutter_flow_widgets.dart';
import 'package:p_g_planning/l10n/app_localizations.dart';
import 'package:p_g_planning/model/empLoginConfig.dart';
import 'package:p_g_planning/model/seccion_portal.dart';
import 'package:p_g_planning/model/two_FAuth_stepObject.dart';
import 'package:p_g_planning/model/usuario_pemp.dart';
import 'package:p_g_planning/model/parametros/parametros.dart';
import 'package:p_g_planning/servicio_cache.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '/components/menu_lateral_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'menu_principal_model.dart';
export 'menu_principal_model.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuPrincipalWidget extends StatefulWidget {
  final Usuario_pemp? usuario_pemp;
  final EmpLoginConfig? empLoginConfig;
  const MenuPrincipalWidget({Key? key, this.usuario_pemp, this.empLoginConfig})
      : super(key: key);

  @override
  _MenuPrincipalWidgetState createState() => _MenuPrincipalWidgetState();
}

class _MenuPrincipalWidgetState extends State<MenuPrincipalWidget>
    with WidgetsBindingObserver {
  late MenuPrincipalModel _model;
  List<Widget> listaSecciones = [];
  Usuario_pemp? usuario_pemp;
  EmpLoginConfig? empLoginConfig;
  bool mostrarInfoEmpresa = false;
  bool planCaducado = false;
  List<SeccionPortal> listaDatosSecciones = [];
  Timer? temporizador;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    usuario_pemp = widget.usuario_pemp!;
    var a = ServicioCache.prefs.getString('empLoginConfig');
    print('init: $a');
    empLoginConfig = widget.empLoginConfig!;
    cargarParametros();
    _model = createModel(context, () => MenuPrincipalModel());
    getConfiguracionMenu();
    //print('Lenguaje: ${widget.empLoginConfig!.selectedFile!.toJson().toString()}');
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

  void cargarParametros() async {
    print('Cargaarr');
    if (empLoginConfig!.selectedFile!.endDate!.isBefore(DateTime.now())) {
      // Mostrar el mensaje de que el plan ha caducado
      planCaducado = true;
    }

    // Cargar dinamicamente las secciones
    Response request = await post(
        Uri.parse(Parametros.URL_ANDROIDPOST_GET_SECTIONS_PORTAL),
        body: {
          "token": empLoginConfig!.token,
        });

    var json = jsonDecode(request.body);

    if (json['resultado'] == 'ok') {
      if (json['secciones'] != null) {
        listaDatosSecciones.clear();
        for (var element in (json['secciones'] as List<dynamic>)) {
          print(element);
          var tmp = SeccionPortal.fromBD(element);
          
          if (tmp.iconBadge_callAPIFunction != '') {
            await tmp.getBagdeNumber();
          }
          listaDatosSecciones.add(tmp);
        }

        ServicioCache.prefs.setString("listaSecciones",
            jsonEncode(listaDatosSecciones.map((c) => c.toJson()).toList()));
        _model.menuLateralModel.listaSecciones = listaDatosSecciones;
        cambiarOpciones();
      } else {
        // Error no devuelve secciones
      }
    } /*else if (json['resultado'] == 'ok') {

    }*/
  }

  void getConfiguracionMenu() async {
    String? modelo = await ServicioCache.getEstadoMenu();
    //print(MenuLateralModel.fromJson(modelo));

    // Añadimos los diferentes estados
    if (modelo != null && modelo == EstadoMenuLateral.accesoConLog.name) {
      _model.menuLateralModel.estadoMenuLateral =
          EstadoMenuLateral.accesoConLog;
      cambiarOpciones();
    }
  }

  void cambiarOpciones() {
    String? modelo = _model.menuLateralModel.estadoMenuLateral.name;

    List<Widget> listaMenu = [];
    // Comprobamos las secciones a las que puede acceder cada usuario
    print(modelo);
    print(listaDatosSecciones);
    if (listaDatosSecciones.isNotEmpty &&
        modelo == EstadoMenuLateral.accesoConLog.name) {
      print('Holaaaa');
      for (var element in listaDatosSecciones) {
        if (element.visible) {
          listaMenu.add(seccion(context, element, element.name));
        }
      }
    }

    setState(() {
      listaSecciones = listaMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    //getConfiguracionMenu();
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
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        context.pushNamed("Inicio");
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
              child: MenuLateralWidget(
                  openPinDialog: _showPinDialog,
                  open2Auth: _showTwoAuthDialog,
                  cargarParametros: cargarParametros,
                  isWebView: false,
                  usuario_pemp: usuario_pemp,
                  empLoginConfig: empLoginConfig),
            ),
          )),
          body: SafeArea(
            top: isAndroid,
            bottom: isAndroid,
            right: isAndroid,
            left: isAndroid,
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1.0,
              height: MediaQuery.sizeOf(context).height +
                  MediaQuery.of(context).padding.bottom,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 27, 66, 88),
                    Color.fromARGB(255, 24, 83, 104),
                    Color.fromARGB(211, 2, 118, 158)
                  ],
                  stops: [0.0, 0.3, 0.8],
                  begin: AlignmentDirectional(-1.0, -0.94),
                  end: AlignmentDirectional(1.0, 0.94),
                ),
              ),
              child: Stack(children: [
                Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 10,
                          child: Container(
                            width: double.infinity,
                            height: (MediaQuery.of(context).orientation ==
                                    Orientation.portrait)
                                ? ((isiOS)
                                    ? (MediaQuery.sizeOf(context).height *
                                            0.08 +
                                        MediaQuery.of(context).padding.top)
                                    : MediaQuery.sizeOf(context).height * 0.08)
                                : ((isiOS)
                                    ? (MediaQuery.sizeOf(context).height *
                                            0.16 +
                                        MediaQuery.of(context).padding.top)
                                    : MediaQuery.sizeOf(context).height * 0.16),
                            decoration: const BoxDecoration(
                                //borderRadius: BorderRadius.circular(16.0),
                                color: Color.fromRGBO(8, 42, 71, 1)),
                            alignment: const AlignmentDirectional(0.00, 0.00),
                            child: Padding(
                              padding: (isiOS)
                                  ? EdgeInsetsDirectional.fromSTEB(0,
                                      MediaQuery.of(context).padding.top, 0, 0)
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
                                          image: AssetImage(
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
                        SizedBox(
                          height: (MediaQuery.sizeOf(context).height -
                                  MediaQuery.of(context).padding.top -
                                  MediaQuery.of(context).padding.bottom) -
                              ((MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? MediaQuery.sizeOf(context).height * 0.13
                                  : MediaQuery.sizeOf(context).height *
                                      0.26), // Los menos
                          child: GridView.builder(
                            padding: EdgeInsetsDirectional.fromSTEB(0,
                                MediaQuery.sizeOf(context).height * 0.01, 0, 0),
                            //physics: ClampingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 120,
                              crossAxisCount: 2,
                              crossAxisSpacing: 0.0,
                              mainAxisSpacing: 20.0,
                              childAspectRatio: () {
                                if (MediaQuery.sizeOf(context).width <
                                    kBreakpointSmall) {
                                  return 2.0;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointMedium) {
                                  return 1.75;
                                } else if (MediaQuery.sizeOf(context).width <
                                    kBreakpointLarge) {
                                  return 1.5;
                                } else {
                                  return 1.3;
                                }
                              }(),
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: listaSecciones.length,
                            itemBuilder: (context, index) {
                              return listaSecciones[index];
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? ((isiOS)
                              ? (MediaQuery.sizeOf(context).height * 0.05 +
                                  MediaQuery.of(context).padding.bottom)
                              : MediaQuery.sizeOf(context).height * 0.05)
                          : ((isiOS)
                              ? (MediaQuery.sizeOf(context).height * 0.1 +
                                  MediaQuery.of(context).padding.bottom)
                              : MediaQuery.sizeOf(context).height * 0.1),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(8, 42, 71, 1),
                      ),
                      child: Padding(
                        padding: (isiOS)
                            ? EdgeInsetsDirectional.fromSTEB(
                                (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? 10
                                    : MediaQuery.sizeOf(context).height * 0.2,
                                0,
                                (MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? 10
                                    : MediaQuery.sizeOf(context).height * 0.2,
                                MediaQuery.of(context).padding.bottom)
                            : EdgeInsets.all(0),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: Text(
                                  widget.empLoginConfig!
                                      .getEmployeeName()! /*'Empleado'*/,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  (mostrarInfoEmpresa)
                                      ? mostrarInfoEmpresa = false
                                      : mostrarInfoEmpresa = true;

                                  if (mostrarInfoEmpresa) {
                                    setState(() {});
                                    temporizador =
                                        Timer(const Duration(seconds: 5), () {
                                      setState(() {
                                        mostrarInfoEmpresa = false;
                                      });
                                    });
                                  } else {
                                    if (temporizador != null) {
                                      if (temporizador!.isActive) {
                                        temporizador!.cancel();
                                      }
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.empresa,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                      ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                (planCaducado)
                    ? Align(
                        alignment: const AlignmentDirectional(0.00, 1.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10,
                              10,
                              10,
                              (MediaQuery.of(context).padding.bottom +
                                  (((MediaQuery.of(context).orientation ==
                                          Orientation.portrait))
                                      ? MediaQuery.sizeOf(context).height * 0.05
                                      : MediaQuery.sizeOf(context).height *
                                          0.1) +
                                  10)),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            //height: MediaQuery.sizeOf(context).height * 0.15,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 0),
                                  child: Icon(
                                    FontAwesomeIcons.triangleExclamation,
                                    size: 40,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 20, 20, 20),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.7,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .planificacionCaducada),
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 0),
                                          child: InkWell(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .cambiarPlanificacion,
                                                    style: TextStyle(
                                                      decoration: TextDecoration.underline
                                                    )),
                                            onTap: () {
                                              cambiarPlan();
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                (mostrarInfoEmpresa)
                    ? Align(
                        alignment: const AlignmentDirectional(1.00, 1.00),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10,
                              10,
                              (MediaQuery.of(context).orientation ==
                                      Orientation.portrait)
                                  ? 10
                                  : MediaQuery.sizeOf(context).height * 0.2,
                              (MediaQuery.of(context).padding.bottom +
                                  (((MediaQuery.of(context).orientation ==
                                          Orientation.portrait))
                                      ? MediaQuery.sizeOf(context).height * 0.05
                                      : MediaQuery.sizeOf(context).height *
                                          0.1) +
                                  10)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadiusDirectional.circular(10),
                              color: const Color.fromARGB(255, 27, 66, 88),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10, 10, 10, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            5, 0, 10, 0),
                                    child: SizedBox(
                                      //width: MediaQuery.sizeOf(context).width / 3,
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                '${AppLocalizations.of(context)!.user}:',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    fontSize: 12)),
                                            Text(
                                                "${AppLocalizations.of(context)!.empresa}:",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    fontSize: 12)),
                                            Text(
                                                "${AppLocalizations.of(context)!.area}:",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    fontSize: 12)),
                                            Text(
                                                "${AppLocalizations.of(context)!.planificacion}:",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    fontSize: 12)),
                                            Text(
                                                "${AppLocalizations.of(context)!.ultimaConexion}:",
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    fontSize: 12)),
                                          ]),
                                    ),
                                  ),
                                  SizedBox(
                                    //width: MediaQuery.sizeOf(context).width / 2,
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              empLoginConfig!.employeeName ??
                                                  "",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontSize: 12)),
                                          Text(
                                              empLoginConfig!
                                                      .getSelectedEmpresa()!
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontSize: 12)),
                                          Text(
                                              empLoginConfig!
                                                      .getSelectedArea()!
                                                      .name ??
                                                  "",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontSize: 12)),
                                          Text(
                                              empLoginConfig!
                                                      .getSelectedFile()!
                                                      .name ??
                                                  "",
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontSize: 12)),
                                          Text(
                                              "${(usuario_pemp!.getLastLoginDate()!.day > 9) ? usuario_pemp!.getLastLoginDate()!.day : "0${usuario_pemp!.getLastLoginDate()!.day}"}-${(usuario_pemp!.getLastLoginDate()!.month > 9) ? usuario_pemp!.getLastLoginDate()!.month : "0${usuario_pemp!.getLastLoginDate()!.month}"}-${usuario_pemp!.getLastLoginDate()!.year.toString()} ${(usuario_pemp!.getLastLoginDate()!.hour > 9) ? usuario_pemp!.getLastLoginDate()!.hour : "0${usuario_pemp!.getLastLoginDate()!.hour}"}:${(usuario_pemp!.getLastLoginDate()!.minute > 9) ? usuario_pemp!.getLastLoginDate()!.minute : "0${usuario_pemp!.getLastLoginDate()!.minute}"}:${(usuario_pemp!.getLastLoginDate()!.second > 9) ? usuario_pemp!.getLastLoginDate()!.second : "0${usuario_pemp!.getLastLoginDate()!.second}"}",
                                              style: const TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  fontSize: 12)),
                                        ]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPinDialog(BuildContext context) async {
    TextEditingController passController = TextEditingController();
    TextEditingController pinController = TextEditingController();
    TextEditingController pinRController = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
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
                    Text(
                      AppLocalizations.of(context)!.tituloCambioClave,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Text(
                        AppLocalizations.of(context)!.cuerpoCambioClave,
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
                        '${AppLocalizations.of(context)!.user}: ${empLoginConfig!.getEmployeeName()}',
                        style: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                      child: TextField(
                        controller: passController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.contraUser,
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255))),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                      child: TextField(
                          controller: pinController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.claveDescarga,
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                      child: TextField(
                        controller: pinRController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context)!.repetirClave,
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
                              text: AppLocalizations.of(context)!.cancelar,
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
                                if (passController.text != '' &&
                                    pinController.text != '' &&
                                    pinRController.text != '') {
                                  // Codificamos las claves
                                  String passMD5 = md5
                                      .convert(utf8
                                          .encode("PGP${passController.text}"))
                                      .toString();
                                  String passSHA256 = sha256
                                      .convert(utf8
                                          .encode("PGP${passController.text}"))
                                      .toString();
                                  String pin1 = pinController.text;
                                  String pin2 = pinRController.text;

                                  Response request = await post(
                                      Uri.parse(Parametros
                                          .URL_ANDROID_POST_GENERATE_DOWNLOAD_PWD),
                                      body: {
                                        "emailUser":
                                            empLoginConfig!.getUserEmail(),
                                        "userPassword": passMD5,
                                        "userPassword2": passSHA256,
                                        "plainDownloadPassword": pin1,
                                        "plainDownloadPassword2": pin2
                                      });
                                  var jsonData = jsonDecode(request.body)
                                      as Map<String, dynamic>;

                                  if (jsonData["resultado"] == "ok") {
                                    Map<String, String> args = {
                                      'titulo': 'Generar clave de descarga',
                                      'texto':
                                          'La clave se ha generado correctamente'
                                    };
                                    Navigator.pop(context);
                                    _showAlertDialog(context, args);
                                  } else if (jsonData["resultado"] == "error") {
                                    var r_str = jsonData["result_str"];
                                    Map<String, String> args = {
                                      'titulo':
                                          'Error en la generacion de clave'
                                    };

                                    if (r_str == "WEAK_PASSWORD_STRENGTH") {
                                      args.addAll({
                                        'texto':
                                            'La nueva clave de descarga no cumple los requisitos de complejidad (al menos 4 caracteres).'
                                      });
                                      args.addAll(
                                          {'tipo': 'WEAK_PASSWORD_STRENGTH'});
                                    } else if (r_str ==
                                        "ERROR_SAVING_TRY_AGAIN") {
                                      args.addAll({
                                        'texto':
                                            'Ha ocurrido un error al intentar guardar la nueva clave de descarga. Por favor, vuelva a intentarlo.'
                                      });
                                      args.addAll(
                                          {'tipo': 'ERROR_SAVING_TRY_AGAIN'});
                                    } else if (r_str ==
                                        "NEW_PASSWORDS_NOT_MATCH") {
                                      args.addAll({
                                        'texto':
                                            'La nueva clave de descarga y su repetición no coinciden.'
                                      });
                                      args.addAll(
                                          {'tipo': 'NEW_PASSWORDS_NOT_MATCH'});
                                    } else if (r_str ==
                                        "USER_OR_PASS_NOT_VALID") {
                                      args.addAll({
                                        'texto':
                                            'La contraseña del usuario no es correcta.'
                                      });
                                      args.addAll(
                                          {'tipo': 'USER_OR_PASS_NOT_VALID'});
                                    } else {
                                      args.addAll({
                                        'texto':
                                            'Ocurrió un error inesperado durante la generación/cambio de clave de descarga, vuelva a intentarlo y si el problema persiste contacte con soporte.'
                                      });
                                      args.addAll({'tipo': 'ERROR_UNKNOWN'});
                                    }
                                    Navigator.pop(context);
                                    _showAlertDialog(context, args);
                                  }
                                }
                              },
                              text: AppLocalizations.of(context)!.cambiarClave,
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

  Future<String> androidAppVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String versionCode = packageInfo.buildSignature;

    print(appName);
    print(packageName);
    print(version);
    print(buildNumber);
    print(versionCode);

    try {
      print(
          "-----------------------androidAppVersionInfo-----------------------");
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

  Future<void> _showTwoAuthDialog(BuildContext contextDrawer,
      TwoFAuth_stepObject twoFAuth_stepObject, String metodo) async {
    bool config = false;
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
          /*onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            openDialog(request);
          },*/
        ),
      )
      ..addJavaScriptChannel(
        'flutter_androidAppVersionInfo',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          var json = await androidAppVersionInfo();
          print("flutter_androidAppVersionInfo: ${message.message}");

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "androidAppVersionInfo", "response": $json}))''');
        },
      )
      ..addJavaScriptChannel(
        'flutter_androidGetUserLanguage',
        onMessageReceived: (webview.JavaScriptMessage message) {
          print("flutter_androidGetUserLanguage: ${message.message}");

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify( {‘questionAnswered’: ‘androidGetUserLanguage, ‘response’: ‘es_ES’}))''');
        },
      )
      ..addJavaScriptChannel(
        'flutter_androidGetUserTimeZone',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print("flutter_androidGetUserTimeZone: ${message.message}");

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify({‘questionAnswered’: ‘androidGetUserTimeZone, ‘response’: ‘Europe/Madrid }))''');
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onSuccess2FAuthCodeProcess',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print(
              "flutter_2FAuth_onSuccess2FAuthCodeProcess: ${message.message}");

          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onSuccess2FAuthConfigured',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print("flutter_2FAuth_onSuccess2FAuthConfigured: ${message.message}");

          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onSuccess2FAuthDeletion',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print("flutter_2FAuth_onSuccess2FAuthDeletion: ${message.message}");

          widget.usuario_pemp!.twoFAuth_configured = false;
          widget.usuario_pemp!.twoFAuth_stepConfig = null;

          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthDeletion',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print("flutter_2FAuth_onClose2FAuthDeletion: ${message.message}");
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthConfiguration',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print(
              "flutter_2FAuth_onClose2FAuthConfiguration: ${message.message}");
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthByNoRecoverableError',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print(
              "flutter_2FAuth_onClose2FAuthByNoRecoverableError: ${message.message}");
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_onClose2FAuthCodeProcess',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print("flutter_2FAuth_onClose2FAuthCodeProcess: ${message.message}");
          Navigator.pop(context);
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_retrieveValidationConfig',
        onMessageReceived: (webview.JavaScriptMessage message) async {
          print("flutter_2FAuth_retrieveValidationConfig: ${message.message}");

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

          config = true;
        },
      )
      ..addJavaScriptChannel(
        'flutter_2FAuth_printToConsoleLog',
        onMessageReceived: (webview.JavaScriptMessage message) {
          print("flutter_2FAuth_printToConsoleLog: ${message.message}");
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

  void _showAlertDialog(BuildContext context, Map<String, String> args) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(args['titulo'] ?? "Titulo"),
          content: Text(args['texto'] ?? "Titulo"),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                if (args['tipo'] != null) {
                  if (args['tipo'] == 'ERROR_REGISTERING_USER') {
                  } else if (args['tipo'] == 'USER_OR_PASS_NOT_VALID') {
                    //Navigator.of(context).pop();
                  } else if (args['tipo'] == 'TOKEN_USER_NOT_MATCH') {
                  } else if (args['tipo'] == 'UNLOCK_PASS_NOT_MATCH') {
                  } else if (args['tipo'] ==
                      'USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND') {
                  } else if (args['tipo'] == 'EXPIRED_PASSWORD') {
                  } else if (args['tipo'] == '2FAUTH_REQUIRED') {}
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> cambiarPlan() async {
    // Reseteamos la seleccion de EmpLoginConfig
    EmpLoginConfig empLoginConfig = EmpLoginConfig.fromJSON(
        json.decode(ServicioCache.prefs.getString("empLoginConfig")!));
    empLoginConfig.setSelectedFile(null);
    empLoginConfig.setSelectedEmpleado(null);
    empLoginConfig.setSelectedFileID(null);
    empLoginConfig.setSelectedEmpleadoID(null);

    ServicioCache.prefs
        .setString("empLoginConfig", json.encode(empLoginConfig.toJson()));
    context.pushNamed("Configuracion");
  }

  Widget seccion(
      BuildContext context, SeccionPortal seccionPortal, String ruta) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (seccionPortal.enabled) {
          if (seccionPortal.type == "native") {
            context.pushNamed(ruta);
          } else if (seccionPortal.type == "webview") {
            context.pushNamed("WebView", queryParameters: {
              'seccion': jsonEncode(seccionPortal.toJson()),
              'usuario_pemp': jsonEncode(widget.usuario_pemp!.toJson()),
              'empLoginConfig': jsonEncode(widget.empLoginConfig!.toJson())
            });
          }
        }
      },
      child: Container(
          width: 100.0,
          //height: 80.0,
          decoration: const BoxDecoration(),
          child: Stack(
            children: [
              (seccionPortal.iconBadge_value > 0)
                  ? Align(
                      alignment: AlignmentDirectional(0.6, -0.8),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.06,
                        height: MediaQuery.sizeOf(context).height * 0.03,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.red),
                        child: Text(
                          seccionPortal.iconBadge_value.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : SizedBox(),
              Align(
                alignment: AlignmentDirectional(0, 0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FaIcon(
                      IconDataSolid(int.parse(
                          (seccionPortal.iconUnicode.substring(
                              3, seccionPortal.iconUnicode.length - 1)),
                          radix: 16)),
                      color: (seccionPortal.enabled)
                          ? FlutterFlowTheme.of(context).primaryBackground
                          : const Color.fromARGB(255, 109, 106, 106),
                      size: 56.0,
                    ),
                    Text(
                      seccionPortal.name,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Readex Pro',
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            fontSize: 14.0,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget opcionesMenuPrincipal(
      BuildContext context, String ruta, String nombre, IconData icono) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        context.pushNamed(ruta);
      },
      child: Container(
        width: 100.0,
        height: 80.0,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FaIcon(
              icono,
              color: FlutterFlowTheme.of(context).primaryBackground,
              size: 56.0,
            ),
            Text(
              nombre,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    fontSize: 14.0,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
