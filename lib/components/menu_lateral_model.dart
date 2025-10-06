import 'package:p_g_planning/model/seccion_portal.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'menu_lateral_widget.dart' show MenuLateralWidget;
import 'package:flutter/material.dart';

enum EstadoMenuLateral {
  inicial,
  accesoSinLog,
  accesoConLog
}

class MenuLateralModel extends FlutterFlowModel<MenuLateralWidget> {
  List<SeccionPortal> listaSecciones = [];

  MenuLateralModel({
    this.estadoMenuLateral = EstadoMenuLateral.inicial
  });
  MenuLateralModel.estado({required this.estadoMenuLateral});

  EstadoMenuLateral estadoMenuLateral = EstadoMenuLateral.inicial;

  /// Initialization and disposal methods.
  @override
  void initState(BuildContext context) {
    //estadoMenuLateral = EstadoMenuLateral.inicial;
  }

  @override
  void dispose() {
    
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
  /// 
  factory MenuLateralModel.fromJson(Map<String, dynamic> parsedJson) {
    //MenuLateralModel menuLateralModel = MenuLateralModel();
    String estado = parsedJson['estadoMenuLateral'] ?? "";
    print(estado);
    if (estado == "EstadoMenuLateral.inicial") {
      print("HolaModelo");
    }
    return MenuLateralModel.estado(
      estadoMenuLateral : parsedJson['estadoMenuLateral'] ?? ""
    );
  }
        
  Map<String, dynamic> toJson() {
    return {
      "estadoMenuLateral": this.estadoMenuLateral,
    };
  }
}
