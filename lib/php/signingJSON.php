<?php include ("conn/sis.php");

/* Funcion que actualiza las cookies de la configuracion con los valores de la
 *  nueva planificacion
 */
function updateExistingConfig(){
	$data['file'] = md5('PGT'.$_COOKIE['PGTFile']);
	$configuration = jsonConn($data, 'config.php');
	$expirationTime = time() +  (10 * 60); //10 minutos --> //30; //segundos 
	if (isset($configuration->response) && ($configuration->response=='ok')) {
		setcookie('takePhoto', $configuration->takePhoto, $expirationTime);
		$_COOKIE['takePhoto'] = $configuration->takePhoto;
		setcookie('saveRandomPhoto', $configuration->saveRandomPhoto, $expirationTime);
		$_COOKIE['saveRandomPhoto'] = $configuration->saveRandomPhoto;
		//Config de sonido
		setcookie('keyboardSound', $configuration->keyboardSound, $expirationTime);
		$_COOKIE['keyboardSound'] = $configuration->keyboardSound;
		setcookie('accessSound', $configuration->accessSound, $expirationTime);
		$_COOKIE['accessSound'] = $configuration->accessSound;
		setcookie('cameraSound', $configuration->cameraSound, $expirationTime);
		$_COOKIE['cameraSound'] = $configuration->cameraSound;
		setcookie('saveLocationPFijo', $configuration->saveLocationPFijo, $expirationTime);
		$_COOKIE['saveLocationPFijo'] = $configuration->saveLocationPFijo;
	} else {
		setcookie('takePhoto', false, $expirationTime);
		$_COOKIE['takePhoto'] = false;
		setcookie('saveRandomPhoto', false, $expirationTime);
		$_COOKIE['saveRandomPhoto'] = false;
		//Config de sonido
		setcookie('keyboardSound', false, $expirationTime);
		$_COOKIE['keyboardSound'] = false;
		setcookie('accessSound', false, $expirationTime);
		$_COOKIE['accessSound'] = false;
		setcookie('cameraSound', false, $expirationTime);
		$_COOKIE['cameraSound'] = false;
		setcookie('saveLocationPFijo', falsejo, $expirationTime);
		$_COOKIE['saveLocationPFijo'] = false;
	}
}

/* Funcion para intentar realizar el fichaje llamando a JSON/signing.php con los
 *  parametros pasados en el formulario.
 * array $data array de datos para realizar el fichaje
 * string $password pin del empleado que esta fichando
 * boolean $tryingNextPlan para indicar si se esta intentando fichar en la planificacion
 *  en curso ($tryingNextPlan == false) oen la siguiente ($tryingNextPlan == true).
 *  Si $tryingNextPlan = true es que se han renovado las cookies de la planificacion
 *  en curso utilizando los datos de la siguiente y se esta volviendo a intentar.
 *  Si se esta intentando fichar en la siguiente planificacion ($tryingNextPlan == false)
 *  y falla NO hay mas intentos => ERROR: sesion expirada.
 */
function trySign ($data, $password, $tryingNextPlan = false){
	$signing = jsonConn($data, 'signing.php'	);
	if (isset($signing->response)){
		if (!(isset($_COOKIE['PGTime']))){
			if ($tryingNextPlan){ // Si ya se ha intentado en la siguiente planificacion y no existen cookies
				$header = 'Location: ' . PATH . 'logout.php?sessionExpired';
			}else{
				if ((!(isset($_COOKIE['PGTimeNext']))) || (!(isset($_COOKIE['PGTFileNext']))) || (!(isset($_COOKIE['PGTnextLastShiftDate'])))){
					$header = 'Location: ' . PATH . 'logout.php?sessionExpired';
				}else{
					if (isset($_COOKIE['PGTnextLastShiftDate'])){
					    $expirationTime = strtotime($_COOKIE['PGTnextLastShiftDate']);
					}else{
					    // Si no existe PGTnextLastShiftDate es porque no esta definido a nivel de planificacion
					    //  o porque ya ha caducado esa cookie
					}
					// Renuevo las cookies con la nueva planificacion
					setcookie("PGTime", $_COOKIE['PGTimeNext'], $expirationTime);
					$_COOKIE['PGTime'] = $_COOKIE['PGTimeNext'];
					setcookie("PGTFile", $_COOKIE['PGTFileNext'], $expirationTime);
					$_COOKIE['PGTFile'] = $_COOKIE['PGTFileNext'];

					// Elimino las cookies NEXT
					setcookie ("PGTimeNext", "", time()-3600 );
					setcookie ("PGTFileNext", "", time()-3600 );
					unset($_COOKIE['PGTimeNext']);
					unset($_COOKIE['PGTFileNext']);
					
					// Recupero la nueva configuracion de la planificacion
					updateExistingConfig();

					// Vuelvo a generar los datos que se pasan a signing y les afectan las cookies
					$data['file'] = md5('PGT'.$_COOKIE['PGTFile']);
					$data['user'] = md5($_COOKIE ['PGTFile']."Pass".$password);
					
					// Vuelvo a llamar a la funcion con los datos actualizados a la nueva planificacion
					$header = trySign ($data, $password, true);
					
				}
			}
		}elseif ($signing->response=='ok'){
			$header = 'Location: ' . PATH . 'index.php?shift='.$signing->shift.'&inOrOut='.$signing->inOrOut.'&emp='.$signing->emp.'&time='.$signing->time.'&date='.$signing->date.'&inci='.$signing->incidence;
			if (isset($_POST['photo']) && ($_POST['photo'] !== "")) {
				$data2['file'] = md5('PGT'.$_COOKIE['PGTFile']);
				$data2['inOrOut'] = $signing->inOrOut;
				$data2['emp'] = $signing->emp;
				$data2['date'] = $signing->date;
				$data2['time'] = $signing->time;
				$data2['photo'] = $_POST['photo'];
				$dummyResult = jsonConn($data2, 'savePhoto.php');
			}
		}elseif ($signing->response=='ko'){
			$header = 'Location: ' . PATH . 'index.php?'.$signing->error.'='.$signing->code.'&emp='.$signing->emp.'&sign='.$signing->sign;
		}elseif ($signing->response=='noF'){
			if ($tryingNextPlan){ // Si ya se ha intentado en la siguiente planificacion y no existen cookies
				$header = 'Location: ' . PATH . 'logout.php?sessionExpired';
			}else{
				if ((!(isset($_COOKIE['PGTimeNext']))) || (!(isset($_COOKIE['PGTFileNext']))) || (!(isset($_COOKIE['PGTnextLastShiftDate'])))){
					$header = 'Location: ' . PATH . 'logout.php?sessionExpired';
				}else{
					if (isset($_COOKIE['PGTnextLastShiftDate'])){
					    $expirationTime = strtotime($_COOKIE['PGTnextLastShiftDate']);
					}else{
					    // Si no existe PGTnextLastShiftDate es porque no esta definido a nivel de planificacion
					    //  o porque ya ha caducado esa cookie
					}
					// Renuevo las cookies con la nueva planificacion
					setcookie("PGTime", $_COOKIE['PGTimeNext'], $expirationTime);
					$_COOKIE['PGTime'] = $_COOKIE['PGTimeNext'];
					setcookie("PGTFile", $_COOKIE['PGTFileNext'], $expirationTime);
					$_COOKIE['PGTFile'] = $_COOKIE['PGTFileNext'];

					// Elimino las cookies NEXT
					setcookie ("PGTimeNext", "", time()-3600 );
					setcookie ("PGTFileNext", "", time()-3600 );
					unset($_COOKIE['PGTimeNext']);
					unset($_COOKIE['PGTFileNext']);
					
					// Recupero la nueva configuracion de la planificacion
					updateExistingConfig();

					// Vuelvo a generar los datos que se pasan a signing y les afectan las cookies
					$data['file'] = md5('PGT'.$_COOKIE['PGTFile']);
					$data['user'] = md5($_COOKIE ['PGTFile']."Pass".$password);
					
					// Vuelvo a llamar a la funcion con los datos actualizados a la nueva planificacion
					$header = trySign ($data, $password, true);
					
				}
			}
		}else{
			$header = 'Location: ' . PATH . 'index.php?'.$signing->error.'='.$signing->code;
		}
	}else{
		$header = 'Location: ' . PATH . 'index.php?error=-1';
	}

	return $header;
}

// Compruebo el lastShiftDate
if (isset($_COOKIE['PGTFile'])) {
    
    if (!isset($_COOKIE['PGTlastShiftDate'])){
	$data['file'] = md5('PGT'.$_COOKIE['PGTFile']);
	$fileInfo = jsonConn($data, 'getLastShiftDate.php');
	if ((isset($fileInfo->response)) && ($fileInfo->response=='ok')) {
	    $currDate = date("Y-m-d");
	    if ($fileInfo->currLastShiftDate <= $currDate){
		setcookie ("PGTime", "", 1 );
		setcookie ("PGTFile", "", 1 );
		unset($_COOKIE['PGTime']);
		unset($_COOKIE['PGTFile']);
	    }else{
		$expire = strtotime ($fileInfo->currLastShiftDate);
		
		$currPGTimeValue = $_COOKIE['PGTime'];
		$currPGTFileValue = $_COOKIE['PGTFile'];

		setcookie ("PGTime", "", 1 );
		setcookie ("PGTFile", "", 1 );
		unset($_COOKIE['PGTime']);
		unset($_COOKIE['PGTFile']);
		
	    	setcookie("PGTime", $currPGTimeValue, $expire);
		$_COOKIE['PGTime'] = $currPGTimeValue;
		setcookie("PGTFile", $currPGTFileValue, $expire);
		$_COOKIE['PGTFile'] = $currPGTFileValue;
	    }
	}
    }
    setcookie ("PGTlastShiftDate", "", 1 );
    unset($_COOKIE['PGTlastShiftDate']);
}

$data['file'] = md5('PGT'.$_COOKIE['PGTFile']);
$data['user'] = md5($_COOKIE ['PGTFile']."Pass".$_POST ['password']);
$data['date'] =date("Y-m-d");
$data['time'] =substr(date("H:i"),0,5) . ":00";
$data['incidence'] = $_POST ['incidence'];
//si esta disponible, traspasamos la localizacion
if ((isset($_POST['cord_longitud'])) && (isset($_POST['cord_latitud']))) {
	$data['longitud'] = $_POST ['cord_longitud'];
	$data['latitud'] = $_POST ['cord_latitud'];
	if (isset($_POST ['cord_accuracy'])) {
		$data['accuracy'] = $_POST ['cord_accuracy'];
	}
}

$header = trySign($data, $_POST['password'], false);
header($header);