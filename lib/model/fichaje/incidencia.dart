class Incidencia {
  int id = -1;
  String name = "";
  int selectableAS = -1;

  Incidencia(this.id, this.name, this.selectableAS);

  Incidencia.fromBD(Map<String, dynamic> lista) {
    id = int.parse(lista['id']);
    name = lista['name'];
    selectableAS = int.parse(lista['selectableAS']);
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name, 
    'selectableAS' : selectableAS
  };

  void setId(int id) {
    this.id = id;
  }

  int getId() {
    return id;
  }

  void setName(String name) {
    this.name = name;
  }

  String getName() {
    return name;
  }

  void setSelectableAS(int selectableAS) {
    this.selectableAS = selectableAS;
  }

  int getSelectableAS() {
    return selectableAS;
  }


}