import 'package:p_g_planning/model/empleado.dart';

class File {
  // Fecha
  // Fecha
  // Fecha
  int id = -1;
  String name = "";
  DateTime? startDate;
  DateTime? endDate;
  bool modAT = false;
  bool modGDoc = false;
  bool takePhoto =
      false; // valor booleano que indica si se debe capturar foto o no.
  int saveRandomPhoto =
      -1; //probabilidad de guardar foto, un numero entre 0 y 100.
  int mantainLastNPhoto =
      -1; //numero de fotos que se almacenan, pasado este numero se renuevan.
  bool keyboardSound =
      false; //Indica si se debe tener respuesta sonora a toques en el teclado.
  bool accessSound =
      false; //Indica si se debe tener respuesta sonora al resultado de acceso.
  bool cameraSound =
      false; //Indica si se debe tener respuesta sonora al realizar una foto.
  bool saveLocationPEmp = false;
  bool signingWithNFC =
      false; //Indica si se puede usar tecnología NFC para fichar o no.
  bool allowTZDetectPEmp =
      false; //Indica si se debe autodetectar la zona horaria en el dispositivo o usar la configurada en pgplanning

  bool langSelectableByEmployee = false;
  String langDefault = "";

  /* Valores para configurar salto de planificacion al acabar esta. */
  int nextFileID = -1;
  DateTime? nextStartDate;
  DateTime? nextEndDate;

  List<Empleado> listaEmps = [];

  File.fromBD(Map<String, dynamic> lista) {
    id = lista["id"];
    name = lista["name"];
    startDate = DateTime.parse(lista['firstShiftDate']);
    endDate = DateTime.parse(lista['lastShiftDate']);
    if (lista["modAT"] == 1) {
      modAT = true;
    }
    if (lista["modAT"] == 0) {
      modAT = false;
    }

    if (lista["modGDoc"] == 1) {
      modGDoc = true;
    }
    if (lista["modGDoc"] == 0) {
      modGDoc = false;
    }

    if (lista["takePhoto"] == 1) {
      takePhoto = true;
    }
    if (lista["takePhoto"] == 0) {
      takePhoto = false;
    }

    saveRandomPhoto = lista['saveRandomPhoto'];
    mantainLastNPhoto = lista["mantainLastNPhoto"];

    if (lista['keyboardSound'] == 1) {
      keyboardSound = true;
    }
    if (lista['keyboardSound'] == 0) {
      keyboardSound = false;
    }

    if (lista['accessSound'] == 1) {
      accessSound = true;
    }
    if (lista['accessSound'] == 0) {
      accessSound = false;
    }

    if (lista['cameraSound'] == 1) {
      cameraSound = true;
    }
    if (lista['cameraSound'] == 0) {
      cameraSound = false;
    }

    if (lista['saveLocationPEmp'] == 1) {
      saveLocationPEmp = true;
    }
    if (lista['saveLocationPEmp'] == 0) {
      saveLocationPEmp = false;
    }

    if (lista['signingWithNFC'] == 1) {
      signingWithNFC = true;
    }
    if (lista['signingWithNFC'] == 0) {
      signingWithNFC = false;
    }

    if (lista['allowTZDetectPEmp'] == 1) {
      allowTZDetectPEmp = true;
    }
    if (lista['allowTZDetectPEmp'] == 0) {
      allowTZDetectPEmp = false;
    }

    if (lista["nextFileID"] != null) {
      nextFileID = lista["nextFileID"];
    }

    if (lista['nextFirstShiftDate'] != null) {
      nextStartDate = DateTime.parse(lista['nextFirstShiftDate']);
    }

    if (lista['nextLastShiftDate'] != null) {
      nextEndDate = DateTime.parse(lista['nextLastShiftDate']);
    }

    if (lista["langSelectableByEmployee"] == 1) {
      langSelectableByEmployee = true;
    } else {
      langSelectableByEmployee = false;
    }

    langDefault = lista["langDefault"];

    listaEmps = getEmpleadoFromJSON(lista["employees"]);
  }

  File.fromJSON(Map<String, dynamic> lista) {
    id = lista["id"];
    name = lista["name"];
    startDate = DateTime.parse(lista['startDate']);
    endDate = DateTime.parse(lista['endDate']);
    if (lista["modAT"] == 1) {
      modAT = true;
    }
    if (lista["modAT"] == 0) {
      modAT = false;
    }

    if (lista["modGDoc"] == 1) {
      modGDoc = true;
    }
    if (lista["modGDoc"] == 0) {
      modGDoc = false;
    }

    if (lista["takePhoto"] == 1) {
      takePhoto = true;
    }
    if (lista["takePhoto"] == 0) {
      takePhoto = false;
    }

    saveRandomPhoto = lista['saveRandomPhoto'];
    mantainLastNPhoto = lista["mantainLastNPhoto"];

    if (lista['keyboardSound'] == 1) {
      keyboardSound = true;
    }
    if (lista['keyboardSound'] == 0) {
      keyboardSound = false;
    }

    if (lista['accessSound'] == 1) {
      accessSound = true;
    }
    if (lista['accessSound'] == 0) {
      accessSound = false;
    }

    if (lista['cameraSound'] == 1) {
      cameraSound = true;
    }
    if (lista['cameraSound'] == 0) {
      cameraSound = false;
    }

    if (lista['saveLocationPEmp'] == 1) {
      saveLocationPEmp = true;
    }
    if (lista['saveLocationPEmp'] == 0) {
      saveLocationPEmp = false;
    }

    if (lista['signingWithNFC'] == 1) {
      signingWithNFC = true;
    }
    if (lista['signingWithNFC'] == 0) {
      signingWithNFC = false;
    }

    if (lista['allowTZDetectPEmp'] == 1) {
      allowTZDetectPEmp = true;
    }
    if (lista['allowTZDetectPEmp'] == 0) {
      allowTZDetectPEmp = false;
    }

    if (lista["nextFileID"] != null) {
      nextFileID = lista["nextFileID"];
    }

    if (lista['nextStartDate'] != null) {
      nextStartDate = DateTime.parse(lista['nextStartDate']);
    }

    if (lista['nextEndDate'] != null) {
      nextEndDate = DateTime.parse(lista['nextEndDate']);
    }

    if (lista['nextLastShiftDate'] != null) {
      nextEndDate = DateTime.parse(lista['nextLastShiftDate']);
    }
    
    if (lista["langSelectableByEmployee"] != null) {
      langSelectableByEmployee = lista['langSelectableByEmployee'];
    } else {
      langSelectableByEmployee = false;
    }

    if (lista["langDefault"] != null) {
      langDefault = lista["langDefault"];
    }
    

    listaEmps = getEmpleadoFromJSON(lista["listaEmps"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map = {
      'id': id,
      'name': name,
      'startDate':
          "${startDate!.year}-${(startDate!.month < 10) ? "0${startDate!.month}" : startDate!.month}-${(startDate!.day < 10) ? "0${startDate!.day}" : startDate!.day}",
      'endDate':
          "${endDate!.year}-${(endDate!.month < 10) ? "0${endDate!.month}" : endDate!.month}-${(endDate!.day < 10) ? "0${endDate!.day}" : endDate!.day}",
      'modAT': modAT,
      'modGDoc': modGDoc,
      'saveRandomPhoto': saveRandomPhoto,
      'mantainLastNPhoto': mantainLastNPhoto,
      'keyboardSound': keyboardSound,
      'accessSound': accessSound,
      'cameraSound': cameraSound,
      'saveLocationPEmp': saveLocationPEmp,
      'signingWithNFC': signingWithNFC,
      'allowTZDetectPEmp': allowTZDetectPEmp,
      'nextFileID': nextFileID,
      'listaEmps': listaEmps.map((c) => c.toJson()).toList(),
      'langSelectableByEmployee': langSelectableByEmployee,
      'langDefault': langDefault

    };

    if (nextStartDate != null) {
      map["nextStartDate"] =
          "${nextStartDate!.year}-${(nextStartDate!.month < 10) ? "0${nextStartDate!.month}" : nextStartDate!.month}-${(nextStartDate!.day < 10) ? "0${nextStartDate!.day}" : nextStartDate!.day}";
    }

    if (nextEndDate != null) {
      map["nextEndDate"] =
          "${nextEndDate!.year}-${(nextEndDate!.month < 10) ? "0${nextEndDate!.month}" : nextEndDate!.month}-${(nextEndDate!.day < 10) ? "0${nextEndDate!.day}" : nextEndDate!.day}";
    }

    return map;
  }

  List<Empleado> getEmpleadoFromJSON(List<dynamic> lista) {
    List<Empleado> listaEmpleado = [];

    lista.forEach((element) {
      listaEmpleado.add(Empleado.fromJSON(element));
    });

    return listaEmpleado;
  }

  List<Empleado> getListaEmpleados() {
    return listaEmps;
  }

  bool isAllowTZDetectPEmp() {
    return allowTZDetectPEmp;
  }

  void setSaveLocationPEmp(bool save) {
    saveLocationPEmp = save;
  }

  bool getSaveLocationPEmp() {
    return saveLocationPEmp;
  }
}
