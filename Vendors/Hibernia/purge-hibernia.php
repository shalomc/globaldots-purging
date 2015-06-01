<?php
// Usage: 
//	php -f purge-hibernia.php ZoneID  "regular-expression"

// Example: 
//	php -f purge-hibernia.php 98  "/index_kukuki/*"
// $secret = 'mySecretKey';
// $customer_id = '1234567890';
// $zone_id = '98';
define("BASE_URL",     "https://portal.hiberniacdn.com");


$ini_array = parse_ini_file("hibernia-config.txt");
$customer_id = $ini_array['Customer'] ;
$secret = $ini_array['Password'] ;


function hibernia_Login($customer_id, $secret) 
{
	$action = '/api/login.json' ;
    $url =   BASE_URL.$action;

    $ch = curl_init();  
	
    curl_setopt($ch,CURLOPT_URL,$url);
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
    curl_setopt($ch,CURLOPT_HEADER, false); 
	curl_setopt($ch, CURLOPT_VERBOSE, false);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST"); 
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, TRUE);
	curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query(array(
						'email' => $customer_id, 
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
 

function hibernia_Purge($url_to_purge, $site_id, $auth_token) 
{
	$action = '/api/purges.json' ;
	    $url =   BASE_URL.$action;
		$purge_request = array( 
		"site_id" => $site_id, 
		"urls" => array( $url_to_purge )
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



 
// main body 
$response_string=hibernia_Login($customer_id, $secret)  ; 
$http_response_code=($GLOBALS['http_status']);

$Login=json_decode($response_string);
// print_r( $Login ); 
$token=$Login->bearer_token ;
// echo "\n" ;

$site_id=98;
$url_to_purge= "http://hibernia.cdn.test.danidin.net/index2.html";
$site_id = $argv[1];
$url_to_purge=$argv[2];

print_r(hibernia_Purge($url_to_purge, $site_id, $token) );


?>