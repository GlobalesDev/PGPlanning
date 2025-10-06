class Empleado {
  int id = -1;
	String name = "";
	bool signingInEmpPortal = false;
	bool showSigningsInEmpPortal = false;
	String photoURL = "";
  String langEMP = "";
	//Bitmap bitmapFoto;

  Empleado(this.id, this.name, this.signingInEmpPortal ,this.showSigningsInEmpPortal, this.photoURL, this.langEMP);

  Empleado.fromJSON(Map<String, dynamic> lista) {
    id = lista["id"];
    name = lista["name"];

    if (lista["signingInEmpPortal"] == 1) {
      signingInEmpPortal = true;
    }
    if (lista["signingInEmpPortal"] == 0) {
      signingInEmpPortal = false;
    }
    
    if (lista["showSigningsInEmpPortal"] == 1) {
      showSigningsInEmpPortal = true;
    }
    if (lista["showSigningsInEmpPortal"] == 0) {
      showSigningsInEmpPortal = false;
    }

    if (lista["photoURL"] != null) {
      photoURL = lista["photoURL"];
    }

    if (lista["langEMP"] != null) {
      langEMP = lista["langEMP"];
    }
    
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'signingInEmpPortal': signingInEmpPortal,
        'showSigningsInEmpPortal': showSigningsInEmpPortal,
        'photoURL': photoURL,
        'langEMP': langEMP
      };
}