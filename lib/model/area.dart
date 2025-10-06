import 'package:p_g_planning/model/file.dart';

class Area {
  int id = 0;
  String name = "";
  bool modAT = false;
  bool modGDoc = false;
  List<File> listaFiles =  [];

  Area(this.id, this.name, this.modAT, this.modGDoc, this.listaFiles);

  Area.fromBD(Map<String, dynamic> lista) {
    id = lista["id"];
    name = lista["name"];
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

    listaFiles = getFileFromJSONBD(lista["files"]);
  }

  Area.fromJSON(Map<String, dynamic> lista) {
    id = lista["id"];
    name = lista["name"];
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

    listaFiles = getFileFromJSON(lista["listaFiles"]);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'modAT': modAT,
        'modGDoc': modGDoc,
        'listaFiles': listaFiles.map((c) => c.toJson()).toList()
      };

  List<File> getFileFromJSON(List<dynamic> lista) {
    List<File> listaFiles = [];
    for (var element in lista) {
      listaFiles.add(
        File.fromJSON(element)
      );
    }

    return listaFiles;
  }

  List<File> getFileFromJSONBD(List<dynamic> lista) {
    List<File> listaFiles = [];
    for (var element in lista) {
      listaFiles.add(
        File.fromBD(element)
      );
    }

    return listaFiles;
  }

  List<File> getListaFiles() {
    return listaFiles;
  }

}