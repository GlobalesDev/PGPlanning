import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:crypto/crypto.dart';
import 'package:device_info/device_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p_g_planning/flutter_flow/flutter_flow_widgets.dart';
import 'package:p_g_planning/l10n/app_localizations.dart';
import 'package:p_g_planning/model/empLoginConfig.dart';
import 'package:p_g_planning/model/seccion_param_type.dart';
import 'package:p_g_planning/model/seccion_portal.dart';
import 'package:p_g_planning/model/usuario_pemp.dart';
import 'package:p_g_planning/model/parametros/parametros.dart';
import 'package:p_g_planning/pages/web_view/web_view_model.dart';
import 'package:p_g_planning/servicio_cache.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

import '/components/menu_lateral_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:app_settings/app_settings.dart';

class WebViewWidget extends StatefulWidget {
  final SeccionPortal? seccion;
  final Usuario_pemp? usuario_pemp;
  final EmpLoginConfig? empLoginConfig;
  const WebViewWidget(
      {Key? key, required this.seccion, this.usuario_pemp, this.empLoginConfig})
      : super(key: key);

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

enum NOTIFICATION_TYPE {
  JSAPPI_NOTIFICATION__NO_LOCATION_PERMISSION,
  JSAPPI_NOTIFICATION__PERMISSION_DENIED,
  JSAPPI_NOTIFICATION__EXISTS_LOCATION_PERMISSION,
  JSAPPI_NOTIFICATION__NO_LOCATION_PROVIDER,
  JSAPPI_NOTIFICATION__SEARCHING_FOR_LOCATION,
  JSAPPI_NOTIFICATION__NEW_LOCATION_AVAILABLE
}

class _WebViewWidgetState extends State<WebViewWidget>
    with WidgetsBindingObserver {
  late WebViewModel _model;
  EmpLoginConfig? empLoginConfig;
  String? urlActual;
  String? urlInicial;
  bool mostrarInfoEmpresa = false;
  List<SeccionPortal> listaDatosSecciones = [];
  String nombreFichero = "";
  bool camaraSelect = false;
  bool galeriaSelect = false;
  CameraController? _cameraController;
  SeccionPortal? infoSeccion;
  InAppWebViewController? webviewController;
  Usuario_pemp? usuario_pemp;
  bool primeraCarga = true;
  Timer? temporizador;
  Position? _currentPosition;
  JavaScriptMode mode = JavaScriptMode.unrestricted;

  late final webview.PlatformWebViewControllerCreationParams params;
  late final webview.WebViewController controller;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  NativeDeviceOrientation? orientation;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizer = {
    Factory(() => EagerGestureRecognizer())
  };

  UniqueKey _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WebViewModel());

    WidgetsBinding.instance.addObserver(this);
    getConfiguracionMenu();
    cargarWebView(false);
  }

  void cargarWebView(bool recarga) {
    getUrl().then((value) {
      if (recarga) {
        controller.reload();
      } else {
        if (webview.WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const webview.PlatformWebViewControllerCreationParams();
      }
      controller = webview.WebViewController.fromPlatformCreationParams(params);

      if (controller.platform is AndroidWebViewController) {
        //AndroidWebViewController.enableDebugging(true);
        (controller.platform as AndroidWebViewController)
            .setMediaPlaybackRequiresUserGesture(false);
        (controller.platform as AndroidWebViewController)
            .setOnShowFileSelector(_seleccionarInput);
      }

      /*if (controller.platform is WebKitWebViewPlatform) {
      var con = WebKitWebViewController(webview.PlatformWebViewControllerCreationParams)
    }*/

      controller
        ..enableZoom(false)
        ..setJavaScriptMode(mode)
        //..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          webview.NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView is loading (progress : $progress%)');
            },
            onPageStarted: (String url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (String url) async {
              /*var a = await controller.runJavaScript('androidAppVersionInfo');
            print(a);*/
              debugPrint('Page finished loading: $url');

              if (primeraCarga) {
                primeraCarga = false;
              }
              setState(() {});
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

            print('Imprimir el JSOON');
            print(json);

            controller.runJavaScript(
                '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "androidAppVersionInfo", "response": $json}))''');
          },
        )
        ..addJavaScriptChannel(
          'flutter_androidDownloadFile',
          onMessageReceived: (webview.JavaScriptMessage message) {
            var json = jsonDecode(message.message);

            print(json.toString());
            prepararArchivoDescargado(
                json['fileContent'], json['fileName'], json['fileMimeType']);
          },
        )
        ..addJavaScriptChannel(
          'flutter_gdoc_beforeRequestExploreFiles',
          onMessageReceived: (webview.JavaScriptMessage message) async {
            // Comprobar permisos de la camara (abriendo una nueva)

            await Permission.camera.request();
            await Permission.microphone.request();
          },
        )
        ..addJavaScriptChannel('flutter_JSAPPI_getLocationUpdates',
            onMessageReceived: (webview.JavaScriptMessage message) {
          print(message.message);

          // Obtenemos la ubicacion
          _getCurrentPosition().then((value) {
            print("Actual: ${_currentPosition!.toJson()}");

            var coordenadas = {};

            if (_currentPosition != null) {
              coordenadas = {
                'latitud': _currentPosition!.latitude,
                'longitud': _currentPosition!.longitude,
                'accuracy': _currentPosition!.accuracy
              };
            }

            controller.runJavaScript(
                '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "JSAPPI_getLocationUpdates", "response": $coordenadas}))''');
          });
        })
        ..addJavaScriptChannel('flutter_JSAPPI_getBaseSystemOrigin',
            onMessageReceived: (webview.JavaScriptMessage message) {
          print(message.message);
          String json = "";
          if (isiOS) {
            json = 'FLUTTER_IOS';
          } else if (isAndroid) {
            json = 'FLUTTER_ANDROID';
          }

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "JSAPPI_getBaseSystemOrigin", "response": $json}))''');
        })
        ..addJavaScriptChannel(
          'flutter_JSAPPI_getUserLanguage',
          onMessageReceived: (webview.JavaScriptMessage message) async {
            controller.runJavaScript(
                '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "JSAPPI_getUserLanguage", "response": 'es_ES'}))''');
          },
        )
        ..addJavaScriptChannel('flutter_JSAPPI_getUserTimeZone',
            onMessageReceived: (webview.JavaScriptMessage message) {
          print(message.message);

          controller.runJavaScript(
              '''flutterNativeWebView_resolveResponseFor(JSON.stringify({"questionAnswered": "JSAPPI_getUserTimeZone", "response": 'Europe/Madrid'}))''');
        })
        ..addJavaScriptChannel('flutter_JSAPPI_closeWebviewCommand',
            onMessageReceived: (webview.JavaScriptMessage message) {
          //print(message.message);
          print('-------------------Boton volver------------------');

          context.pushNamed("MenuPrincipal", queryParameters: {
            'usuario_pemp': jsonEncode(widget.usuario_pemp!.toJson()),
            'empLoginConfig': jsonEncode(widget.empLoginConfig!.toJson())
          }).then((value) {
            dispose();
          });
        })
        ..addJavaScriptChannel('flutter_JSAPPI_signingBackButtonPressed',
            onMessageReceived: (webview.JavaScriptMessage message) {
          print('flutter_JSAPPI_signningBackButtonPressed');
          print(message.message);

          context.pushNamed("MenuPrincipal", queryParameters: {
            'usuario_pemp': jsonEncode(widget.usuario_pemp!.toJson()),
            'empLoginConfig': jsonEncode(widget.empLoginConfig!.toJson())
          }).then((value) {
            dispose();
          });
        })
        ..addJavaScriptChannel('flutter_JSAPPI_enableLocationProviders',
            onMessageReceived: (webview.JavaScriptMessage message) {
          print(message.message);

          // Comprobamos si los permisos de Geolocalizacion se encuentra activos
          // y en caso contrario los solicitamos al usuario
          _handleLocationPermission();
        })
        ..addJavaScriptChannel('flutter_JSAPPI_locationIsGoingToBeRequested',
            onMessageReceived: (webview.JavaScriptMessage message) {
          print('flutter_JSAPPI_locationIsGoingToBeRequested');

          Geolocator.requestPermission().then((value) {
            print(value.toString());
            if (value == LocationPermission.whileInUse ||
                value == LocationPermission.always) {
              Geolocator.isLocationServiceEnabled().then((active) {
                if (active) {
                  controller.runJavaScript(
                      '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__EXISTS_LOCATION_PERMISSION", "notification" : ""}))''');
                  controller.runJavaScript(
                      '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__SEARCHING_FOR_LOCATION", "notification" : ""}))''');

                  _getCurrentPosition().then((value) {
                    var coordenadas = {};

                    if (_currentPosition != null) {
                      coordenadas = {
                        'latitude': _currentPosition!.latitude,
                        'longitude': _currentPosition!.longitude,
                        'accuracy': _currentPosition!.accuracy
                      };
                    }

                    controller.runJavaScript(
                        '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__NEW_LOCATION_AVAILABLE", "notification" : ${jsonEncode(coordenadas)}}))''');
                  });
                } else {
                  Geolocator.openLocationSettings();
                }
              });
            } else if (value == LocationPermission.denied) {
              controller.runJavaScript(
                  '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__NO_LOCATION_PERMISSION", "notification" : ""}))''');
              _handleLocationPermission().then((value) {
                print('handleLocationPermision --> $value');
                if (value) {
                  controller.runJavaScript(
                      '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__EXISTS_LOCATION_PERMISSION", "notification" : ""}))''');
                  controller.runJavaScript(
                      '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__SEARCHING_FOR_LOCATION", "notification" : ""}))''');

                  _getCurrentPosition().then((value) {
                    //print("Actual: ${_currentPosition!.toJson()}");

                    var coordenadas = {};

                    if (_currentPosition != null) {
                      coordenadas = {
                        'latitude': _currentPosition!.latitude,
                        'longitude': _currentPosition!.longitude,
                        'accuracy': _currentPosition!.accuracy
                      };
                    }

                    controller.runJavaScript(
                        '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__NEW_LOCATION_AVAILABLE", "notification" : ${jsonEncode(coordenadas)}}))''');
                  });
                } else {
                  controller.runJavaScript(
                      '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__PERMISSION_DENIED", "notification" : ""}))''');
                }
              });
            } else if (value == LocationPermission.deniedForever) {
              controller.runJavaScript(
                  '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__PERMISSION_DENIED", "notification" : ""}))''');

              Geolocator.isLocationServiceEnabled().then((active) {
                if (active) {
                  dialogoGPS();
                } else {
                  dialogoActivarGps();
                }
              });
            }
          });
        })
        ..loadRequest(Uri.parse(urlActual!));

      usuario_pemp = Usuario_pemp.fromJSON(
          jsonDecode(ServicioCache.prefs.getString("usuario_pemp")!));
      }
      
    });
  }

  void dialogoActivarGps() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Debe de activar la ubicación de su dispositivo, desde Privacidad > Localización',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Geolocator.openLocationSettings();
                      context.pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Aceptar'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void dialogoGPS() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Los permisos han sido denegados, puede modificarlos desde los ajustes de PGPlanning',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.runJavaScript(
                              '''flutterNativeWebView_notificationOf(JSON.stringify({"notificationType" : "JSAPPI_NOTIFICATION__PERMISSION_DENIED", "notification" : ""}))''');
                          context.pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Cancelar'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //Geolocator.openLocationSettings();
                          AppSettings.openAppSettings(
                              type: AppSettingsType.location);
                          context.pop();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Aceptar'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void didChangeMetrics() {
    print('Rotacion');
    //scaffoldKey.currentState!.closeDrawer();
  }

  // Funcion que comprueba si el usuario a aceptado la peticion de la aplicacion
  // para acceder a su GPS
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _model.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      controller.reload();
    }
  }

  void cargarParametros() async {
    // Cargar dinamicamente las secciones
    Response request = await post(
        Uri.parse(Parametros.URL_ANDROIDPOST_GET_SECTIONS_PORTAL),
        body: {
          "token": widget.empLoginConfig!.token,
        });

    var json = jsonDecode(request.body);

    if (json['resultado'] == 'ok') {
      if (json['secciones'] != null) {
        listaDatosSecciones.clear();
        listaDatosSecciones.add(SeccionPortal('MenuPrincipal', 'native', true, true,
        'FontAwesome', 'fa-house', '&#xf015;', '', -1, '', []));
        for (var element in (json['secciones'] as List<dynamic>)) {
          var tmp = SeccionPortal.fromBD(element);
          if (tmp.iconBadge_callAPIFunction != '') {
            await tmp.getBagdeNumber();
          }
          listaDatosSecciones.add(tmp);
        }

        ServicioCache.prefs.setString("listaSecciones",
            jsonEncode(listaDatosSecciones.map((c) => c.toJson()).toList()));
        _model.menuLateralModel.listaSecciones = listaDatosSecciones;
        //getConfiguracionMenu();  
      } else {
        // Error no devuelve secciones
      }
    } 
  }

  void getConfiguracionMenu() async {
    String? modelo = await ServicioCache.getEstadoMenu();

    var jsonData = jsonDecode(ServicioCache.prefs.getString("listaSecciones")!);

    // Añadimos el inicio
    listaDatosSecciones.add(SeccionPortal('MenuPrincipal', 'native', true, true,
        'FontAwesome', 'fa-house', '&#xf015;', '', -1, '', []));

    for (var data in jsonData) {
      listaDatosSecciones.add(SeccionPortal.fromJSON(data));
    }
    _model.menuLateralModel.listaSecciones = listaDatosSecciones;

    if (modelo != null && modelo == EstadoMenuLateral.accesoConLog.name) {
      _model.menuLateralModel.estadoMenuLateral =
          EstadoMenuLateral.accesoConLog;
    }

    setState(() {});
  }

  Future<void> getUrl() async {
    setState(() {});
    infoSeccion = widget.seccion;
    String urlTmp = infoSeccion!.url;
    String getParams = "";
    String postParams = "";
    String region = await FlutterTimezone.getLocalTimezone();

    print(infoSeccion!.url);

    print(infoSeccion!.toJson().toString());

    infoSeccion!.parameters.forEach((element) {
      print(element);
      print(element.getKeyValueString());
      if (!element.calcParam) {
        var p = element.getKeyValueString();
        if (element.type == SeccionParamType.GET) {
          if (getParams.isNotEmpty) {
            getParams += '&';
          }
          getParams += p;
        } else {
          if (postParams.isNotEmpty) {
            postParams += '&';
          }
          postParams += p;
        }
      } else {
        String result = '';
        if (element.value == '[[SIGNING_ORIGIN]]') {
          result = isiOS ? 'FLUTTER_IOS' : 'FLUTTER_ANDROID';
        } else if (element.value == '[[TZ_VALUE]]') {
          result = region.toUpperCase();
        }
        if (element.type == SeccionParamType.GET) {
          if (getParams.isNotEmpty) {
            getParams += '&';
          }
          getParams += '${element.name}=$result';
        } else {
          if (postParams.isNotEmpty) {
            postParams += '&';
          }
          postParams += '${element.name}=$result';
        }
      }
    });

    if (getParams.isNotEmpty) {
      urlActual = "$urlTmp?$getParams";
      urlInicial = urlActual;
    }

    if (postParams.isNotEmpty) {
      urlActual = "$urlTmp?$postParams";
      urlInicial = urlActual;
    } else {}

    print('-------------------------------------');
    print(urlActual);
    print('-------------------------------------');

    //await Future.delayed(const Duration(seconds: 5));

    setState(() {});
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (Platform.isIOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Documents/'); // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}/$filename";
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

  Future<void> _changeJavaScriptMode(BuildContext context) async {
    if (isiOS) {
      if (mode == JavaScriptMode.disabled) {
        mode = JavaScriptMode.unrestricted;
        controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      } else {
        mode = JavaScriptMode.disabled;
        controller.setJavaScriptMode(JavaScriptMode.disabled);
      }
    }
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
              //physics: NeverScrollableScrollPhysics(),
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
                      'Generar / Cambiar clave de descarga',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                      child: Text(
                        'Para generar/cambiar su clave de descarga, debe introducir la contraseña actual de acceso al portal del empleado y la nueva clave de descarga, por duplicado. Recuerde que la nueva clave debe ser de al menos 4 caracteres.',
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
                        'Usuario: ${widget.empLoginConfig!.getEmployeeName()}',
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
                        decoration: const InputDecoration(
                            hintText: 'Contraseña de usuario',
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
                          decoration: const InputDecoration(
                              hintText: 'Clave descarga',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255)))),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 10),
                      child: TextField(
                        controller: pinRController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: 'Repetir clave',
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
                                if (isiOS) {
                                  _changeJavaScriptMode(context);
                                }
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
                                if (isiOS) {
                                  _changeJavaScriptMode(context);
                                }
                                if (passController.text != '' &&
                                    pinController.text != '' &&
                                    pinRController.text != '') {
                                  // Codificamos las claves
                                  print("Holaaaa");

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
                                  print(jsonData.toString());

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

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    bool isKeyboardOpen = bottomInsets != 0;
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

        print('urlActual: $urlActual');
        print('urlInicial: $urlInicial');
        if (urlActual == urlInicial) {
          context.pushNamed("MenuPrincipal", queryParameters: {
            'usuario_pemp': jsonEncode(widget.usuario_pemp!.toJson()),
            'empLoginConfig': jsonEncode(widget.empLoginConfig!.toJson())
          }).then((value) {
            dispose();
          });
        } else {
          bool can = await webviewController!.canGoBack();
          if (can) {
            await webviewController!.goBack();
          }
        }
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
                changeJavaScriptMode: _changeJavaScriptMode,
                cargarParametros: cargarParametros,
                cargarWebView: cargarWebView,
                isWebView: true,
                empLoginConfig: widget.empLoginConfig,
                usuario_pemp: widget.usuario_pemp,
              ),
            ),
          )),
          body: NativeDeviceOrientationReader(builder: (context) {
            var tmp = NativeDeviceOrientationReader.orientation(context);
            print('OrientacionTMP: ${tmp}');
            if (tmp != NativeDeviceOrientation.unknown) {
              orientation = tmp;
            }

            //print('Orientacion: ${orientation}');
            return SafeArea(
              top: isAndroid,
              bottom: isAndroid,
              left: false,
              right: false,
              /*left: (orientation ==
                  NativeDeviceOrientation.landscapeLeft), //isAndroid,
              right: (orientation == NativeDeviceOrientation.landscapeRight),*/
              child: (camaraSelect)
                  ? CameraPreview(_cameraController!)
                  : Container(
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
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Material(
                                  elevation: 30,
                                  child: Container(
                                    width: double.infinity,
                                    height:
                                        (MediaQuery.of(context).orientation ==
                                                Orientation.portrait)
                                            ? ((isiOS)
                                                ? (MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.08 +
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top)
                                                : MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.08)
                                            : ((isiOS)
                                                ? (MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.16 +
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top)
                                                : MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.16),
                                    decoration: const BoxDecoration(
                                        //borderRadius: BorderRadius.circular(16.0),
                                        color: Color.fromRGBO(8, 42, 71, 1)),
                                    alignment:
                                        const AlignmentDirectional(0.00, 0.00),
                                    child: Padding(
                                      padding: (isiOS)
                                          ? EdgeInsetsDirectional.fromSTEB(
                                              0,
                                              MediaQuery.of(context)
                                                  .padding
                                                  .top,
                                              0,
                                              0)
                                          : const EdgeInsetsDirectional.all(0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 20.0,
                                            borderWidth: 0.0,
                                            buttonSize: 60.0,
                                            icon: FaIcon(
                                              FontAwesomeIcons.bars,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              scaffoldKey.currentState!
                                                  .openDrawer();
                                            },
                                          ),
                                          SizedBox(
                                            width: MediaQuery.sizeOf(context)
                                                    .width *
                                                0.75,
                                            child: Padding(
                                              padding: (MediaQuery.of(context)
                                                          .orientation ==
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
                                            .addToStart(
                                                const SizedBox(width: 10.0)),
                                      ),
                                    ),
                                  ),
                                ),
                                (primeraCarga)
                                    ? SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        height:
                                            (MediaQuery.sizeOf(context).height -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .top -
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .bottom) -
                                                (MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.13),
                                        child: Center(
                                            child: Container(
                                                width:
                                                    MediaQuery.sizeOf(context)
                                                            .width *
                                                        0.75,
                                                decoration: const BoxDecoration(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                25))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(children: [
                                                    const Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(20,
                                                                    10, 30, 10),
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Color.fromRGBO(
                                                              15, 134, 208, 1),
                                                        )),
                                                    Text(AppLocalizations.of(
                                                            context)!
                                                        .cargando)
                                                  ]),
                                                ))),
                                      )
                                    : Container(
                                        width: MediaQuery.sizeOf(context).width,
                                        height: (MediaQuery.sizeOf(context).height -
                                                MediaQuery.of(context)
                                                    .padding
                                                    .top -
                                                MediaQuery.of(context)
                                                    .padding
                                                    .bottom) -
                                            ((MediaQuery.of(context).orientation ==
                                                    Orientation.portrait)
                                                ? (MediaQuery.sizeOf(context).height *
                                                    0.13)
                                                : (MediaQuery.sizeOf(context).height *
                                                    0.26)) -
                                            ((isKeyboardOpen)
                                                ? (bottomInsets -
                                                    ((MediaQuery.of(context).orientation == Orientation.portrait)
                                                        ? ((isiOS)
                                                            ? (MediaQuery.sizeOf(context).height * 0.05 +
                                                                MediaQuery.of(context)
                                                                    .padding
                                                                    .bottom)
                                                            : MediaQuery.sizeOf(context).height *
                                                                0.05)
                                                        : ((isiOS)
                                                            ? (MediaQuery.sizeOf(context).height * 0.1 +
                                                                MediaQuery.of(context)
                                                                    .padding
                                                                    .bottom)
                                                            : MediaQuery.sizeOf(context).height * 0.1)))
                                                : 0),
                                        child: webview.WebViewWidget(
                                          key: _key,
                                          controller: controller,
                                          gestureRecognizers: gestureRecognizer,
                                        ),
                                      ),
                                (isKeyboardOpen)
                                    ? const SizedBox()
                                    : Container(
                                        width: double.infinity,
                                        height: (MediaQuery.of(context)
                                                    .orientation ==
                                                Orientation.portrait)
                                            ? ((isiOS)
                                                ? (MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.05 +
                                                    MediaQuery.of(
                                                            context)
                                                        .padding
                                                        .bottom)
                                                : MediaQuery.sizeOf(
                                                            context)
                                                        .height *
                                                    0.05)
                                            : ((isiOS)
                                                ? (MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.1 +
                                                    MediaQuery.of(context)
                                                        .padding
                                                        .bottom)
                                                : MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.1),
                                        decoration: const BoxDecoration(
                                          color: Color.fromRGBO(8, 42, 71, 1),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              12,
                                              0,
                                              12,
                                              MediaQuery.of(context)
                                                  .padding
                                                  .bottom), //const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                                          child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                InkWell(
                                                  child: Text(
                                                    (widget.empLoginConfig !=
                                                            null)
                                                        ? widget.empLoginConfig!
                                                            .getEmployeeName()!
                                                        : "" /*'Empleado'*/,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    (mostrarInfoEmpresa)
                                                        ? mostrarInfoEmpresa =
                                                            false
                                                        : mostrarInfoEmpresa =
                                                            true;

                                                    if (mostrarInfoEmpresa) {
                                                      setState(() {});
                                                      temporizador = Timer(
                                                          const Duration(
                                                              seconds: 5), () {
                                                        setState(() {
                                                          mostrarInfoEmpresa =
                                                              false;
                                                        });
                                                      });
                                                    } else {
                                                      if (temporizador !=
                                                          null) {
                                                        if (temporizador!
                                                            .isActive) {
                                                          temporizador!
                                                              .cancel();
                                                        }
                                                      }
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .empresa,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                        ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                          (mostrarInfoEmpresa)
                              ? Align(
                                  alignment:
                                      const AlignmentDirectional(1.00, 1.00),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        10,
                                        10,
                                        10,
                                        (MediaQuery.of(context).padding.bottom +
                                            ((MediaQuery.of(context)
                                                        .orientation ==
                                                    Orientation.portrait)
                                                ? MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.05
                                                : MediaQuery.sizeOf(context)
                                                        .height *
                                                    0.1) +
                                            10)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                10),
                                        color: const Color.fromARGB(
                                            255, 27, 66, 88),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(10, 10, 10, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(5, 0, 10, 0),
                                              child: SizedBox(
                                                //width: MediaQuery.sizeOf(context).width / 3,
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${AppLocalizations.of(context)!.user}:',
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1),
                                                              fontSize: 12)),
                                                      Text(
                                                          "${AppLocalizations.of(context)!.empresa}:",
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1),
                                                              fontSize: 12)),
                                                      Text(
                                                          "${AppLocalizations.of(context)!.area}:",
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1),
                                                              fontSize: 12)),
                                                      Text(
                                                          "${AppLocalizations.of(context)!.planificacion}:",
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1),
                                                              fontSize: 12)),
                                                      Text(
                                                          "${AppLocalizations.of(context)!.ultimaConexion}:",
                                                          style: const TextStyle(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      1),
                                                              fontSize: 12)),
                                                    ]),
                                              ),
                                            ),
                                            SizedBox(
                                              //width: MediaQuery.sizeOf(context).width / 2,
                                              child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        widget.empLoginConfig!
                                                                .employeeName ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12)),
                                                    Text(
                                                        widget.empLoginConfig!
                                                                .getSelectedEmpresa()!
                                                                .name ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12)),
                                                    Text(
                                                        widget.empLoginConfig!
                                                                .getSelectedArea()!
                                                                .name ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12)),
                                                    Text(
                                                        widget.empLoginConfig!
                                                                .getSelectedFile()!
                                                                .name ??
                                                            "",
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
                                                            fontSize: 12)),
                                                    Text(
                                                        "${(widget.usuario_pemp!.getLastLoginDate()!.day > 9) ? widget.usuario_pemp!.getLastLoginDate()!.day : "0${widget.usuario_pemp!.getLastLoginDate()!.day}"}-${(widget.usuario_pemp!.getLastLoginDate()!.month > 9) ? widget.usuario_pemp!.getLastLoginDate()!.month : "0${widget.usuario_pemp!.getLastLoginDate()!.month}"}-${widget.usuario_pemp!.getLastLoginDate()!.year.toString()} ${(widget.usuario_pemp!.getLastLoginDate()!.hour > 9) ? widget.usuario_pemp!.getLastLoginDate()!.hour : "0${widget.usuario_pemp!.getLastLoginDate()!.hour}"}:${(widget.usuario_pemp!.getLastLoginDate()!.minute > 9) ? widget.usuario_pemp!.getLastLoginDate()!.minute : "0${widget.usuario_pemp!.getLastLoginDate()!.minute}"}:${(widget.usuario_pemp!.getLastLoginDate()!.second > 9) ? widget.usuario_pemp!.getLastLoginDate()!.second : "0${widget.usuario_pemp!.getLastLoginDate()!.second}"}",
                                                        style: const TextStyle(
                                                            color:
                                                                Color.fromRGBO(
                                                                    255,
                                                                    255,
                                                                    255,
                                                                    1),
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
                        ],
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }

  Future<bool> _checkPermission(platform) async {
    if (Platform.isIOS) return true;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 32) {
      /// use [Permissions.storage.status]
    } else {
      final statusFotos = await Permission.photos.status;
      print('Fotos : $statusFotos');
      if (!statusFotos.isGranted) {
        final resultadoFotos = await Permission.photos.request();
        if (!resultadoFotos.isGranted) {
          return false;
        }
      }
    }

    if (platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      print(status);
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      final status2 = await Permission.manageExternalStorage.status;
      print(status2);
      if (status2 != PermissionStatus.granted) {
        final result2 = await Permission.manageExternalStorage.request();
        if (result2 == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    }
    return false;
  }

  /// Funcion que muestra el dialogo para permitir al usuario seleccionar el metodo
  /// para adjuntar ficheros
  Future<void> _showChoiceDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Selecciona"),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                GestureDetector(
                  child: const Text("Galeria"),
                  onTap: () {
                    galeriaSelect = true;
                    return Navigator.pop(context, true);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: const Text("Camara"),
                  onTap: () async {
                    camaraSelect = true;
                    return Navigator.pop(context, true);
                  },
                ),
              ]),
            ),
          );
        });
  }

  Future<List<String>> _seleccionarInput(
    final FileSelectorParams params,
  ) async {
    camaraSelect = false;
    galeriaSelect = false;

    await _showChoiceDialog(context);

    if (camaraSelect) {
      final returnedImage =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (returnedImage != null) {
        //Pedir permisos de almacenamiento externo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        final File file = File(returnedImage.path);
        final Directory directory = await getApplicationDocumentsDirectory();
        final path = directory.path;
        final String fileName = returnedImage.name;
        //final String fileExtension = extension(image.path);
        File newImage = await file.copy('$path/$fileName');

        return [newImage.uri.toString()];
      }

      // Llamar a la funcion
    } else if (galeriaSelect) {
      // Comprobar permisos de lectura de almacenamiento !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

      // Llamar a la funcion que permite seleccionar el fichero
      return _androidFilePicker(params);
    }
    return [];
  }

  /// Funcion selecciona un fichero del almacenamiento del dispositivo
  Future<List<String>> _androidFilePicker(
    final FileSelectorParams params,
  ) async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      return [file.uri.toString()];
    }
    return [];
  }

  void prepararArchivoDescargado(
      String? base64StreamBinary, String? filename, String? mimetype) async {
    // Pedimos los permisos de escritura en almacenamiento externo (a partir de android 13 SDK 33 no hace falta)
    final platform = Theme.of(context).platform;
    bool value = await _checkPermission(platform);

    if (value) {
      //openAppSettings();
    } else {}

    guardarArchivoDescargado(base64StreamBinary, filename, mimetype);
  }

  void guardarArchivoDescargado(
      String? base64StreamBinary, String? filename, String? mimetype) async {
    String? base64FileContent =
        base64StreamBinaryToBase64String(base64StreamBinary);

    if (base64FileContent != null) {
      try {
        final path = await _getFilePath(filename!);
        File file = File(path);
        print(path);

        List<int> bytes = base64Decode(base64FileContent);

        var sink = file.openWrite();
        await sink.addStream(Stream.value(
          List<int>.from(bytes),
        ));
        sink.close();

        if (isiOS) {
          final cont = await file.readAsBytes();
          final res = await Share.shareXFiles([XFile(path, bytes: cont)]);
          print("=> saved status: ${res.status}");
        }

        //await OpenFile.open(path);
      } on PlatformException catch (err) {
        print(err);
      }
    }

    // Obtenemos la ruta donde se va a almacenar el archivo
  }

  String? base64StreamBinaryToBase64String(String? base64StreamBinary) {
    String? result;

    if (base64StreamBinary != null) {
      String base64content = "";
      String mimetype = "";
      List<String> base64BinaryParts = base64StreamBinary.split(';');
      if (base64BinaryParts.length > 2) {
        //si hubiera mas de 2 implica que los datos contienen ";"
      }
      if (base64BinaryParts.length == 2) {
        if (base64BinaryParts[0].startsWith('data:')) {
          mimetype =
              base64BinaryParts[0].substring(5, base64BinaryParts[0].length);
        }
        if (base64BinaryParts[1].startsWith('base64,')) {
          base64content =
              base64BinaryParts[1].substring(7, base64BinaryParts[1].length);
        }
        if (mimetype != "" && base64content != "") {
          result = base64content;
        }
      }
    }

    return result;
  }

  Future<String> androidAppVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String versionCode = packageInfo.buildSignature;
    String systemBase = "";
    String systemManufacturer = "";
    String deviceModel = "";

    // Cambio nueva version
    if (isiOS) {
      systemBase = "FLUTTER_IOS";
    } else if (isAndroid) {
      systemBase = "FLUTTER_ANDROID";
    }

    print(appName);
    print(packageName);
    print(version);
    print(buildNumber);
    print(versionCode);

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (isiOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        var device_name = iosInfo.utsname.machine;
        print('Running on ${iosInfo.utsname.machine}');
      } else {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        var device_name = androidInfo.model;
        var d2 = androidInfo.brand;
        systemManufacturer = androidInfo.manufacturer;
        //systemBase = d2;
        deviceModel = androidInfo.model;
        print('Running on ${d2}'); // e.g. "Moto G (4)"
      }
    } on Exception catch (e) {
      // TODO
    }

    try {
      print(
          "-----------------------androidAppVersionInfo-----------------------");
      Map<String, dynamic> returnInfo = {};
      returnInfo['APPLICATION_ID'] = packageName;

      returnInfo['VERSION_CODE'] = '20'; //buildNumber;//

      returnInfo['VERSION_NAME'] = '1.1.3'; //version;//'1.1.3';

      returnInfo['SYSTEM_BASE'] = systemBase;

      returnInfo['SYSTEM_MANUFACTURER'] = systemManufacturer;

      returnInfo['SYSTEM_MODEL'] = deviceModel;

      returnInfo['SYSTEM_SDK_INT'] = '34';

      returnInfo['SYSTEM_RELEASE'] = '14';

      return jsonEncode(returnInfo);
    } on PlatformException catch (err) {
      return "error";
    }
  }
}
