import 'dart:convert';

import 'package:http/http.dart';
import 'package:p_g_planning/model/parametros/parametros.dart';
import 'package:p_g_planning/model/seccion_param.dart';
//import 'package:p_g_planning/model/fichaje/seccion_param_type.dart';

class SeccionPortal {
  String name = "";
  //SeccionParamType? type;
  String type = "";
  bool enabled = false;
  bool visible = false;
  String iconFont = "";
  String iconName = "";
  String iconUnicode = "";
  String iconBadge_callAPIFunction = "";
  int iconBadge_value = -1;
  String url = "";
  List<SeccionParam> parameters = [];

  SeccionPortal(
      this.name,
      this.type,
      this.enabled,
      this.visible,
      this.iconFont,
      this.iconName,
      this.iconUnicode,
      this.iconBadge_callAPIFunction,
      this.iconBadge_value,
      this.url,
      this.parameters);

  SeccionPortal.fromBD(Map<String, dynamic> lista) {
    name = lista['name'];
    type = lista['type'];
    enabled = lista['enabled'];
    visible = lista['visible'];
    iconFont = lista['iconFont'];
    iconName = lista['iconName'];
    iconUnicode = lista['iconUnicode'];

    url = lista['url'];
    if (lista['params'] != null) {
      parameters = getListaParametrosBD(lista['params']);
    }
    if (lista['iconBadge'] != null) {
      iconBadge_callAPIFunction = lista['iconBadge'];
      //getBagdeNumber();
    }
  }

  SeccionPortal.fromJSON(Map<String, dynamic> lista) {
    name = lista['name'];
    type = lista['type'];
    enabled = lista['enabled'];
    visible = lista['visible'];
    iconFont = lista['iconFont'];
    iconName = lista['iconName'];
    iconUnicode = lista['iconUnicode'];
    if (lista['iconBadge_callAPIFunction'] != null) {
      iconBadge_callAPIFunction = lista['iconBadge_callAPIFunction'];
    }

    if (lista['iconBadge_value'] != null) {
      iconBadge_value = lista['iconBadge_value'];
    }

    url = lista['url'];
    if (lista['parameters'] != null) {
      parameters = getListaParametrosJSON(lista['parameters']);
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'enabled': enabled,
        'visible': visible,
        'iconFont': iconFont,
        'iconName': iconName,
        'iconUnicode': iconUnicode,
        'iconBadge_callAPIFunction': iconBadge_callAPIFunction,
        'iconBadge_value': iconBadge_value,
        'url': url,
        'parameters': parameters.map((c) => c.toJson()).toList()
      };

  Future<void> getBagdeNumber() async {
    if (parameters.isNotEmpty) {
      String token = parameters.where((e) => e.name == 'tk').first.value;
      var API_URL = "${Parametros.ROOT_URL}${Parametros.URL_ANDROIDPOST_BASE_API}?function=$iconBadge_callAPIFunction";
      Response request = await post(
          Uri.parse(API_URL),
          body: {'token': token});
      print('Badge: ${request.body}');
      try {
        var json = jsonDecode(request.body);
        if (json['resultado'] == 'ok') {
          iconBadge_value = json['badge_value'];
        } else {
          iconBadge_value = 0;
        }
      } catch (e) {
        print('Error: $e');
      }

    }
  }

  List<SeccionParam> getListaParametrosBD(List<dynamic> lista) {
    List<SeccionParam> listaParams = [];
    for (var element in lista) {
      listaParams.add(SeccionParam.fromBD(element));
    }
    return listaParams;
  }

  List<SeccionParam> getListaParametrosJSON(List<dynamic> lista) {
    List<SeccionParam> listaParams = [];
    for (var element in lista) {
      listaParams.add(SeccionParam.fromJSON(element));
    }
    return listaParams;
  }
}
