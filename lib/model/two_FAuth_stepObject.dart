import 'package:p_g_planning/model/seccion_param.dart';

class TwoFAuth_stepObject {
  bool twoFAuth_required = false;
	String twoFAuth_step = "";
	String twoFAuth_step_url = "";
	List<SeccionParam> twoFAuth_step_params = [];

  TwoFAuth_stepObject.fromBD(Map<String, dynamic> lista) {
    if (lista['2FAuth_required'] == false) {
      print('entro1');
      twoFAuth_required = false;
    } else if (lista['2FAuth_required'] == true) {
      print('entro2');
      twoFAuth_required = true;
    }
    twoFAuth_step = lista['2FAuth_step'];
    twoFAuth_step_url = lista['2FAuth_step_url'];

    twoFAuth_step_params = getListaParametrosBD(lista['2FAuth_step_params']);
    
  }

  TwoFAuth_stepObject.fromJSON(Map<String, dynamic> lista) {
    if (lista['twoFAuth_required'] == 'true') {
      twoFAuth_required = true;
    } else if (lista['twoFAuth_required'] == 'false') {
      twoFAuth_required = false;
    }
    twoFAuth_step = lista['twoFAuth_step'];
    twoFAuth_step_url = lista['twoFAuth_step_url'];
    twoFAuth_step_params = getListaParametrosJSON(lista['twoFAuth_step_params']);
  }

  Map<String, dynamic> toJson() => {
    'twoFAuth_required': twoFAuth_required,
    'twoFAuth_step': twoFAuth_step,
    'twoFAuth_step_url': twoFAuth_step_url,
    'twoFAuth_step_params' : twoFAuth_step_params.map((c) => c.toJson()).toList()
  };

  List<SeccionParam> getListaParametrosJSON(List<dynamic> lista) {
    List<SeccionParam> listaParams = [];
    for (var element in lista) {
      listaParams.add(SeccionParam.fromJSON(element));
    }
    return listaParams;
  }

  List<SeccionParam> getListaParametrosBD(List<dynamic> lista) {
    List<SeccionParam> listaParams = [];
    for (var element in lista) {
      listaParams.add(SeccionParam.fromBD(element));
    }
    return listaParams;
  }
}