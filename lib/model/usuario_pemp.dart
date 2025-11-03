import 'dart:convert';

import 'package:p_g_planning/model/empresa.dart';
import 'package:p_g_planning/model/two_FAuth_stepObject.dart';

class Usuario_pemp {
  //static final DateTime sdf_time = DateTime();
	//static final DateTime sdf_time_screen = DateTime();

	int code = -1;
	String email = "";
	String token = "";
	bool twoFAuth_configured = false;
	TwoFAuth_stepObject? twoFAuth_stepConfig;
	DateTime? lastLoginDate;
	List<Empresa> listaEmpresas = [];

  Usuario_pemp(this.code, this.email, this.token, this.twoFAuth_configured, this.twoFAuth_stepConfig, this.lastLoginDate, this.listaEmpresas);

  Usuario_pemp.fromJSON(Map<String, dynamic> lista) {
    code = lista["code"];
    email = lista["email"];
    token = lista['token'];

    if (lista['twoFAuth_configured'] == true) {
      twoFAuth_configured = true;
    }
    if (lista['twoFAuth_configured'] == false) {
      twoFAuth_configured = false;
    }
    if (twoFAuth_configured) {
      twoFAuth_stepConfig = TwoFAuth_stepObject.fromJSON(lista['twoFAuth_stepConfig']);
    } else {
      twoFAuth_stepConfig = null;
    }
    lastLoginDate = DateTime.parse(lista['lastLoginDate']);

    listaEmpresas = getEmpresasFromJSON(lista['listaEmpresas']);
  }

  Usuario_pemp.fromBD(Map<String, dynamic> lista) {
    code = lista["code"];
    email = lista["email"];
    token = lista['loginToken'];

    print(lista['2FAuth_configured'].runtimeType);

    if (lista['2FAuth_configured'] == "true") {
      twoFAuth_configured = true;
    }
    if (lista['2FAuth_configured'] == "false") {
      twoFAuth_configured = false;
    }
    if (lista['2FAuth_stepConfig'] != null) {
      twoFAuth_stepConfig = TwoFAuth_stepObject.fromBD(lista['2FAuth_stepConfig']);
    } else {
      twoFAuth_stepConfig = null;
    }
    lastLoginDate = DateTime.parse(lista['lastLoginDate']);

    listaEmpresas = getEmpresasFromJSONBD(lista['companys']);
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'email': email,
        'token': token,
        'twoFAuth_configured': twoFAuth_configured,
        'twoFAuth_stepConfig': (twoFAuth_stepConfig == null) ? null : twoFAuth_stepConfig!.toJson(),//.toString(),//twoFAuth_stepConfig?.twoFAuth_required,
        'lastLoginDate': lastLoginDate.toString(),
        'listaEmpresas': listaEmpresas.map((c) => c.toJson()).toList()
        
      };

  bool isTwoFAuth_required() {
    print(twoFAuth_stepConfig!.toJson().toString());
    if (twoFAuth_stepConfig != null) {
      return (twoFAuth_stepConfig!.twoFAuth_required);
    } else {
      return false;
    }
    //return (twoFAuth_stepConfig != null);
  }

  bool isTwoFAuth_configured() {
    print("twoFAuth_configured: $twoFAuth_configured");
    return twoFAuth_configured;
  }

  /// Funcion que comprueba si el usuario dispone de tan solo una empresa,
  /// un area, una planificacion y un empleado disponibles
  bool necesitaConfiguracion() {
    if (listaEmpresas.length == 1) {
      var empresa = listaEmpresas.first;
      if (empresa.getListaAreas().length == 1) {
        var area = empresa.getListaAreas().first;
        if (area.getListaFiles().length == 1) {
          var file = area.getListaFiles().first;
          if (file.getListaEmpleados().length == 1) {
            return false;
          } else {
            return true;
          }
        } else {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  String? getUsuarioUnico() {
    if (listaEmpresas.length == 1) {
      var empresa = listaEmpresas.first;
      if (empresa.getListaAreas().length == 1) {
        var area = empresa.getListaAreas().first;
        if (area.getListaFiles().length == 1) {
          var file = area.getListaFiles().first;
          if (file.getListaEmpleados().length == 1) {
            return file.getListaEmpleados().first.name;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  void setLastLoginDate(DateTime? t) {
    lastLoginDate = t;
  }

  DateTime? getLastLoginDate() {
    return lastLoginDate;
  }

  List<Empresa> getEmpresasFromJSON(List<dynamic> lista) {
    List<Empresa> listaEmpresas = [];
    for (var element in lista) {
      print(element);
      listaEmpresas.add(Empresa.fromJSON(element));
    }
    return listaEmpresas;
  }

  List<Empresa> getEmpresasFromJSONBD(List<dynamic> lista) {
    List<Empresa> listaEmpresas = [];
    lista.forEach((element) {
      print(element);
      listaEmpresas.add(Empresa.fromBD(element));
    });
    return listaEmpresas;
  }

  List<Empresa> getListaEmpresas() {
    return listaEmpresas;
  }
}