import 'package:p_g_planning/model/area.dart';
import 'package:p_g_planning/model/empleado.dart';
import 'package:p_g_planning/model/empresa.dart';
import 'package:p_g_planning/model/file.dart';
import 'package:p_g_planning/model/usuario_pemp.dart';

class EmpLoginConfig {
  final int DELAY_BETWEEN_ONLINE_CHECKS = 30 * 60 * 1000; //30 minutos
  final int DEFAULT_SELECTED_ID = -99;

  //Date lastOnlineCheck = null;

  int? usuarioID;
  String? userEmail;
  String? employeeName;

  String? token;
  bool? isLogged;

  int? selectedEmpresaID;
  int? selectedAreaID;
  int? selectedFileID;
  int? selectedEmpID;

  Empresa? selectedEmpresa;
  Area? selectedArea;
  File? selectedFile;
  Empleado? selectedEmp;

  List<Empresa>? empresas;

  EmpLoginConfig(this.usuarioID, this.userEmail, this.token, this.isLogged);

  EmpLoginConfig.fromJSON(Map<String, dynamic> lista) {
    usuarioID = lista["usuarioID"];
    userEmail = lista["userEmail"];
    employeeName = lista["employeeName"];
    token = lista['token'];
    isLogged = lista['isLogged'];
    selectedEmpresaID = lista['selectedEmpresaID'];
    selectedAreaID = lista['selectedAreaID'];
    selectedFileID = lista['selectedFileID'];
    selectedEmpID = lista['selectedEmpID'];
    if (lista['selectedEmpresa'] == null) {
      selectedEmpresa = null;
    } else {
      selectedEmpresa = Empresa.fromJSON(lista['selectedEmpresa']);
    }
    
    if (lista['selectedArea'] == null) {
      selectedArea = null;
    } else {
      selectedArea = Area.fromJSON(lista['selectedArea']);
    }
    
    if (lista['selectedFile'] == null) {
      selectedFile = null;
    } else {
      selectedFile = File.fromJSON(lista['selectedFile']);
    }
    
    if (lista['selectedEmp'] == null) {
      selectedEmp = null;
    } else {
      selectedEmp = Empleado.fromJSON(lista['selectedEmp']);
    }
    
    //empresas = lista['empresas'];
  }

  Map<String, dynamic> toJson() => {
        'usuarioID': usuarioID,
        'userEmail': userEmail,
        'employeeName': employeeName,
        'token': token,
        'isLogged': isLogged,
        'selectedEmpresaID': selectedEmpresaID,
        'selectedAreaID': selectedAreaID,
        'selectedFileID': selectedFileID,
        'selectedEmpID': selectedEmpID,
        'selectedEmpresa': selectedEmpresa,
        'selectedArea': selectedArea,
        'selectedFile': selectedFile,
        'selectedEmp': selectedEmp,
        //'empresas' : empresas
      };

  bool estaTotalmenteConfigurado() {
    if (usuarioID != null &&
        userEmail != null &&
        employeeName != null &&
        token != null &&
        isLogged != null &&
        selectedEmpresaID != null &&
        selectedAreaID != null &&
        selectedFileID != null &&
        selectedEmpID != null &&
        selectedEmpresa != null &&
        selectedArea != null &&
        selectedFile != null &&
        selectedEmp != null) {
      return true;
    } else {
      return false;
    }
  }

  bool setConfiguracionUnica(Usuario_pemp usuario) {
    if (usuario.listaEmpresas.length == 1) {
      var empresa = usuario.listaEmpresas.first;
      if (empresa.getListaAreas().length == 1) {
        var area = empresa.getListaAreas().first;
        if (area.getListaFiles().length == 1) {
          var file = area.getListaFiles().first;
          if (file.getListaEmpleados().length == 1) {
            var emp = file.getListaEmpleados().first;

            selectedEmpresa = empresa;
            selectedEmpresaID = empresa.id;

            selectedArea = area;
            selectedAreaID = area.id;

            selectedFile = file;
            selectedFileID = file.id;

            selectedEmp = emp;
            selectedEmpID = emp.id;

            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  int? getUsuarioID() {
    return usuarioID;
  }

  void setUsuarioID(int? id) {
    usuarioID = id;
  }

  String? getUserEmail() {
    return userEmail;
  }

  void setUserEmail(String? email) {
    userEmail = email;
  }

  String? getEmployeeName() {
    return employeeName;
  }

  void setEmployeeName(String? name) {
    employeeName = name;
  }

  String? getToken() {
    return token;
  }

  void setToken(String? tok) {
    token = tok;
  }

  bool? getIsLogged() {
    return isLogged;
  }

  void setIsLogged(bool? log) {
    isLogged = log;
  }

  int? getSelectedEmpresaID() {
    return selectedEmpresaID;
  }

  void setSelectedEmpresaID(int? id) {
    selectedEmpresaID = id;
  }

  int? getSelectedAreaID() {
    return selectedAreaID;
  }

  void setSelectedAreaID(int? id) {
    selectedAreaID = id;
  }

  int? getSelectedFileID() {
    return selectedFileID;
  }

  void setSelectedFileID(int? id) {
    selectedFileID = id;
  }

  int? getSelectedEmpleadoID() {
    return selectedEmpID;
  }

  void setSelectedEmpleadoID(int? id) {
    selectedEmpID = id;
  }

  Empresa? getSelectedEmpresa() {
    return selectedEmpresa;
  }

  void setSelectedEmpresa(Empresa? empresa) {
    selectedEmpresa = empresa;
  }

  Area? getSelectedArea() {
    return selectedArea;
  }

  void setSelectedArea(Area? area) {
    selectedArea = area;
  }

  File? getSelectedFile() {
    return selectedFile;
  }

  void setSelectedFile(File? file) {
    selectedFile = file;
  }

  Empleado? getSelectedEmpleado() {
    return selectedEmp;
  }

  void setSelectedEmpleado(Empleado? emp) {
    selectedEmp = emp;
  }
}
