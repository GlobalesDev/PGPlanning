import 'package:p_g_planning/model/seccion_param_type.dart';

class SeccionParam {
  SeccionParamType? type;
	String name = "";
  bool calcParam = false;
	String value = "";

  SeccionParam.fromBD(Map<String, dynamic> lista) {
    //print(lista);
    if (lista['paramType'] == "get") {
      type = SeccionParamType.GET;
    } else if (lista['paramName'] == "post") {
      type = SeccionParamType.POST;
    } else if (lista['paramName'] == "function") {
      type = SeccionParamType.FUNCTION;
    } 
    
    name = lista['paramName'];
    calcParam = (lista['calcParam'] != null) ? lista['calcParam'] : false;
    value = lista['paramValue'];
  }

  SeccionParam.fromJSON(Map<String, dynamic> lista) {
    if (lista['type'] == null) {
      type = null;
    } else if (lista['type'] == "get") {
      type = SeccionParamType.GET;
    } else if (lista['type'] == "post") {
      type = SeccionParamType.POST;
    } else if (lista['type'] == "function") {
      type = SeccionParamType.FUNCTION;
    } 

    if (lista['name'] != null) {
      name= lista['name'];
    }
    if (lista['calcParam'] != null) {
      calcParam = lista['calcParam'];
    }
    if (lista['value'] != null) {
      value= lista['value'];
    }
  }

  Map<String, dynamic> toJson() => {
    'type' : type.toString(),
    'name' : name,
    'value' : value,
    'calcParam' : calcParam
  };

  String getKeyValueString() {
		String result = "$name=";
		try {
			result += Uri.encodeComponent(value);
		} catch (e) {
			result += value;
		}

		return result;
	}
}