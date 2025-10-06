import 'package:p_g_planning/model/area.dart';

class Empresa {
  int id = -1;
	String name = "";

	List<Area> listaAreas = [];

  Empresa.fromBD(Map<String, dynamic> lista) {
    id = lista["id"];
    name = lista["name"];
    listaAreas = getAreaFromJSONBD(lista['areas']);
  }

  Empresa.fromJSON(Map<String, dynamic> lista) {
    id = lista["id"];
    name = lista["name"];
    listaAreas = getAreaFromJSON(lista['listaAreas']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'listaAreas': listaAreas.map((c) => c.toJson()).toList()
      };

  List<Area> getAreaFromJSONBD(List<dynamic> lista) {
    List<Area> listaAreas = [];
    lista.forEach((element) {
      listaAreas.add(
        Area.fromBD(element)
      );
    });

    return listaAreas;
  }

  List<Area> getAreaFromJSON(List<dynamic> lista) {
    List<Area> listaAreas = [];
    lista.forEach((element) {
      listaAreas.add(
        Area.fromJSON(element)
      );
    });
    return listaAreas;
  }

  List<Area> getListaAreas() {
    return listaAreas;
  }
}