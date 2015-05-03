<?php
// Usage: 
//	php -f purge-leaseweb.php ZoneID  "regular-expression"

// Example: 
//	php -f purge-leaseweb.php 1352  "/index_kukuki/*"
// $secret = 'mySecretKey';
// $customer_number = '1234567890';
// $zone_id = '1352';

$ini_array = parse_ini_file("Leaseweb-config.txt");
$customer_number = $ini_array['Customer'] ;
$secret = $ini_array['API_KEY'] ;

$zone_id = $argv[1];
$purge_regex=$argv[2];

$action = '/content/purge/' ;
$action = '/zones/pull/'; 

function SignedURL($purge_regex, $customer_number, $secret, $zone_id, $action)
	{
		$path = $action . $customer_number . '/' . $zone_id .  $purge_regex;
		$time = time();
		$signature = sha1($secret.$time.$path);
		$full_path = 'https://api.leasewebcdn.com'.$path.'/'.$time.'/'.$signature;
		
		return $full_path;
	}


function Leaseweb_Purge($purge_regex, $customer_number, $secret, $zone_id) 
{
	$action = '/content/purge/' ;
    $url = SignedURL($purge_regex, $customer_number, $secret, $zone_id, $action) ;  

    $ch = curl_init();  
	
    curl_setopt($ch,CURLOPT_URL,$url);
    curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
    curl_setopt($ch,CURLOPT_HEADER, false); 
	curl_setopt($ch, CURLOPT_VERBOSE, false);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "DELETE"); 
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, TRUE);

    curl_setopt($ch, CURLOPT_HTTPHEADER, array(
			'Content-Type: application/json',
			'Accept: application/json'
			));

    curl_setopt($ch,CURLOPT_ENCODING , "gzip");
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	
    $output=curl_exec($ch);
    $GLOBALS['http_status'] = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
	
    return $output;
}
 
 
// main body 
$response_string=Leaseweb_Purge($purge_regex, $customer_number, $secret, $zone_id) ; 
$http_response_code=($GLOBALS['http_status']);
header('X-PHP-Response-Code: ' . $http_response_code, true, $http_response_code);
//http_response_code($GLOBALS['http_status']);
 header('Cache-Control: private, no-cache'); 
 header('Access-Control-Allow-Origin: *'); 
 header('Content-Type: application/json');

echo $response_string; 

?>