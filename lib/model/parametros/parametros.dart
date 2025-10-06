/**
 * Creado por Javier el 01/06/2016 para Globales
 */
//Clase que contiene los diferentes parámetros que se usan en la aplicación
class Parametros {

	static final int MAX_VOLUME = 100;

  static final int URL_QUERY_MAX_RETRIES = 0;
  static final int URL_QUERY_TIMEOUT = 20000;
  static final int URL_QUERY_CONNECTION_TIMEOUT = 20000;

  static final int SECTION_MAIN_FRAGMENT = 0;
	static final int SECTION_LOGIN = 1;
  static final int SECTION_CONFIG = 2;
  static final int SECTION_HOME = 3;
	static final int SECTION_WEBVIEW = 4;
	static final int SECTION_FICHAJE = 5;
	static final int SECTION_FRAGMENT_DATA_SYNC  = -22;
	static final int SECTION_FRAGMENT_CONN_ERROR  = -33;
	static final int SECTION_DONT_CHANGE = -50;
  static final int SECTION_NULL = -99;

	//TODO: CONFIF_RELEASE No se te olvide ADECUAR esto
    //Constantes Conexion
	//*********************************************************** //
	//**    CONSTANTES CONEXION PARA ** !! PRODUCCION !! **    ** //
	//*********************************************************** //
	static final int ROOT_URL_USES_SSL = 1;
	static final int ROOT_URL_SSL_CHECK = 1; //Si hacemos validacion del certificado y del nombre del dominio
	static final String ROOT_URL_SSL_CNAME = "www.pgplanning.es"; //El certificado será para este cname
	static final String ROOT_URL = "https://pgtime.pgplanning.es";
	static final String ROOR_URL_DEBUG_HOSTNAME = "portalempleado.pgplanning.es"; //Esta variable indica un hostname alternativo a los esperados para poder abrir los enlaces en webview en lugar de en navegador externo. En produccion NO usar
	static final bool MODO_DEBUG = false; //solo activar para que en caso de error genere un logcat en caso de excepcion en lugar de abrir la app
	static final String RECOVER_PASS_URL = "https://portalempleado.pgplanning.es/index.php?forgot=1";
	//*********************************************************** //
	//**  FIN CONSTANTES CONEXION PARA ** !! PRODUCCION !! **  ** //
	//*********************************************************** //

	//*********************************************************** //
	//**     CONSTANTES CONEXION PARA PRUEBAS EN LOCALHOST     ** //
	//*********************************************************** //
	//Comunes (activar todas):

    //public final static int ROOT_URL_USES_SSL = 0;
	//public final static int ROOT_URL_SSL_CHECK = 0; //NO hacemos validacion del certificado y del nombre del dominio
	//public final static String ROOT_URL_SSL_CNAME = "www.pgplanning.es"; //El certificado será para este cname
	//public final static boolean MODO_DEBUG = true; //solo activar para que en caso de error genere un logcat en caso de excepcion en lugar de abrir la app

	//Particulares (activar en función de necesidadades):

	//Para PC Globales de Javi:
	//public final static String ROOT_URL = "http://192.168.49.62/PGTime";
	//public final static String ROOR_URL_DEBUG_HOSTNAME = "192.168.49.62"; //Esta variable indica un hostname alternativo a los esperados para poder abrir los enlaces en webview en lugar de en navegador externo. En produccion NO usar
	//public final static String RECOVER_PASS_URL = "http://192.168.49.62/pgplanning-portalempleado/index.php?forgot=1";

	//Para PC Javi:
	//public final static String ROOT_URL = "http://192.168.3.3/PGTime";
	//public final static String ROOR_URL_DEBUG_HOSTNAME = "192.168.3.3"; //Esta variable indica un hostname alternativo a los esperados para poder abrir los enlaces en webview en lugar de en navegador externo. En produccion NO usar
	//public final static String RECOVER_PASS_URL = "http://192.168.3.3/pgplanning-portalempleado/index.php?forgot=1";

	//Para PC Luis:
	//public final static String ROOT_URL = "http://192.168.0.27/pgplanning-pgtime"; //Luis
	//public final static String ROOR_URL_DEBUG_HOSTNAME = "192.168.0.27"; //Esta variable indica un hostname alternativo a los esperados para poder abrir los enlaces en webview en lugar de en navegador externo. En produccion NO usar
	//*********************************************************** //
	//**   FIN CONSTANTES CONEXION PARA PRUEBAS EN LOCALHOST   ** //
	//*********************************************************** //

	//*********************************************************** //
	//**   CONSTANTES CONEXION PARA PRUEBAS EN 192.168.69.10   ** //
	//*********************************************************** //
	//public final static int ROOT_URL_USES_SSL = 1; //Pruebas en el 10
	//public final static int ROOT_URL_SSL_CHECK = 0; //NO hacemos validacion del certificado y del nombre del dominio
	//public final static String ROOT_URL_SSL_CNAME = "192.168.69.10"; //El certificado será para este cname
	//public final static String ROOT_URL = "https://192.168.69.10/pgtime.pgplanning.es"; //Pruebas en el 10
	//public final static String ROOR_URL_DEBUG_HOSTNAME = "192.168.69.10"; //Esta variable indica un hostname alternativo a los esperados para poder abrir los enlaces en webview en lugar de en navegador externo. En produccion NO usar
	//public final static String RECOVER_PASS_URL = "https://192.168.69.10/portalempleado.pgplanning.es/index.php?forgot=1";
	//*********************************************************** //
	//** FIN CONSTANTES CONEXION PARA PRUEBAS EN 192.168.69.10 ** //
	//*********************************************************** //

	/// Nombre del script de entrada al API.
	static final String URL_ANDROIDPOST_BASE_API = "/androidPost_v5.php"; //v3 (og)

	/// Función que comprueba el login de un usuario empleado en el portal de empleado de PGPlanning
	///
	/// <b>Parametros de entrada:</b>
	///  - emailEmp --> String, email registrado como empleado de alguna empresa de PGPlanning
	///  - passEmp --> String, contraseña del usuario de PGPlanning codificada en md5 (prefixed)
	///  - device_name --> String con una cadena identificativa del dispositivo logeado;
	///
	///  <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str": 'valor', --> Un string con un codigo identificativo del error si resultado=error. Un mensaje si es exception, blanco si ok.
	/// 		'usuario': {} --> Objeto con los datos del empleado logeado. Ver llamada api "obtenerDatosEmpleado" para el detalle.
	/// 		'2FAuthData': {		--> Objeto necesario para validar la autenticacion en 2 pasos (Solo si resultado=error y result_str=2FAuth_REQUIRED)
	/// 		    '2FAuth_required': true|false, 			//si es necesaria o no la autenticacion en dos pasos
	/// 			'2FAuth_step': "2FA_validate_msg", 		//Step a realizar (por homologar con version web)
	/// 			'2FAuth_usertype': "employee", 			//Tipo de validacion, autenticacion de empleado
	/// 			'2FAuth_userid': $emp['id'], 			//code del empleado
	/// 			'2FAuth_uid': md5String,				//Cadena de validacion a pasar de vuelta asegurando que no se modifican las variables 2FAuth_step 2FAuth_usertype y 2FAuth_userid
	/// 			'2FAuth_method': 'gapp|mail',			//Tipo de login a validar si es un codio de gapp o se envió el codigo por email
	/// 			'2FAuth_methodCRC': md5String,			//Cadena de validacion a pasar de vuelta asegurando que no se modifica la variable 2FAuth_method
	/// 			'2FAuth_iteration': sharedKeyIteration	//Valor de iteración de la sharedKey
	/// 		}
	/// 	}
	///
	///  <b>Posibles códigos de result_str cuando resultado = error:</b>
	/// 	 - USER_OR_PASS_NOT_VALID				--> Usuario o contraseña no validos, o varios logins devueltos para el mismo usuario.
	/// 	 - INCORRECT_PARAMETERS					--> Alguno de los parametros de entrada es incorrecto o no se ha especificado.
	/// 	 - ERROR_REGISTERING_USER				--> Error al registrar el empleado y dispositivo como login de app
	///   - USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND --> Error al recuperar informacion del empleado en base a su token recien generado
	///	 - EXPIRED_PASSWORD						--> Si el empleado tiene la contraseña caducada y debe cambiarla
	///	 - 2FAuth_REQUIRED						--> Si el empleado requiere validar la autenticación en 2 pasos
  //static final String URL_ANDROIDPOST_LOGIN_CHECK = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=checkLoginEmp";
  static final String URL_ANDROIDPOST_LOGIN_CHECK = "$ROOT_URL$URL_ANDROIDPOST_BASE_API?function=checkLoginEmp";

	/// Función que comprueba las credenciales de un empleado que ya está logeado en la aplicacion.
	///
	/// <b>Parametros de entrada:</b>
	///  - emailEmp --> String, email registrado como empleado de alguna empresa de PGPlanning
	///  - passEmp --> String, contraseña del usuario de PGPlanning codificada en md5 (prefixed)
	///  - token --> String con el token de la session que ya está abierta
	///
	///  <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str": 'valor', --> Un string con un codigo identificativo del error si resultado=error. Un mensaje si es exception, blanco si ok.
	/// 		'usuario': {} --> Objeto con los datos del empleado logeado. Ver llamada api "obtenerDatosEmpleado" para el detalle.
	/// 	}
	///
	///  <b>Posibles códigos de result_str cuando resultado = error:</b>
	///	 - TOKEN_USER_NOT_MATCH		   			 --> El token no existe o no encaja con el usuario logeado.
	///   - UNLOCK_PASS_NOT_MATCH		   		 --> La contraseña o no encaja con la del usuario de la session.
	///   - EXPIRED_PASSWORD			   			 --> Si el empleado tiene la contraseña caducada y debe cambiarla
	///   - USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND  --> Error al recuperar informacion del empleado en base a su token
	///   - INCORRECT_PARAMETERS					 --> Alguno de los parametros de entrada es incorrecto o no se ha especificado.
	static final String URL_ANDROIDPOST_LOGED_EMP_CHECK = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=checkAlreadyLoggedEmp";

	/// Función que realiza llamada para anotar el desbloqueo mediante biometria de una sesion de portal dado que un
	/// usuario con la sesion bloqueada nunca mas enviará una notificacion de inicio de sesión mientras mantenga
	/// la sesion bloqueada. Asi este desbloqueo contará como un inicio de sesion a todos los efectos y el sistema
	/// podrá anotar el log de acceso.
	///
	/// <b>Parametros de entrada:</b>
	///  - emailEmp --> String, email registrado como empleado de alguna empresa de PGPlanning
	///  - token --> String con el token de la session que ya está abierta
	///
	///  <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str": 'valor', --> Un string con un codigo identificativo del error si resultado=error. Un mensaje si es exception, blanco si ok.
	/// 		'usuario': {} --> Objeto con los datos del empleado logeado. Ver llamada api "obtenerDatosEmpleado" para el detalle.
	/// 	}
	///
	///  <b>Posibles códigos de result_str cuando resultado = error:</b>
	///	 - TOKEN_USER_NOT_MATCH		   			 --> El token no existe o no encaja con el usuario logeado.
	///   - EXPIRED_PASSWORD			   			 --> Si el empleado tiene la contraseña caducada y debe cambiarla
	///   - NEED_UNLOCK_WITH_PASSWORD		     --> Si el usuario debe desbloquear usando la contraseña porque hace mucho tiempo que no desbloquea la sesion con contraseña
	///   - USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND  --> Error al recuperar informacion del empleado en base a su token
	///   - INCORRECT_PARAMETERS					 --> Alguno de los parametros de entrada es incorrecto o no se ha especificado.
	static final String URL_ANDROIDPOST_LOGED_EMP_ANNOTATE_BIOMETRIC_UNLOCK = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=loggedEmpAnnotateBiometricUnlock";

	/// Funcion que modifica la contraseña del empleado.
	///
	/// <b>Parametros de entrada:</b>
	///  - emailUser   			--> email de empleado
	///  - oldPassword    		--> pass del empleado ya codificada en md5 (prefixed)
	///  - plainNewPassword    	--> nueva contraseña del empleado en plano
	///  - plainNewPassword2		--> repeticion de nueva contraseña del empleado en plano para evitar errores tipograficos.
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error:</b>
	/// 	- WEAK_PASSWORD_STRENGTH	--> La nueva contraseña no cumple los requisitos de complejidad.
	/// 	- ERROR_SAVING_TRY_AGAIN	--> Ha ocurrido un error al intentar guardar la nueva contraseña.
	/// 	- PASSWORD_RECENTLY_USED	--> La nueva contraseña no cumple el requisito de historico de contraseñas
	/// 	- NEW_PASSWORDS_NOT_MATCH	--> La nueva contraseña y su repeticion no coinciden
	/// 	- USER_OR_PASS_NOT_VALID	--> La actual contraseña no es correcta
	///  - INCORRECT_PARAMETERS		--> si falta algun parametro.
	///
	///  <b>Posible valor para resultado expception:</b>
	/// 	Mensaje con detalle de excepción si ocurreo algún error al ejecutar consulta del usuario
	static final String URL_ANDROID_POST_CHANGE_EMP_PWD = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=changeEmpPassword";

  static final String URL_POST_CHANGE_LANG = ROOT_URL + URL_ANDROIDPOST_BASE_API + '?function=configurarLanguageEmpleado';

	/// Funcion que genera/cambia la clave de descarga del empleado.
	///
	/// <b>Parametros de entrada:</b>
	///  - emailUser   				--> email de empleado
	///  - userPassword    			--> pass del empleado ya codificada en md5 (prefixed)
	///  - userPassword2    			--> pass del empleado ya codificada en sha256 (prefixed)
	///  - plainDownloadPassword    	--> clave de descarga para el empleado en plano
	///  - plainDownloadPassword2	--> repeticion de nueva clave de descarga del empleado en plano para evitar errores tipograficos.
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error:</b>
	/// 	- WEAK_PASSWORD_STRENGTH	--> La nueva clave de descarga no cumple los requisitos de complejidad.
	/// 	- ERROR_SAVING_TRY_AGAIN	--> Ha ocurrido un error al guardar la clave de descarga
	/// 	- NEW_PASSWORDS_NOT_MATCH	--> La clave y su repeticion no coinciden
	/// 	- USER_OR_PASS_NOT_VALID	--> El usuario y contraseña no es correcta
	///  - INCORRECT_PARAMETERS		--> si falta algun parametro.
	///
	///  <b>Posible valor para resultado expception:</b>
	/// 	Mensaje con detalle de excepción si ocurreo algún error al ejecutar consulta del usuario
	static final String URL_ANDROID_POST_GENERATE_DOWNLOAD_PWD = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=generateDownloadPassword";

	/// Funcion que modifica la contraseña del empleado.
	///
	/// <b>Parametros de entrada:</b>
	///  - emailEmp   			--> email de empleado
	///  - oldPassword    		--> pass del empleado ya codificada en md5 (prefixed)
	///  - plainNewPassword    	--> nueva contraseña del empleado en plano
	///  - plainNewPassword2		--> repeticion de nueva contraseña del empleado en plano para evitar errores tipograficos.
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si no ha expirado.
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error:</b>
	/// 	- EXPIRED_PASSWORD	--> La contraseña ha expirado.
	///  - INCORRECT_PARAMETERS		--> si falta algun parametro.
	///
	///  <b>Posible valor para resultado expception:</b>
	/// 	Mensaje con detalle de excepción si ocurreo algún error al ejecutar consulta del usuario
	static final String URL_ANDROID_POST_CHECK_EXPIRED_CREDENTIAL = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=checkExpiredCredentialsEmp";

	/// Funcion que graba la configuración de acceso seleccionada por el empleado
	///
	/// <b>Parametros de entrada:</b>
	///  - token          --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	///  - idEmpresa      --> id de la empresa seleccionada. (104)
	///  - idArea         --> id del area de la empresa seleccionada. (211)
	///  - idFile         --> id del file del area y empresa seleccionada. (342)
	///  - idEmpleadoPlan --> id del empleado del plan seleccionado
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str": 'valor' --> Un string con un codigo identificativo del error si resultado=error o exception, blanco si ok.
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error o exception:</b>
	///  - error: INCORRECT_PARAMETERS               --> si falta algun parametro.
	///  - error: NO_ROW_UPDATED                     --> si la consulta no actualiza nada.
	///  - exception: ERROR_UPDATING_FIXED_STATION   --> si ocurre un error al grabar los cambios.
	static final String URL_ANDROIDPOST_CONFIG_EMPLOYEE = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=configureEmployee";

	/// Función que obtiene la configuración de un login de empleado.
	///
	/// <b>Parametros de entrada:</b>
	///  - token          --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 		'config': {
	/// 		    'empleadoCode': valor, --> integer con identificador del login del empleado (379)
	/// 		    'token':, 'valor' --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	/// 		    'empresaID': valor, --> id de la empresa seleccionada. (104)
	/// 		    'areaID': valor, --> id del area de la empresa seleccionada. (211)
	/// 		    'fileID': valor, --> id del file del area y empresa seleccionada. (342)
	/// 		    'empleadoPlanID': 'valor', --> id del empleado de la planificacion seleccionada. (25)
	/// 		}
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error:</b>
	/// 	- USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND	--> si la consulta no devuelve un resultao unico para el token
	///  - INCORRECT_PARAMETERS					--> si falta algun parametro.
	static final String URL_ANDROIDPOST_GET_CONFIG_EMPLEADO = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=obtenerConfigEmployee";

	/// Funcion que devuelve un objeto json con los datos del empleado a partir del token
	///
	/// <b>Parametros de entrada:</b>
	///  - token          --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	///	"resultado": "ok|error|exception",	--> resultado de la operacion
	///	"result_str": "",					--> mensaje con error
	///	"usuario":							--> informacion del usuario devuelto
	///	    {
	///	    "code": 379				--> Código del login del empleado
	///	    "email":"",				--> Email del empleado (username)
	///	    "loginToken":"",		--> El token asignado en el login
	///	    "2FAuth_configured": true|false,	--> Flag que indica si el usuario tiene la Autenticación en 2 pasos configurada
	///  	"2FAuth_stepConfig: {
	///  		"2FAuth_required": true|false,	--> Flag que indica si el usuario requiere tener la autenticacion en 2 pasos configurada
	///  	    "2FAuth_step": "",			--> String con el valor del step que hay que mandar a la rutina de configuracion de la aut en 2 pasos
	///  	    "2FAuth_step_url": "",		--> String con la URL que hay que abrir para ejecutar el proceso de autenticación en 2 pasos
	///  	    "2FAuth_step_params": [		--> Objeto con los parametros que hay que pasar a la URL y los tipos de datos que hay que pasarle
	///  	    	{
	///  	    		"paramType": 'get|post|function',
	///  	    		"paramName": 'paramName',
	///  	    		"paramValue": 'paramValue'
	///  	    	},
	///  	    	...
	///  	    ],
	///  	},
	///   	"lastLoginDate": 'Y-m-d H:i:s',	--> Fecha y hora de ultima conexion (anterior a esta si la hay)
	///	    "companys": [			--> Listado de compañías en las que puede acceder
	///		{
	///		    "id": 104,					--> Id de la compañía
	///		    "name": "Soluciones inf…",	--> Nombre de la compañía
	///		    "areas": [					--> Lista de áreas seleccionables
	///			{
	///			    "id": 211,			--> Id del área
	///			    "name": "Segovia",	--> Nombre del área
	///			    "modAT":0|1,		--> (DEPRECATED VALUE, HAY QUE DEJAR DE USARLO y usar el definido a nivel de file) 0 --> no está habilitado el módulo de presencia y absentismo (fichajes) | 1 --> habilitado el módulo de presencia y ABS (posible fichar)
	///			    "modGDoc":0|1,		--> (DEPRECATED VALUE, HAY QUE DEJAR DE USARLO y usar el definido a nivel de file) 0 --> no está habilitado el gestor documental. | 1 --> gestor documental activo
	///			    "files": [			--> Lista de planificaciones seleccionables
	///				{
	///				    "id":342,							--> Id de la planificación
	///				    "name": "2017",						--> Nombre de la planificación
	///				    "firstShiftDate": "2017-01-01",		--> Fecha de inicio de planificación
	///				    "lastShiftDate": "2017-12-31",		--> Fecha de fin de planificación
	///			        "modAT":0|1,						--> 0 --> no está habilitado el módulo de presencia y absentismo (fichajes) | 1 --> habilitado el módulo de presencia y ABS (posible fichar)
	///  			    "modGDoc":0|1,						--> 0 --> no está habilitado el gestor documental. | 1 --> gestor documental activo
	///				    "takePhoto": 0|1,					--> si no se toma foto, 1 si se toma foto
	///				    "saveRandomPhoto": 50,				--> probabilidad de guardar foto de 0 a 100
	///				    "mantainLastNPhoto": 100,			--> numero de fotos a guardar, pasado el número se sobrescriben
	///				    "keyboardSound": 0|1,				--> 1 si se usan sonidos de teclado o 0 si no.
	///				    "accessSound":0|1,					--> 1 si se usan sonidos de acceso correcto o incorrecto, 0 si no.
	///				    "cameraSound":0|1,					--> 1 si se usa sonido de obturador al hacer foto, 0 si no.
	///				    "saveLocationPEmp":0|1,				--> 1 si se guarda la ubicacion del puesto fijo, 0 si no.
	///				    "signingWithNFC": 0|1,				--> 1 si se puede usar tecnología NFC para fichar, 0 en caso contrario.
	///				    "allowTZDetectPEmp": 0|1,			--> 1 si se puede autodetectar la zona horaria del dispositivo para fichar, 0 si se debe usar la configurada en pgplanning.
	///				    "nextFileID": 486,					--> ID de la próxima planificación (si existe).
	///				    "nextFirstShiftDate": "2018-01-01", --> Fecha de comienzo de la nueva planificación (solo si existe nextFileID).
	///				    "nextLastShiftDate": "2018-12-31",	--> Fecha de fin de la nueva planificación (solo si existe nextFileID).
	///				    "employees" : [
	///				    {
	///				        "id" : 8,						--> ID del empleado en la planificación
	///				        "name" : "Empleado A",			--> Nombre del empleado
	///				        "signingInEmpPortal" : 	0|1,	--> 0--> el empleado NO puede fichar desde el portal | 1--> el empleado puede fichar desde el portal
	///				        "showSigningsInEmpPortal" : 0|1 --> 0--> el empleado NO puede ver sus fichajes desde el portal | 1--> el empleado puede ver sus fichajes desde el portal (SIN USO PARA TI)
	///				    }
	///				    ]
	///				}
	///			    ]
	///			}
	///		    ]
	///		}
	///	    ]
	///		}
	///  }
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error:</b>
	/// 	- USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND	--> si la consulta no devuelve un resultao unico para el token
	///  - INCORRECT_PARAMETERS					--> si falta algun parametro.
	static final String URL_ANDROIDPOST_GET_EMPLOYEE_DATA = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=obtenerDatosEmpleado";

	/// Funcion que deslogea un empleado del portal
	///
	/// <b>Parametros de entrada:</b>
	///  - token          --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error o exception:</b>
	/// 	- excepcion : ERROR_LOGOUT			--> si ocurre una excepcion al borrar la session de la base de datos
	///  - error : INCORRECT_PARAMETERS	--> si falta algun parametro.
	static final String URL_ANDROIDPOST_LOGOUT_EMPLOYEE = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=logoutEmployee";

	/// Funcion que devuelve un objeto json con los datos de la url y parametros necesdarios para poder
	/// acceder al portal del empleado con un login ya realizado en la app (token)
	///
	/// <b>Parametros de entrada:</b>
	///  - token          --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 		'url': 'http.....' --> Url solicitada
	/// 		'params': [
	/// 		{
	///			'paramType': "post",	--> Tipo de parametro (get|post)
	///			'paramName': "tk",		--> Nombre que debe tener el parametro
	///			'paramValue': "token",	--> Valor del parametro
	/// 		}
	/// 		]
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error o exception:</b>
	/// 	- USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND	--> Si no se encuentra un login asociado al token
	/// 	- UNKNOWN_HTTP_HOST 					--> Si no se reconoce el HOST desde el que se procesa la solicitud (servidores de pgplanning, inf globales, desarrollo)
	///  - INCORRECT_PARAMETERS					--> si falta algun parametro.
	static final String URL_ANDROIDPOST_GET_URL_PORTAL = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=urlPortalLogeado";

	/// Funcion que devuelve un objeto json con los datos de las secciones del portal del empleado
	/// a las ue tiene acceso un determinado empleado dado su token. Se devuelve los datos como
	/// el nombre, url, iconos, si esta habilitado o no, el tipo de seccion (nativa o webview) y
	/// los parametros necesdarios para poder acceder al portal del empleado con un login
	/// ya realizado en la app (token)
	///
	/// <b>Parametros de entrada:</b>
	///  - token          --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 		'secciones': [
	/// 		{
	/// 		    "name": "Fichaje",				--> Nombre de seccion
	/// 		    "type": "native",				--> Tipo de seccion (native|webview)
	/// 		    "url": "'.$baseURL.'sign.php",	--> Url de la version webview
	/// 		    "enabled": "true",				--> true si el empleado puede usar esta seccion, false si no.
	/// 		    "visible": "true",		    	--> true si la seccion es visible, false si no. Relacionado con
	/// 												Enabled, no tiene sentido enabled = true, visible = false.
	/// 												Pero si, enabled=false y visible=true y el resto de combinaciones.
	/// 		    "iconFont": "FontAwesome",		--> Nombre de la fuente usada para los iconos
	/// 		    "iconName": "fa-user-o",		--> Nombre que da la fuente al icono
	/// 		    "iconUnicode": "&#xf2c0;",	--> String representacion del caracter unicode que representa vinculado al icono
	/// 		    "iconBadge": "pemp_num_propossals_pending_for_emp" --> String con el nombre ee la funcion que devuelve el valor del badge a usar, si hay que usarlo. (parametro opcional).
	/// 		    "params": [						--> Listado de parametros necesario para el acceso al webview con la url indicada.
	/// 		    {
	/// 		        "paramType": "post",		--> Tipo de paramero (get|post)
	/// 		    	"paramName": "tk",			--> Nombre del parametro
	/// 		    	"paramValue": "token"		--> Valor del parametro
	/// 		    },
	/// 		   	...
	/// 		    ]
	/// 		},
	/// 		...
	/// 		]
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error o exception:</b>
	/// 	- USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND  --> Si no se encuentra un login asociado al token
	///  - UNKNOWN_HTTP_HOST			    		--> Si no se reconoce el HOST desde el que se procesa la solicitud (servidores de pgplanning, inf globales, desarrollo)
	///  - INCORRECT_PARAMETERS	--> si falta algun parametro.
	static final String URL_ANDROIDPOST_GET_SECTIONS_PORTAL = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=seccionesPortalEmpleado";

	/// Función que obtiene el número de propuestas pendientes que tiene el empleado
	/// <b>Parametros de entrada:</b>
	/// 	- un input json con los parametros para realiza la consulta. El formato del input será:
	/// 	{
	/// 	 	"token" : "bad60d755c5500c1f1e4880135295501"		--> Un string con el token asignado a la aplicacion en el login (Obligatorio)
	/// 	 	"employeeInClause" : ["badgeKey1","badgeKey2"],		--> Arrays de las claves de los badge a recuperar deben coincidir con el nombre de las funciones que recuperan los valores
	/// 	}
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', 			--> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' 			--> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 		'badge_values': {		    	--> valores de los badges solicitados (Si la ejeccion es correcta y resultado es "ok"
	/// 	    	'badgeKey1': badgeValue1,
	/// 	    	'badgeKey2': badgeValue2,
	/// 	    	...
	/// 		}
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error o exception:</b>
	/// 	- INVALID_TOKEN_OR_NOT_CONFIGURED  		--> El token no se ha encontrado o no es válido (no se ha configurado).
	///  - INCORRECT_PARAMETERS					--> si falta algun parametro.
	///  - El mensaje de excepcion resultante
	static final String URL_ANDROIDPOST_GET_MULTIPLE_BADGE_VALUES = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=pemp_get_badge_values_generic"; // &XDEBUG_SESSION_START=netbeans-xdebug

	/// Funcion que obtiene el numero de propuestas pendientes que tiene el empleado
	///
	/// <b>Parametros de entrada:</b>
	///  - token          --> token identificador de la session. ("bad60d755c5500c1f1e4880135295501")
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	/// 		'resultado': 'valor', --> Posibles Valores [ok, error, exception]
	/// 		'result_str': 'valor' --> Un string con un codigo identificativo del error si resultado=error, un mensaje si es exception, blanco si ok.
	/// 		'badge_value': 0	  --> Un valor entero con el valor badge a mostrar
	/// 	}
	///
	/// 	<b>Posibles códigos de result_str cuando resultado = error o exception:</b>
	/// 	- INVALID_TOKEN_OR_NOT_CONFIGURED  		--> El token no se ha encontrado o no es válido (no se ha configurado).
	///  - INCORRECT_PARAMETERS					--> si falta algun parametro.
	///  - El mensaje de excepcion resultante
	static final String URL_ANDROIDPOST_GET_PROPOSSAL_BADGE_VALUE = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=pemp_num_propossals_pending_for_emp";



	/// Función que devuelve un objeto json con los datos solicitados a partir del token
	///
	/// <b>Parametros de entrada:</b>
	///  - un input json con los parametros para realizar las consultas.
	///    El formato del input será:
	/// 	{
	///		"nQuery" : "QUERY_EMPLEADOS",		--> Un string con el id de consulta de entre los posibles (Obligatorio).
	///	    		Posibles valores:
	///					- QUERY_EMPLEADOS	    -->	Listado de ids y nombres de empleados, todos, sin mas filtros adicionales.
	///					- QUERY_INCIDENCIAS   	--> Listado de incidencias seleccionables, tiene como modificador el parametro tokenOrigin. En funcion del valor, devolverá las incidencias de pgtime, del portal o todas en general.
	///					- QUERY_SHIFTTYPES    	--> Listado de turnos, todos, sin mas filtros adicionales.
	///					- QUERY_LOCATION	    --> Listado de ubicaciones, todas, sin mas filtros adicionales.
	///					- QUERY_SKILLS	    	--> Listado de habilidades, todas, sin mas filtros adicionales.
	///					- QUERY_TIPOS_TT	    --> Listado de tipos de turno del calendario del empleado. Estos ids se vinculan con el campo stype de TIMETABLE
	///					- QUERY_TIMETABLE	    --> Listado de turnos asinados a los empleados en un rango de fecha. Esta consulta acepta filtros adicionales (employeeInClause, dateStart, dateEnd).
	///					- QUERY_FESTIVOS	    --> Listado de festivos asignados a los empleados. Esta consulta acepta filtros adicionales (employeeInClause), por defecto, para el portal, solo se devolveran los festivos del empleado logeado, usar clausula para recuperar otros ids de empleados.
	///
	///		"token" : "bad60d755c5500c1f1e4880135295501"		--> Un string con el token asignado a la aplicacion en el login (Obligatorio)
	///		"tokenOrigin" : "PGTIME|PGEMP|GENERAL"	--> Un string con el tipo de acceso. Este campo define el origen de la petición y siempre se usará el mismo dependiendo de que APP realice la peticion (portal o fichajes).
	///	    		Posibles valores:
	///					- PGTIME --> para puesto fijo. (En caso de consulta de datos especificos devolverá datos relativos al módulo de fichajes)
	///					- PGEMP --> modo Portal del empleado. (En caso de consulta de datos especificos devolverá datos relativos al módulo del portal del empleado)
	///					- GENERAL --> Api General (Sin uso actualmente). (Para cuando se deban obtener otro tipo de datos)
	///
	///					(Se requiere al menos una de las opciones)
	///
	///		"employeeInClause" : [1,2,3],		--> Arrays de ids de empleados
	///		"dateStart" = "2017-09-01",			--> Fecha de inicio del filtro (opcional)
	///		"dateEnd" = "2017-09-10"			--> Fecha de fin del filtro (opcional)
	/// }
	///
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	///	"resultado": "ok|error|exception",  --> resultado de la operacion
	///	"result_str": "",		    --> mensaje con error
	///	"result_data":			    --> informacion del usuario devuelto
	///	    [
	///		{ obj 1}, {obj 2}
	///	    ]
	/// }
	///
	/// <b>Posibles códigos de result_str cuando resultado = error:</b>
	/// 	- USER_ASSOCIATED_WITH_TOKEN_NOT_FOUND	--> si la consulta no devuelve un resultao unico para el token
	///  - INCORRECT_PARAMETERS					--> si falta algun parametro.
	///
	///	- NO_PARAMETERS					--> No se ha recibido un input json valido.
	///	- INCORRECT_PARAMETERS[paramName1, paramName2]	--> Parametros incorrectos con el listado
	///							    de los parametros (nombre del parametros)
	///							    que no estan definidos. Si el error es de
	///							    valor de tokenOrigin, el error devolvería:
	///							    "tokenOriginValue".
	/// 	- INVALID_TOKEN_OR_NOT_CONFIGURED			--> El token no se ha encontrado o no es válido (no se ha configurado).
	///
	/// 	<b>Posible valor para resultado expception:</b>
	/// 	Mensaje con detalle de excepción si ocurreo algún error al ejecutar consulta del usuario
	static final String URL_ANDROIDPOST_CONSULTAR = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=consultar";

	/// Funcion que devuelve un objeto json con los datos de la operacion de fichaje (en este caso sin grabarlo)
	/// Es util para determinar si el proximo fichaje sera una entrada o una salida, etc.
	///
	/// <b>Parametros de entrada:</b>
	///  - token      	--> token identificador de la session.
	///  - lang  		--> lenguage a usar para devolver cadenas traducidas, cadena tipo es_ES ó en_US, (Opcional, default: es_ES)
	///  - userTimeZone  --> zona horaria del empleado, es opcional y solo se especificará cuando sea pertinente. La zona horaria será validada y aplicada si asi se resuelve. (Opcional)
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	///	"resultado": "ok|error|exception",  --> resultado de la operacion
	///	"result_str": "",		    --> mensaje con error
	///	"result_data": {			--> informacion del fichaje si se produjera
	///		'response': valor,		--> resultado de la operacion //'ok' --> procesado correctamente, 'ko' --> procesado con errores
	///		'error': 'value',		--> codigo de error si response es 'ko' -->
	///			Posibles Valores de error:
	///				- error 			--> Si se produce error en consultas
	///				- repeat 			--> Si el fichaje no se puede generar por considerarse repetido (<1min desde ultimo fichaje)
	///				- noDay 			--> Si el fichaje se produce en un dia sin turno
	///				- noEmp 			--> Si no se consigue obtener el id del empleado del fichaje.
	///				- noFile 			--> Código de error que indica que no existe planificacion válida. Solo cuando response = noF.
	///				- beforeSTMenosTCE 	--> Código de error que indica que no se puede fichar porque aun no ha comenzado la jornada
	/// 	  								    laboral del trabajador. Esto solo afecta si se configura que no se pueda fichar antes de la jornada.
	///		'shift': valor, 			--> id del tipo de turno al que estaría vinculado el fichaje.
	///		'inOrOut': 0|1,				--> Tipo de fichaje:  0 --> Entrada,  1 --> Salida
	///		'emp': 8,					--> id del empleado del fichaje
	///		'date': "YYYY-MM-DD",		--> fecha del fichaje
	///		'time': "HH:MM:SS",			--> hora del fichaje
	///		'incidence': 0,				--> 0 para no incidencia, o el id de incidencia del fichaje
	///		'buttonText' : "value",		--> devuelve una cadena traducida con el texto que debe tener el boton de fichar .
	///		"askQuestion" : {			--> (solo en fichaje con inOrOut = 0). Es un objeto que define la pergunta que hay que realizar al usuario y bajo que circustancias hay que realizarla.
	///		    "question_str": "¿Finaliza tambien su jornada laboral?",	--> Texto traducido a idioma seleccionado de la pregunta que se le debe realizar al empleado
	///		    "condition_to_ask": {			--> Condicionante para realizar o NO esta pregunta. Si no existiera este atributo, se realizaria siempre (Por ahora todas las preguntas tienen condicionantes)
	///				"field": "incidence",		--> Nombre del campo de la condición, por ahora solo puede tener como valor "incidence", que indica el código de incidencia seleccionada por el usuario en el fichaje.
	///				"operator":"IN",			--> Operador de la condición, por ahora solo puede tomar valor "IN" que indica que el campo del condicionante debe estar en un listado de valores.
	///				"values": [0,2]				--> Listado de valores que tiene que tomar el campo del condicionante para que se realice la pregunta. Si este listado incluye el 0 significa tambien se realiza si no se selecciona ninguna incidencia en el fichaje, el resto indica los IDs de las incidencias en las que se pregunta.
	///		    },
	///		    "responses": [		--> array con el listado de respuestas posibles a la pregunta. (Numero de elementos variable, por ahora, entre 2 y 3)
	///			{
	///			    "text": "<b>SI</b>, finalizar jornada también",	    --> Texto traducido a idioma seleccionado de la respuesta que mostrar al usuario (Puede contener etiquetado HTML básico).
	///			    "name": "responseUser",				    			--> Nombre del parámetro que se usará para devolver la respuesta del usuario cuando se seleccione esta respuesta. (De momento, es un parametro fijo, llamado "responseUser".
	///			    "value": 2						    				--> Valor del parametro cuando se seleccione esta respuesta.
	///			},
	///			{
	///			    "text": "<b>NO</b>, finalizar solo incidencia",
	///			    "name": "responseUser",
	///			    "value": 1
	///			}
	///		    ]
	///		}
	///	}
	/// }
	///
	/// <b>Posibles códigos de result_str cuando resultado = error:</b>
	///    INVALID_TOKEN_OR_NOT_CONFIGURED  --> si no se encuentra el token especificado
	///    INCORRECT_PARAMETERS             --> si no se reciben todos los parametros previstos
	static final String URL_ANDROIDPOST_EMP_ACCESO_CHECK = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=pemp_acceso_user_nextTypeSign";

	/// Funcion que devuelve un objeto json con los datos de la operacion de fichaje (en este caso sin grabarlo)
	/// Es util para determinar si el proximo fichaje sera una entrada o una salida, etc.
	///
	/// <b>Parametros de entrada:</b>
	///  - token      	--> token identificador de la session.
	///  - incidencia 	--> id de la incidencia seleccionada por el usuario, 0 si no se selecciona ninguna (opcional, default: 0)
	///  - lang  		--> lenguage a usar para devolver cadenas traducidas, cadena tipo es_ES ó en_US, (Opcional, default: es_ES)
	///  - latitud    	--> latitud de coordenada (formato WGS84) ("40.9558823") //(opcional)
	///  - longitud   	--> longitud de coordenada (formato WGS84) ("-4.1206448") //(opcional)
	///  - accuracy   	--> margen de error devuelto junto con las coordenadas en metroes(1250) //(opcional)
	///  - userTimeZone  --> zona horaria del empleado, es opcional y solo se especificará cuando sea pertinente. La zona horaria será validada y aplicada si asi se resuelve. (Opcional)
	///  - responseUser  --> código de respuesta en caso de haber necesitado realizar pregunta (opcional si no se realiza pregunta).
	/// <b>Respuesta:</b>
	///  Json con formato:
	///  {
	///	"resultado": "ok|error|exception",  --> resultado de la operacion
	///	"result_str": "",		    	--> mensaje con error
	///	"result_data": {				--> informacion del fichaje si se produjera
	///		'response': valor,			--> resultado de la operacion //'ok' --> procesado correctamente, 'ko' --> procesado con errores
	///		'error': 'value',			--> codigo de error si response es 'ko' -->
	///			Posibles Valores de error:
	///				- error 			--> Si se produce error en consultas
	///				- repeat 			--> Si el fichaje no se puede generar por considerarse repetido (<1min desde ultimo fichaje)
	///				- noDay 			--> Si el fichaje se produce en un dia sin turno
	///				- noEmp 			--> Si no se consigue obtener el id del empleado del fichaje.
	///				- noFile 			--> Código de error que indica que no existe planificacion válida. Solo cuando response = noF.
	///				- beforeSTMenosTCE 	--> Código de error que indica que no se puede fichar porque aun no ha comenzado la jornada
	/// 	 							    laboral del trabajador. Esto solo afecta si se configura que no se pueda fichar antes de la jornada.
	///		'shift': valor, 			--> id del tipo de turno al que estaría vinculado el fichaje.
	///		'inOrOut': 0|1,				--> Tipo de fichaje:  0 --> Entrada,  1 --> Salida
	///		'emp': 8,					--> id del empleado del fichaje
	///		'date': "YYYY-MM-DD",		--> fecha del fichaje
	///		'time': "HH:MM:SS",			--> hora del fichaje
	///		'incidence': 0,				--> 0 para no incidencia, o el id de incidencia del fichaje
	///		'greetingMsg' : "msg",		--> (solo en grabar fichaje), devuelve una cadena traducida con el mensaje de entrada a mostrar (hola, buenos dias, buenas noches, etc)
	///	}
	/// }
	///
	/// <b>Posibles códigos de result_str cuando resultado = error:</b>
	///    INVALID_TOKEN_OR_NOT_CONFIGURED  --> si no se encuentra el token especificado
	///    INCORRECT_PARAMETERS             --> si no se reciben todos los parametros previstos
	static final String URL_ANDROIDPOST_EMP_ACCESO = ROOT_URL + URL_ANDROIDPOST_BASE_API + "?function=pemp_acceso_user";


	//Constantes Datos App
	static final String PREFERENCIAS_NAME = "empleado";
	static final int SPLASH_TIME = 500;

	static final String TAG_VOLLEY_REQ_AC_DATA = "REQ_AC_DATA";

	//CONSULTAS DE DATOS PREFIJADAS:
	static final String CONSULTA_PREFIJADA_EMPLEADOS = "QUERY_EMPLEADOS";
	static final String CONSULTA_PREFIJADA_INCIDENCIAS = "QUERY_INCIDENCIAS";
	static final String CONSULTA_PREFIJADA_INCIDENCIAS_TRABAJO = "QUERY_INCIDENCIAS_TRABAJO";
	static final String CONSULTA_PREFIJADA_INCIDENCIAS_ALL = "QUERY_INCIDENCIAS_ALL";
	static final String CONSULTA_PREFIJADA_SHIFTTYPES = "QUERY_SHIFTTYPES";
	static final String CONSULTA_PREFIJADA_LOCATION = "QUERY_LOCATION";
	static final String CONSULTA_PREFIJADA_SKILLS = "QUERY_SKILLS";
	static final String CONSULTA_PREFIJADA_TIPOS_TT = "QUERY_TIPOS_TT";

	//Codigo Request de permisos capa overlay
	static final int LOCATION_PERMISSION_REQUEST_CODE = 2958;
	static final int ENABLE_LOCATION_REQUEST_CODE = 2959;
  static final int STORAGE_PERMISSION_REQUEST_CODE = 2960;

	static final int WEBVIEW_FILECHOOSER_REQUEST_CODE = 2961; //Variable estatica para definir el resultcode del filechooser
	static final int WEBVIEW_FILECHOOSER_REQUEST_CODE_LOLLIPOP = 2962; //Variable estatica para definir el resultcode del filechooser
	static final int WEBVIEW_FILECHOOSER_TAKE_PICTURE_REQUEST_CODE = 2963; //Variable estátoca para definir el resultcode al escoger hacer una foto en el fileChooser

	static final int CAMERA_PERMISSION_REQUEST_CODE = 2964; //Request code para solicitar el permiso para usar la camara

	//*********************************************************** //
	//**   Parametros relacionados con los ficheros del GODC   ** //
	//*********************************************************** //

	//Variables que configuran los directorios de almacenamiento de archivos a usar, tanto para descarga de ficheros como para guardar las capturas
	//de elementos a enviar al gdoc. Ademas configura el tipo de dialogo para solicitar el origen de los medios a subir  (camara o dispostivio) entre
	//usar un dialogo o una UI al pie de la app (BOTTOM_SHEET)
	//static final FileChooserMediaSourceSelectorTypes WEBVIEW_MEDIA_SOURCE_CHOOSER_TYPE = FileChooserMediaSourceSelectorTypes.BOTTOM_SHEET;

	static final String DOC_TYPE_CAPTURE = "capture_code";
	static final String DOC_TYPE_DOCUMENTS = "documents_code";
	static final String APP_DOWNLOAD_RELATIVE_FOLDER = "ArchivosPGPlanning";
	static final String APP_CAPTURES_RELATIVE_FOLDER = "Camera";
	//static final String DOCS_BASE_FOLDER_FOR_DOCUMENTS = Environment.DIRECTORY_DOCUMENTS;
	//static final String DOCS_BASE_FOLDER_FOR_CAPTURES = Environment.DIRECTORY_DCIM;
	//Funciones de ayuda para recuperar los path de almacenamiento de archivos para usar la descarga desde el GDOC o para la carga de archivos al mismo
	/**
	 * Función que recupera el path relativo para el directorio de almacenamiento de documentos en
	 * función de la version de android en ejecución. Se usa la ruta base definida en {@link #DOCS_BASE_FOLDER_FOR_DOCUMENTS}
	 * </br>
	 * <b> - En versión igual o superior a Q (Android 10): </b> se devuelve la ruta sin obtener el path real absoluto. <b>Ejemplo: /Documents/ArchivosPGPlanning</b>
	 * <b> - En versión anterior: </b> se devuelve la ruta absoluta a dicha carpeta. <b>Ejemplo: /storage/emulated/0/Documents/ArchivosPGPlanning</b>
	 *
	 * @return la ruta del archivo para utilizar en las funciones para acceder a los ficheros de documentos.
	 */
	/*static String docs_getPathForDocuments() {
		String path = null;
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
			path = Parametros.DOCS_BASE_FOLDER_FOR_DOCUMENTS;
		} else {
			path = Environment.getExternalStoragePublicDirectory(Parametros.DOCS_BASE_FOLDER_FOR_DOCUMENTS).toString();
		}
		path += File.separator + Parametros.APP_DOWNLOAD_RELATIVE_FOLDER;

		return path;
	}*/
	/**
	 * Función que recupera el path relativo para el directorio de almacenamiento de capturas en
	 * función de la version de android en ejecución. Se usa la ruta base definida en {@link #DOCS_BASE_FOLDER_FOR_CAPTURES}
	 * </br>
	 * <b> - En versión igual o superior a Q (Android 10): </b> se devuelve la ruta sin obtener el path real absoluto. <b>Ejemplo: /DCIM/camera</b>
	 * <b> - En versión anterior: </b> se devuelve la ruta absoluta a dicha carpeta. <b>Ejemplo: /storage/emulated/0/DCIM/camera</b>
	 *
	 * @return la ruta del archivo para utilizar en las funciones para acceder a los ficheros de capturas.
	 */
	/*static String docs_getPathForCaptures() {
		String path = null;
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
			path = Parametros.DOCS_BASE_FOLDER_FOR_CAPTURES;
		} else {
			path = Environment.getExternalStoragePublicDirectory(Parametros.DOCS_BASE_FOLDER_FOR_CAPTURES).toString();
		}
		path += File.separator + Parametros.APP_CAPTURES_RELATIVE_FOLDER;

		return path;
	}*/
	/**
	 * Funcion que en funcion del mediaType del archivo a almacenar, devuelve la ruta de almacenamiento
	 * para el archivo.
	 * <br><br>
	 * Esta funcion es una indexadora que llama a las funciones {@link #docs_getPathForCaptures()} o {@link #docs_getPathForDocuments()} en funcion
	 * del parametro de entrada.
	 * <br><br>
	 * - Si el parametro toma el valor de {@link #DOC_TYPE_CAPTURE} devuelve el valor de {@link #docs_getPathForCaptures()} <br>
	 * - Si el parametro toma el valor de {@link #DOC_TYPE_DOCUMENTS} devuelve el valor de {@link #docs_getPathForDocuments()} <br>
	 *
	 * @param mediaType un String con el valor del tipo de ficghero a referenciar. Debe tomar como valor {@link #DOC_TYPE_CAPTURE} o {@link #DOC_TYPE_DOCUMENTS}
	 * @return el resultado de invocar a la funcion {@link #docs_getPathForCaptures()} o {@link #docs_getPathForDocuments()} en funcion del parametro de entrada.
	 *
	 * @throws IllegalArgumentException si el valor del parametro de entrada no es {@link #DOC_TYPE_CAPTURE} o {@link #DOC_TYPE_DOCUMENTS}
	 */
	/*static String docs_getPathFor(String mediaType) throws IllegalArgumentException {
		String resultValue = null;
		switch (mediaType) {
			case Parametros.DOC_TYPE_CAPTURE:
				resultValue = docs_getPathForCaptures();
				break;
			case Parametros.DOC_TYPE_DOCUMENTS:
				resultValue = docs_getPathForDocuments();
				break;
			default:
				throw new IllegalArgumentException("The supllied argument mediaType with value [" + mediaType + "] is not a expected value");
		}
		return resultValue;
	}*/
	/**
	 * Funcion que en funcion del uri especificado, devuelve la ruta de almacenamiento para el archivo.
	 * <br><br>
	 * Esta función recupera el tipo de documento llamando a {@linkl #docs_getDOC_TYPE_by_contentUri(Uri)} para posteriormente
	 * llamar a la funcion indexadora {@link #docs_getPathFor(String)} que nos devolverá la ruta de almacenamiento para el
	 * tipo de fichero de la Uri.
	 *
	 * @param contentUri La uri del archivo del que detectar la ruta de almacenamiento base original
	 * @return un String con la ruta de almacenamiento base para el archivo especificado en la URI.
	 */
	/*static String docs_getPathFor_contentUri(Uri contentUri) {
		return Parametros.docs_getPathFor(Parametros.docs_getDOC_TYPE_by_contentUri(contentUri));
	}*/
	/**
	 * Función que obtiene el valor del tipo de documento en funcion de la ruta URI del documento.
	 * Esta funcion devuelve el valor {@link #DOC_TYPE_CAPTURE} o {@link #DOC_TYPE_DOCUMENTS} en
	 * funcion de si el archivo referencia a una captura de PGPlanning o un documento descargado
	 * de PGPlanning respectivamente.
	 *
	 * @param contentUri La uri del archivo del que detectar de que tipo de documento se trata
	 *
	 * @return un String con el valor {@link #DOC_TYPE_CAPTURE} si la URI corresponde a una captura o
	 * {@link #DOC_TYPE_DOCUMENTS} si la URI se corresponde a un documento o no se puede detectar el tipo correcto.
	 */
	/*static String docs_getDOC_TYPE_by_contentUri(Uri contentUri) {
		if (contentUri.getPath().contains(Parametros.DOCS_BASE_FOLDER_FOR_CAPTURES)) {
			return Parametros.DOC_TYPE_CAPTURE;
		} else if (contentUri.getPath().contains(Parametros.DOCS_BASE_FOLDER_FOR_DOCUMENTS)) {
			return Parametros.DOC_TYPE_DOCUMENTS;
		}

		return Parametros.DOC_TYPE_DOCUMENTS; //por defecto en caso de no detectarlo, devolvemos este tipo
	}*/
	//FIN Funciones de ayuda para recuperar los path de almacenamiento de archivos para usar la descarga desde el GDOC o para la carga de archivos al mismo

	//*********************************************************** //
	//** FIN Parametros relacionados con los ficheros del GODC ** //
	//*********************************************************** //

}
