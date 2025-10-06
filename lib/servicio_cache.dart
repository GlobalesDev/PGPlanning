import 'package:p_g_planning/components/menu_lateral_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicioCache {
  static final String ENABLED  = "enabled";
  static final String REG_ID = "regId";
  static final String APP_VERSION = "appVersion";

	static final String PARAMETRO_ID_USUARIO = "idUser";
	static final String PARAMETRO_TOKEN = "token";
	static final String PARAMETRO_IS_LOGGED = "isLogged";
	static final String PARAMETRO_ID_EMPRESA = "idEmpresa";
	static final String PARAMETRO_ID_AREA = "idArea";
	static final String PARAMETRO_ID_FILE = "idFile";
	static final String PARAMETRO_ID_EMP = "idEmpleado";
	static final String PARAMETRO_LAST_ONLINE_CHECK = "lastOnlineCheck";
	static final String PARAMETRO_USER_EMAIL = "userEmail";
	static final String PARAMETRO_EMP_NAME = "empName";
	static final String PARAMETRO_ASK_FOR_NFC = "askForNFC";
	static final String PARAMETRO_ASK_FOR_UPLOAD_FILES_WITH_CAMERA = "askForCameraFileUpload";
	static final String PARAMETRO_ASK_FOR_EXTERNAL_FILESYSTEM_PERMISSION = "askForExtFileSystemPermission";
	static final String PARAMETRO_OLD_STORAGE_MIGRATED = "oldStorageMigrated";
  static final String ESTADO_MENU = "estadoMenu";

  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<Object?> getParametro(String parametro) async {
    return prefs.get(parametro);
  }

  static Future<String?> getEstadoMenu() async {
    return prefs.getString(ESTADO_MENU);
  }

  /*static Object? getEstadoMenu() {
    return prefs.get(ESTADO_MENU);
  }*/
}