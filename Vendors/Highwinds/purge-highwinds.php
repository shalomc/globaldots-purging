<?php
// Usage: 
//	php -f purge-highwinds.php account "url-to-purge"

// Example: 
//	php -f purge-highwinds.php 99qaww  "http://highwinds.cdn.test.danidin.net/index2.html"
// $secret = 'mySecretKey';
// $customer_id = '1234567890';
// $account='b6g8z3d9'; 


define("BASE_URL",     "https://striketracker3.highwinds.com/api/v1");
define("BASE_OAUTH_URL",     "https://striketracker3.highwinds.com/auth/token");


$ini_array = parse_ini_file("highwinds-config.txt");
$customer_id = $ini_array['Usr'] ;
$secret = $ini_array['Passw'] ;
// get account as argument to program. The ini file account value 
// $account= $ini_array['account'] ; 
 
$response_string=highwinds_Login($customer_id, $secret)  ; 
$http_response_code=($GLOBALS['http_status']);

$Login=json_decode($response_string);

$token=$Login->access_token ;

$account = $argv[1];
$url_to_purge=$argv[2];

echo highwinds_Purge($url_to_purge, $account, $token) ;


// =====================================================================================
function highwinds_Login($customer_id, $secret) 
{

    $ch = curl_init();  
	
    curl_setopt($ch,CURLOPT_URL, BASE_OAUTH_URL );
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
    curl_setopt($ch,CURLOPT_HEADER, false); 
	curl_setopt($ch, CURLOPT_VERBOSE, false);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST"); 
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, TRUE);
	curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array(
						'grant_type' => 'password', 
						'username' => $customer_id, 
						'password' => $secret
						)));
    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Accept: application/json'
			));

    curl_setopt($ch,CURLOPT_ENCODING , "gzip");
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	
    $output=curl_exec($ch);
    $GLOBALS['http_status'] = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
	
    return $output;
}
 

 

function highwinds_Purge($url_to_purge, $account, $auth_token) 
{
    $url =   BASE_URL . '/accounts/' . $account . '/purge';
	$purge_request = array( 
		"list" => array()
	);

	$purge_request["list"][]=array(
		"url"=>$url_to_purge ,
		"recursive" => "false"
	);

	$auth_header="Authorization: Bearer " . $auth_token; 
    $ch = curl_init();  
	
    curl_setopt($ch,CURLOPT_URL,$url);
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
    curl_setopt($ch,CURLOPT_HEADER, false); 
	curl_setopt($ch, CURLOPT_VERBOSE, false);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST"); 
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, TRUE);

    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/json',
			'Accept: application/json',
			$auth_header
			));
	curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($purge_request) );
    curl_setopt($ch,CURLOPT_ENCODING , "gzip");
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	
    $output=curl_exec($ch);
    $GLOBALS['http_status'] = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
	
    return $output;
}


?>