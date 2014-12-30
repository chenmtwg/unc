<?php

$url = $_SERVER['SERVER_NAME'];

$website1 = "www.uncorked.com";

// Test for requested website then display relevant robots.txt content

if (strpos($url,$website1) !== false) {
    include 'robots/produncorked.php';
}else{
    include 'robots/deny.php';
}

?>
