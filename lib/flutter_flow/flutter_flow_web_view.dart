import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart' hide NavigationDecision;
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'flutter_flow_util.dart';

class FlutterFlowWebView extends StatefulWidget {
  const FlutterFlowWebView({
    Key? key,
    required this.content,
    this.width,
    this.height,
    this.bypass = false,
    this.horizontalScroll = false,
    this.verticalScroll = false,
    this.html = false,
  }) : super(key: key);

  final String content;
  final double? height;
  final double? width;
  final bool bypass;
  final bool horizontalScroll;
  final bool verticalScroll;
  final bool html;
  @override
  _FlutterFlowWebViewState createState() => _FlutterFlowWebViewState();
}

class _FlutterFlowWebViewState extends State<FlutterFlowWebView> {
  bool camaraSelect = false;
  bool galeriaSelect = false;
  List<CameraDescription> _cameras = [];
  CameraController? _cameraController;

  @override
  void initState() {
    //initializeCamera();
    super.initState();
  }

  initializeCamera() async {
    if (mounted) setState(() {});

    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high);

    await _cameraController!.initialize();

    if (_cameraController!.value.hasError) {
    } else {
      //_cameraController!.
    }
  }

  @override
  Widget build(BuildContext context) => WebViewX(
        key: webviewKey,
        width: widget.width ?? MediaQuery.sizeOf(context).width,
        height: widget.height ?? MediaQuery.sizeOf(context).height,
        ignoreAllGestures: false,
        initialContent: widget.content,
        initialMediaPlaybackPolicy:
            AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
        initialSourceType: widget.html
            ? SourceType.html
            : widget.bypass
                ? SourceType.urlBypass
                : SourceType.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) async {
          controller.callJsMethod("webview_gdoc_interface", []).then((value) {
            print('Webview: $value');
          });

          print(controller.getContent().toString());
          if (controller.connector is WebViewController && isAndroid) {
            final androidController =
                controller.connector.platform as AndroidWebViewController;
            await androidController.setOnShowFileSelector(_seleccionarInput);
          }
        },
        navigationDelegate: (request) async {
          print(request.toString());
          
          if (isAndroid) {
            if (request.content.source
                .startsWith('https://api.whatsapp.com/send?phone')) {
              String url = request.content.source;

              await launchUrl(
                Uri.parse(url),
                mode: LaunchMode.externalApplication,
              );
              return NavigationDecision.prevent;
            }
          }
          return NavigationDecision.navigate;
        },
        webSpecificParams: const WebSpecificParams(
          webAllowFullscreenContent: true,
        ),
        mobileSpecificParams: MobileSpecificParams(
          debuggingEnabled: false,
          gestureNavigationEnabled: true,
          mobileGestureRecognizers: {
            if (widget.verticalScroll)
              Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
              ),
            if (widget.horizontalScroll)
              Factory<HorizontalDragGestureRecognizer>(
                () => HorizontalDragGestureRecognizer(),
              ),
          },
          androidEnableHybridComposition: true,
        ),
      );

  Key get webviewKey => Key(
        [
          widget.content,
          widget.width,
          widget.height,
          widget.bypass,
          widget.horizontalScroll,
          widget.verticalScroll,
          widget.html,
        ].map((s) => s?.toString() ?? '').join(),
      );

  Future<void> _showChoiceDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Selecciona"),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                GestureDetector(
                  child: Text("Galeria"),
                  onTap: () {
                    galeriaSelect = true;
                    return Navigator.pop(context, true);
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Text("Camara"),
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

      // Llamar a la funcion
      return _androidFilePicker(params);
    }
    return [];
  }

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
}
