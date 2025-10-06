import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:p_g_planning/l10n/app_localizations.dart';

import 'package:p_g_planning/model/empLoginConfig.dart';
import 'package:p_g_planning/model/locale.dart';
import 'package:p_g_planning/model/seccion_portal.dart';
import 'package:p_g_planning/model/two_FAuth_stepObject.dart';
import 'package:p_g_planning/model/usuario_pemp.dart';
import 'package:p_g_planning/model/parametros/parametros.dart';
import 'package:p_g_planning/servicio_cache.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'menu_lateral_model.dart';
export 'menu_lateral_model.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuLateralWidget extends StatefulWidget {
  final Future<void> Function(BuildContext)? openPinDialog;
  final Future<void> Function(BuildContext)? changeJavaScriptMode;
  final Future<void> Function(BuildContext, TwoFAuth_stepObject, String)?
      open2Auth;
  final void Function()? cargarParametros;
  final void Function(bool)? cargarWebView;
  final bool isWebView;
  final Usuario_pemp? usuario_pemp;
  final EmpLoginConfig? empLoginConfig;
  const MenuLateralWidget(
      {Key? key,
      this.openPinDialog,
      this.changeJavaScriptMode,
      this.open2Auth,
      this.cargarParametros,
      this.cargarWebView,
      required this.isWebView,
      this.usuario_pemp,
      this.empLoginConfig})
      : super(key: key);

  @override
  _MenuLateralWidgetState createState() => _MenuLateralWidgetState();
}

class _MenuLateralWidgetState extends State<MenuLateralWidget> {
  late MenuLateralModel _model;
  late MenuLateralWidget _widgetMenu;
  late List<SeccionPortal> listaSeccionesVisibles;

  final inferiorGlobalKey = GlobalKey();

  SizedBox? menuInferior;

  Widget? iconoLenguaje;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuLateralModel());
    _widgetMenu = widget;
    listaSeccionesVisibles = cambiarOpciones();
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Future<void> setLocale(String language) async {
    Response request = await post(Uri.parse(Parametros.URL_POST_CHANGE_LANG),
        body: jsonEncode(
            {'token': widget.empLoginConfig!.token, 'language': language}));

    print(request.body);
    var jsonData = jsonDecode(request.body);

    if (jsonData['resultado'] == 'ok') {
      if (_widgetMenu.isWebView) {
        _widgetMenu.cargarWebView!(true);
      }

      _widgetMenu.cargarParametros!();

      context.pop();
    } else if (jsonData['resultado'] == 'error') {}
  }

  void backHome(BuildContext context) {
    context.pushNamed("MenuPrincipal", queryParameters: {
      'usuario_pemp': jsonEncode(widget.usuario_pemp!.toJson()),
      'empLoginConfig': jsonEncode(widget.empLoginConfig!.toJson())
    });
  }

  List<SeccionPortal> cambiarOpciones() {
    List<SeccionPortal> lista = [];
    for (var element in _model.listaSecciones) {
      if (element.visible) {
        lista.add(element);
      }
    }

    return lista;
  }

  List<Widget> cambiarOpcionesLogin() {
    List<Widget> lista = [];
    lista.addAll(cabeceraMenu(context));
    if (_model.estadoMenuLateral == EstadoMenuLateral.inicial) {
      lista.add(opcionMenuRegistro(
          context,
          '',
          AppLocalizations.of(context)!.inicioSesion,
          Icons.house,
          _widgetMenu));
    } else if (_model.estadoMenuLateral == EstadoMenuLateral.accesoConLog) {
      lista.add(opcionMenuRegistro(
          context,
          'Inicio',
          AppLocalizations.of(context)!.cerrarSesion,
          Icons.logout,
          _widgetMenu));
      lista.add(opcionMenuRegistro(context, 'Clave',
          AppLocalizations.of(context)!.cambiarClave, Icons.lock, _widgetMenu));
      if (widget.usuario_pemp != null) {
        if (widget.usuario_pemp!.twoFAuth_configured &&
            widget.usuario_pemp!.twoFAuth_stepConfig != null) {
          if (widget.usuario_pemp!.twoFAuth_stepConfig!.twoFAuth_step == "0") {
            lista.add(opcionMenuRegistro(
                context,
                'ReconfigurarAut',
                AppLocalizations.of(context)!.reconfigAuth2,
                Icons.key,
                _widgetMenu));
          } else if (widget.usuario_pemp!.twoFAuth_stepConfig!.twoFAuth_step ==
              "AskForTwoAuthDeletion") {
            lista.add(opcionMenuRegistro(
                context,
                'EliminarAut',
                AppLocalizations.of(context)!.eliminarAuth2,
                Icons.key,
                _widgetMenu));
          }
        }
      }
      if (widget.usuario_pemp!.necesitaConfiguracion()) {
        lista.add(opcionMenuRegistro(
            context,
            'Configuracion',
            AppLocalizations.of(context)!.cambiarPlan,
            Icons.settings,
            _widgetMenu));
      }

      lista.add(const Divider(
        thickness: 2.0,
        color: Color.fromARGB(255, 12, 140, 195),
      ));
    }
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    print('reload');
    menuInferior ??= SizedBox(
      key: inferiorGlobalKey,
      width: double.infinity,
      child: Column(
          mainAxisSize: MainAxisSize.min, children: cambiarOpcionesLogin()),
    );
    return SafeArea(
        top: isAndroid,
        bottom: isAndroid,
        right: isAndroid,
        left: isAndroid,
        child: Container(
            //width: MediaQuery.sizeOf(context).width * 1,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(8, 42, 71, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: (isiOS)
                      ? EdgeInsetsDirectional.fromSTEB(
                          0, MediaQuery.of(context).padding.top, 0, 0)
                      : const EdgeInsetsDirectional.all(0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Container(
                          width: double.infinity,
                          height: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? ((isiOS)
                                  ? (MediaQuery.sizeOf(context).height -
                                          MediaQuery.of(context).padding.top) *
                                      0.08
                                  : MediaQuery.sizeOf(context).height * 0.08)
                              : ((isiOS)
                                  ? (MediaQuery.sizeOf(context).height -
                                          MediaQuery.of(context).padding.top) *
                                      0.16
                                  : MediaQuery.sizeOf(context).height * 0.16),
                          decoration: const BoxDecoration(),
                          child: const Image(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                  'assets/images/logotipo_pgplanning_blanco_plano.png'))),
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  thickness: 2.0,
                  color: Color.fromARGB(255, 12, 140, 195),
                ),
                SizedBox(
                  width: double.infinity,
                  height: (MediaQuery.sizeOf(context).height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom) -
                      ((MediaQuery.of(context).orientation ==
                              Orientation.portrait)
                          ? MediaQuery.sizeOf(context).height * 0.08
                          : MediaQuery.sizeOf(context).height * 0.16) -
                      10,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (listaSeccionesVisibles.isNotEmpty)
                          ? Expanded(
                              //height: MediaQuery.sizeOf(context).height * 0.25,
                              child: ListView.builder(
                              //reverse: true,
                              padding: const EdgeInsets.all(0),
                              physics: const ClampingScrollPhysics(),
                              itemCount: listaSeccionesVisibles.length,
                              itemBuilder: (context, index) {
                                return opcionMenu(
                                    context,
                                    listaSeccionesVisibles[index].name,
                                    listaSeccionesVisibles[index]);
                              },
                            ))
                          : Container(),
                      (listaSeccionesVisibles.isNotEmpty)
                          ? const Divider(
                              height: 1,
                              thickness: 1.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            )
                          : Container(),
                      menuInferior!
                    ],
                  ),
                ),
              ],
            )));
  }

  Widget opcionMenu(
      BuildContext context, String ruta, SeccionPortal seccionPortal) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (seccionPortal.enabled) {
          if (seccionPortal.type == "native") {
            if (ruta == "MenuPrincipal") {
              backHome(context);
            }
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
        width: double.infinity,
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.sizeOf(context).height * 0.08
            : MediaQuery.sizeOf(context).height * 0.1,
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.08,
                child: FaIcon(
                  IconDataSolid(int.parse(
                      (seccionPortal.iconUnicode
                          .substring(3, seccionPortal.iconUnicode.length - 1)),
                      radix: 16)),
                  color: (seccionPortal.enabled)
                      ? FlutterFlowTheme.of(context).primaryBackground
                      : const Color.fromARGB(255, 109, 106, 106),
                  size: 24.0,
                ),
              ),
            ),
            SizedBox(
              width:
                  (MediaQuery.of(context).orientation == Orientation.portrait)
                      ? MediaQuery.sizeOf(context).width * 0.5
                      : MediaQuery.sizeOf(context).height * 0.4,
              child: Text(
                (seccionPortal.name == 'MenuPrincipal')
                    ? AppLocalizations.of(context)!.inicio
                    : seccionPortal.name,
                textAlign: TextAlign.start,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).primaryBackground,
                    ),
              ),
            ),
            (seccionPortal.iconBadge_value > 0)
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 3, 10, 3),
                      child: Text(
                        seccionPortal.iconBadge_value.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
                : const SizedBox()
          ].divide(const SizedBox(width: 10.0)),
        ),
      ),
    );
  }

  Widget opcionMenuRegistro(BuildContext context, String ruta, String titulo,
      IconData icono, MenuLateralWidget widgetMenu) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        if (ruta == "Inicio") {
          // Reseteamos la cache y vamos a Inicio
          EmpLoginConfig? empLoginConfig = EmpLoginConfig.fromJSON(
              json.decode(ServicioCache.prefs.getString("empLoginConfig")!));
          Usuario_pemp? usuario_pemp = Usuario_pemp.fromJSON(
              json.decode(ServicioCache.prefs.getString("usuario_pemp")!));
          ServicioCache.prefs.clear();

          var API_call_url = Parametros.URL_ANDROIDPOST_LOGOUT_EMPLOYEE;
          var token = "";
          if (empLoginConfig != null) {
            token = empLoginConfig.getToken()!;
          } else if (usuario_pemp != null) {
            token = usuario_pemp.token;
          } else {
            context.pushNamed(ruta);
            return;
          }

          Provider.of<LocaleModel>(context, listen: false)
            .set(Locale(Platform.localeName));
          ServicioCache.prefs
          .setString('language', Locale(Platform.localeName).languageCode.split('_')[0]);

          context.pushNamed(ruta);

          Response request = await post(Uri.parse(API_call_url), body: {
            "token": token,
          });
        }
        if (ruta == "Configuracion") {
          // Reseteamos la seleccion de EmpLoginConfig
          EmpLoginConfig empLoginConfig = EmpLoginConfig.fromJSON(
              json.decode(ServicioCache.prefs.getString("empLoginConfig")!));
          //empLoginConfig.setSelectedEmpresa(null);
          empLoginConfig.setSelectedArea(null);
          empLoginConfig.setSelectedFile(null);
          empLoginConfig.setSelectedEmpleado(null);
          //empLoginConfig.setSelectedEmpresaID(null);
          empLoginConfig.setSelectedAreaID(null);
          empLoginConfig.setSelectedFileID(null);
          empLoginConfig.setSelectedEmpleadoID(null);
          empLoginConfig.setEmployeeName(null);
          empLoginConfig.setIsLogged(false);
          ServicioCache.prefs.setString(
              "empLoginConfig", json.encode(empLoginConfig.toJson()));
          context.pushNamed(ruta);
        }
        if (ruta == "Clave") {
          // Mostramos el webView (en formato ventana)
          Navigator.pop(context);

          // Si es IOS desactivamos el javascript para evitar el bug de que el web view
          // detecte los eventos del dialogo, y cuando termine el dialogo lo reactivamos
          if (isiOS) {
            if (widgetMenu.isWebView) {
              widgetMenu.changeJavaScriptMode!(context);
            }
          }
          widgetMenu.openPinDialog!(context);
        }
        if (ruta == "ReconfigurarAut") {
          Navigator.pop(context);
          //Navigator.pop(context);
          widgetMenu.open2Auth!(
              context, widgetMenu.usuario_pemp!.twoFAuth_stepConfig!, "");
        }
        if (ruta == "EliminarAut") {
          Navigator.pop(context);
          widgetMenu.open2Auth!(
              context, widgetMenu.usuario_pemp!.twoFAuth_stepConfig!, "");
        }
      },
      child: Container(
        width: double.infinity,
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? MediaQuery.sizeOf(context).height * 0.07
            : MediaQuery.sizeOf(context).height * 0.1,
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.08,
                child: Icon(
                  icono,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 24.0,
                ),
              ),
            ),
            Text(
              titulo,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).primaryBackground,
                  ),
            ),
          ].divide(const SizedBox(width: 10.0)),
        ),
      ),
    );
  }

  List<Widget> cabeceraMenu(BuildContext context) {
    List<Widget> lista = [];
    lista.add(const Divider(
      thickness: 2.0,
      color: Color.fromARGB(255, 12, 140, 195),
    ));
    lista.add(Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          AppLocalizations.of(context)!.principal,
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
        ),
        (widget.empLoginConfig != null)
            ? (widget.empLoginConfig!.selectedFile!.langSelectableByEmployee)
                ? const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: SizedBox(
                        height: 30,
                        child: VerticalDivider(
                          color: Color.fromARGB(255, 12, 140, 195),
                          thickness: 2,
                        )),
                  )
                : const SizedBox()
            : const SizedBox(),
        (widget.empLoginConfig != null)
            ? (widget.empLoginConfig!.selectedFile!.langSelectableByEmployee)
                ? Consumer<LocaleModel>(
                    builder: (context, localeModel, child) =>
                        DropdownButton<String>(
                      icon: SizedBox(
                          child: SvgPicture.asset(
                              'assets/images/${localeModel.locale!.languageCode}.svg',
                              width: 30)),
                      items: [
                        DropdownMenuItem<String>(
                          value: 'es',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: SvgPicture.asset('assets/images/es.svg',
                                    fit: BoxFit.fitHeight, width: 40),
                              ),
                              SizedBox(width: 36, child: Text('es')),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'en',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: SvgPicture.asset('assets/images/en.svg',
                                    fit: BoxFit.fitHeight, width: 40),
                              ),
                              SizedBox(width: 36, child: Text('en')),
                            ],
                          ),
                        ),
                        DropdownMenuItem<String>(
                          value: 'pt',
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: SvgPicture.asset('assets/images/pt.svg',
                                    fit: BoxFit.fitHeight, width: 40),
                              ),
                              SizedBox(width: 36, child: Text('pt')),
                            ],
                          ),
                        )
                      ],
                      onChanged: (value) {
                        print(value);
                        print(iconoLenguaje.toString());
                        menuInferior = null;
                        if (value == 'es') {
                          localeModel.set(Locale('es'));
                          setLocale("es");
                          ServicioCache.prefs.setString('language', 'es');
                          var a = widget.empLoginConfig;
                          a!.selectedEmp!.langEMP = 'es';
                          ServicioCache.prefs
                              .setString("empLoginConfig", jsonEncode(a));
                          setState(() {
                            iconoLenguaje = SizedBox(
                                child: SvgPicture.asset('assets/images/es.svg',
                                    width: 30));
                          });
                        }
                        if (value == 'en') {
                          localeModel.set(Locale('en'));
                          setLocale("en");
                          ServicioCache.prefs.setString('language', 'en');
                          var a = widget.empLoginConfig;
                          a!.selectedEmp!.langEMP = 'en';
                          print(
                              'int4: ${a.selectedEmpresa!.listaAreas[1].listaFiles[2].toJson()}');
                          ServicioCache.prefs
                              .setString("empLoginConfig", jsonEncode(a));
                          setState(() {
                            iconoLenguaje = SizedBox(
                                child: SvgPicture.asset('assets/images/en.svg',
                                    width: 30));
                          });
                        }
                        if (value == 'pt') {
                          localeModel.set(Locale('pt'));
                          setLocale("pt");
                          ServicioCache.prefs.setString('language', 'pt');
                          var a = widget.empLoginConfig;
                          a!.selectedEmp!.langEMP = 'pt';
                          ServicioCache.prefs
                              .setString("empLoginConfig", jsonEncode(a));
                          setState(() {
                            iconoLenguaje = SizedBox(
                                child: SvgPicture.asset('assets/images/pt.svg',
                                    width: 30));
                          });
                        }
                      },
                      hint: Text(
                        AppLocalizations.of(context)!.idioma,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Readex Pro',
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                      ),
                    ),
                  )
                : const SizedBox()
            : const SizedBox(),
      ],
    ));
    lista.add(const Divider(
      thickness: 2.0,
      color: Color.fromARGB(255, 12, 140, 195),
    ));
    return lista;
  }
}
