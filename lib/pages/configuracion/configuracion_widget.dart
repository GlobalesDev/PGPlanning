import 'dart:convert';
import 'package:http/http.dart';
import 'package:p_g_planning/l10n/app_localizations.dart';

import 'package:p_g_planning/model/area.dart';
import 'package:p_g_planning/model/empLoginConfig.dart';
import 'package:p_g_planning/model/empleado.dart';
import 'package:p_g_planning/model/empresa.dart';
import 'package:p_g_planning/model/locale.dart';
import 'package:p_g_planning/model/usuario_pemp.dart';
import 'package:p_g_planning/model/parametros/parametros.dart';
import 'package:p_g_planning/pages/configuracion/configuracion_model.dart';
import 'package:p_g_planning/servicio_cache.dart';
import 'package:p_g_planning/model/file.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:provider/provider.dart';
import '/components/menu_lateral_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
export 'configuracion_model.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfiguracionWidget extends StatefulWidget {
  const ConfiguracionWidget({Key? key}) : super(key: key);

  @override
  _ConfiguracionWidgetState createState() => _ConfiguracionWidgetState();
}

class _ConfiguracionWidgetState extends State<ConfiguracionWidget>
    with WidgetsBindingObserver {
  late ConfiguracionModel _model;

  Usuario_pemp? usuario_pemp;
  EmpLoginConfig? empLoginConfig;

  Empresa? empresaSelect;
  DropdownSearch<Empresa>? selectorEmpresa;
  List<Empresa>? listaEmpresa;
  Area? areaSelect;
  DropdownSearch<Area>? selectorArea;
  List<Area>? listaArea;
  File? fileSelect;
  DropdownSearch<File>? selectorFile;
  List<File>? listaFile;
  Empleado? empleadoSelect;
  DropdownSearch<Empleado>? selectorEmpleado;
  List<Empleado>? listaEmpleado;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConfiguracionModel());
    getConfiguracionMenu();
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

  void getConfiguracionMenu() async {
    String? modelo = await ServicioCache.getEstadoMenu();

    if (modelo != null && modelo == EstadoMenuLateral.accesoConLog.name) {
      _model.menuLateralModel.estadoMenuLateral =
          EstadoMenuLateral.accesoConLog;
    }

    EmpLoginConfig empLoginConfig = EmpLoginConfig.fromJSON(
        json.decode(ServicioCache.prefs.getString("empLoginConfig")!));

    Response request = await post(
        Uri.parse(Parametros.URL_ANDROIDPOST_GET_EMPLOYEE_DATA),
        body: {'token': empLoginConfig.token ?? ""});

    var jsonData = jsonDecode(request.body);

    if (jsonData["resultado"] == "ok") {
      print('entro en ok');
      usuario_pemp = Usuario_pemp.fromBD(jsonData['usuario']);
    } else {
      usuario_pemp = Usuario_pemp.fromJSON(
          json.decode(ServicioCache.prefs.getString("usuario_pemp")!));
    }

    listaEmpresa = usuario_pemp!.getListaEmpresas();
    if (listaEmpresa!.length == 1) {
      empresaSelect = listaEmpresa![0];
      listaArea = empresaSelect!.getListaAreas();
      if (listaArea!.length == 1) {
        areaSelect = listaArea![0];
        listaFile = areaSelect!.getListaFiles();
        if (listaFile!.length == 1) {
          fileSelect = listaFile![0];
          listaEmpleado = fileSelect!.getListaEmpleados();
          if (listaEmpleado!.length == 1) {
            empleadoSelect = listaEmpleado![0];
            // Solo una configuracion (Entrar automaticamente???)
          }
        }
      }
    }

    if (empLoginConfig.getSelectedEmpresa() != null) {
      empresaSelect = usuario_pemp!.listaEmpresas.firstWhere(
          (emp) => emp.id == empLoginConfig.getSelectedEmpresa()!.id);
      //empresaSelect = empLoginConfig.getSelectedEmpresa();
      listaArea = empresaSelect!.getListaAreas();

      if (empLoginConfig.getSelectedArea() != null) {
        areaSelect = listaArea!.firstWhere(
            (area) => area.id == empLoginConfig.getSelectedArea()!.id);
        listaFile = areaSelect!.getListaFiles();
      } else if (listaArea!.length == 1) {
        areaSelect = listaArea![0];
        listaFile = areaSelect!.getListaFiles();
      }
    }

    setState(() {});
  }

  void configurarPuesto() async {
    Response request = await post(
        Uri.parse(Parametros.URL_ANDROIDPOST_CONFIG_EMPLOYEE),
        body: {
          "token": usuario_pemp!.token,
          "idEmpresa": empresaSelect!.id.toString(),
          "idArea": areaSelect!.id.toString(),
          "idFile": fileSelect!.id.toString(),
          "idEmpleadoPlan": empleadoSelect!.id.toString(),
          "origin": isiOS ? "APP_IOS" : "APP_ANDROID"
        });

    print(request.body);

    var jsonData = jsonDecode(request.body) as Map<String, dynamic>;

    if (jsonData['resultado'] == 'ok') {
      // Comprobamos si la planificacion permite al usuario seleccionar el idioma de la app
      if (fileSelect!.langSelectableByEmployee) {
        // Si el empleado tiene un lenguaje 
        if (empLoginConfig!.selectedEmp!.langEMP != "") {
          Provider.of<LocaleModel>(context, listen: false)
              .set(Locale(empLoginConfig!.selectedEmp!.langEMP.split('_')[0]));
          ServicioCache.prefs.setString(
              'language', empLoginConfig!.selectedEmp!.langEMP.split('_')[0]);
        } else { // Si el empleado no tiene lenguaje asignado
          Provider.of<LocaleModel>(context, listen: false)
              .set(Locale(fileSelect!.langDefault.split('_')[0]));
          ServicioCache.prefs.setString(
              'language', fileSelect!.langDefault.split('_')[0]);
        }
      } else { // Si el usuario no puede seleccionar el idioma
          Provider.of<LocaleModel>(context, listen: false)
              .set(Locale(fileSelect!.langDefault.split('_')[0]));
          ServicioCache.prefs.setString(
              'language', fileSelect!.langDefault.split('_')[0]);
      }

      print('------------------------------');
      print('Lenguaje: ${empLoginConfig!.selectedEmp!.langEMP}');
      print('------------------------------');

      context.pushNamed("MenuPrincipal", queryParameters: {
        'usuario_pemp': jsonEncode(usuario_pemp!.toJson()),
        'empLoginConfig': jsonEncode(empLoginConfig!.toJson())
      });
    } else if (jsonData['resultado'] == 'error') {
    } else if (jsonData['resultado'] == 'exception') {}
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
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }

          //Solo Android
          SystemNavigator.pop();
          context.pushNamed("Inicio");
        },
        child: GestureDetector(
          onTap: () => _model.unfocusNode.canRequestFocus
              ? FocusScope.of(context).requestFocus(_model.unfocusNode)
              : FocusScope.of(context).unfocus(),
          child: Scaffold(
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
              left: isAndroid,
              right: isAndroid,
              child: Container(
                width: MediaQuery.sizeOf(context).width,
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
                child: Column(
                  children: [
                    Material(
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
                            //borderRadius: BorderRadius.circular(16.0),
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
                                width: MediaQuery.sizeOf(context).width * 0.75,
                                child: Padding(
                                  padding:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? const EdgeInsets.all(0)
                                          : const EdgeInsets.all(8),
                                  child: Image(
                                      fit:
                                          (MediaQuery.of(context).orientation ==
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
                    (usuario_pemp == null)
                        ? const CircularProgressIndicator()
                        : Container(
                            width: double.infinity,
                            height: (MediaQuery.sizeOf(context).height -
                                    MediaQuery.of(context).padding.top -
                                    MediaQuery.of(context).padding.bottom) -
                                ((MediaQuery.of(context).orientation ==
                                        Orientation.portrait)
                                    ? MediaQuery.sizeOf(context).height * 0.08
                                    : MediaQuery.sizeOf(context).height * 0.16),
                            child: SingleChildScrollView(
                              child: Column(children: [
                                Padding(
                                  padding:
                                      (MediaQuery.of(context).orientation ==
                                              Orientation.portrait)
                                          ? EdgeInsetsDirectional.fromSTEB(
                                              MediaQuery.sizeOf(context).width *
                                                  0.25,
                                              30,
                                              MediaQuery.sizeOf(context).width *
                                                  0.25,
                                              0)
                                          : EdgeInsetsDirectional.fromSTEB(
                                              MediaQuery.sizeOf(context).width *
                                                  0.35,
                                              10,
                                              MediaQuery.sizeOf(context).width *
                                                  0.35,
                                              0),
                                  child: const Image(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                          'assets/images/logotipo_pgplanning_72dp.png')),
                                ),
                                menuSeleccion(context)
                              ]),
                            )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  List<DropdownMenuEntry<Empresa>> getListaEmpresas(List<Empresa> listaEmp) {
    List<DropdownMenuEntry<Empresa>> lista = [];
    listaEmp.forEach((element) {
      lista.add(DropdownMenuEntry(value: element, label: element.name));
    });
    return lista;
  }

  List<DropdownMenuEntry<Area>> getListaAreas(List<Area> listaEmp) {
    List<DropdownMenuEntry<Area>> lista = [];
    listaEmp.forEach((element) {
      lista.add(DropdownMenuEntry(value: element, label: element.name));
    });
    return lista;
  }

  List<DropdownMenuEntry<File>> getListaFiles(List<File> listaEmp) {
    List<DropdownMenuEntry<File>> lista = [];
    listaEmp.forEach((element) {
      lista.add(DropdownMenuEntry(value: element, label: element.name));
    });
    return lista;
  }

  Widget menuSeleccion(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        (listaEmpresa!.isEmpty || listaEmpresa!.length == 1)
            ? Container()
            : ((empresaSelect != null)
                ? dropdownEmpresa(listaEmpresa!, empresaSelect)
                : dropdownEmpresa(listaEmpresa!, null)),
        (listaArea == null || listaArea!.length == 1)
            ? Container()
            : ((areaSelect != null)
                ? dropdownArea(listaArea!, areaSelect)
                : dropdownArea(listaArea!, null)),
        (listaFile == null || listaFile!.length == 1)
            ? Container()
            : ((fileSelect != null)
                ? dropdownFile(listaFile!, fileSelect)
                : dropdownFile(listaFile!, null)),
        (listaEmpleado == null || listaEmpleado!.length == 1)
            ? Container()
            : ((empleadoSelect != null)
                ? dropdownEmpleado(listaEmpleado!, empleadoSelect)
                : dropdownEmpleado(listaEmpleado!, null)),
        botonSeleccionar(context)
      ]),
    );
  }

  // Igual se pueden juntar las funciones comparando el tipo de item dymanic
  Widget dropdownEmpresa(List<Empresa> lista, Empresa? select) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${AppLocalizations.of(context)!.selectEmpresa}:",
            style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16),
          ),
          DropdownSearch<Empresa>(
              popupProps: const PopupProps.menu(fit: FlexFit.loose),
              selectedItem: select,
              itemAsString: (item) => item.name,
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.selectEmpresa,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 250, 250, 250))),
              onChanged: (value) {
                empresaSelect = value;
                areaSelect = null;
                fileSelect = null;
                empleadoSelect = null;
                listaArea = empresaSelect!.getListaAreas();
                if (listaArea!.length == 1) {
                  areaSelect = listaArea![0];
                  listaFile = listaArea![0].getListaFiles();
                  if (listaFile!.length == 1) {
                    fileSelect = listaFile![0];
                    listaEmpleado = fileSelect!.getListaEmpleados();
                    if (listaEmpleado!.length == 1) {
                      empleadoSelect = listaEmpleado![0];
                    }
                  }
                } else {
                  listaFile = null;
                }
                listaEmpleado = null;
                setState(() {});
              },
              items: lista),
        ]));
  }

  Widget dropdownArea(List<Area> lista, Area? select) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${AppLocalizations.of(context)!.selectArea}:",
            style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16),
          ),
          DropdownSearch<Area>(
              popupProps: const PopupProps.menu(fit: FlexFit.loose),
              selectedItem: select,
              itemAsString: (item) => item.name,
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.selectArea,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 250, 250, 250))),
              onChanged: (value) {
                areaSelect = value;
                fileSelect = null;
                empleadoSelect = null;
                listaFile = areaSelect!.getListaFiles();
                if (listaFile!.length == 1) {
                  fileSelect = listaFile![0];
                  listaEmpleado = listaFile![0].getListaEmpleados();
                  if (listaEmpleado!.length == 1) {
                    empleadoSelect = listaEmpleado![0];
                  }
                }
                setState(() {});
              },
              items: lista),
        ]));
  }

  Widget dropdownFile(List<File> lista, File? select) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${AppLocalizations.of(context)!.selectFile}:",
            style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16),
          ),
          DropdownSearch<File>(
              popupProps: const PopupProps.menu(fit: FlexFit.loose),
              selectedItem: select,
              itemAsString: (item) => item.name,
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.selectFile,
                      filled: true,
                      fillColor: const Color.fromARGB(255, 250, 250, 250))),
              onChanged: (value) {
                fileSelect = value;
                empleadoSelect = null;
                listaEmpleado = fileSelect!.getListaEmpleados();
                if (listaEmpleado!.length == 1) {
                  empleadoSelect = listaEmpleado![0];
                }
                setState(() {});
              },
              items: lista),
        ]));
  }

  Widget dropdownEmpleado(List<Empleado> lista, Empleado? select) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${AppLocalizations.of(context)!.selectEmpleado}:",
            style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1), fontSize: 16),
          ),
          DropdownSearch<Empleado>(
              popupProps: const PopupProps.menu(fit: FlexFit.loose),
              selectedItem: select,
              itemAsString: (item) => item.name,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.selectEmpleado,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 250, 250, 250)),
              ),
              onChanged: (value) {
                empleadoSelect = value;
                setState(() {});
              },
              items: lista),
        ]));
  }

  Widget botonSeleccionar(BuildContext context) {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
        child: FFButtonWidget(
          onPressed: () {
            print(empresaSelect!.name);
            print(areaSelect!.name);
            print(fileSelect!.name);
            print(empleadoSelect!.name);

            empLoginConfig = EmpLoginConfig.fromJSON(
                json.decode(ServicioCache.prefs.getString("empLoginConfig")!));

            // Guardar en la cache las elecciones de usuario
            if (empresaSelect != null &&
                areaSelect != null &&
                fileSelect != null &&
                empleadoSelect != null) {
              _model.menuLateralModel.estadoMenuLateral =
                  EstadoMenuLateral.accesoConLog;
              ServicioCache.prefs.setString(
                  "estadoMenu", _model.menuLateralModel.estadoMenuLateral.name);

              empLoginConfig!.setIsLogged(true);
              empLoginConfig!.setSelectedEmpresa(empresaSelect!);
              empLoginConfig!.setSelectedEmpresaID(empresaSelect!.id);
              empLoginConfig!.setSelectedArea(areaSelect!);
              empLoginConfig!.setSelectedAreaID(areaSelect!.id);
              empLoginConfig!.setSelectedFile(fileSelect!);
              empLoginConfig!.setSelectedFileID(fileSelect!.id);
              empLoginConfig!.setSelectedEmpleado(empleadoSelect!);
              empLoginConfig!.setSelectedEmpleadoID(empleadoSelect!.id);
              empLoginConfig!.setEmployeeName(empleadoSelect!.name);
              ServicioCache.prefs.setString(
                  "empLoginConfig", jsonEncode(empLoginConfig!.toJson()));
              configurarPuesto();
            }
          },
          text: AppLocalizations.of(context)!.aceptarM,
          options: FFButtonOptions(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
            iconPadding:
                const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            color: const Color.fromRGBO(15, 134, 208, 1),
            textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                fontFamily: 'Readex Pro', color: Colors.white, fontSize: 14),
            elevation: 3.0,
            borderRadius: BorderRadius.circular(25.0),
          ),
        ));
  }
}
