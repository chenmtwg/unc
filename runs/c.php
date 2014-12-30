<?php
require_once('../app/Mage.php');
Mage::app();

$i=8947;
$i=8947;
$i=8947;
$i=13069;
$i=8947;
$i=12674;
$i=3558;


$order =  Mage::getModel('sales/order')->load($i);

$shipcompliant = Mage::getModel('shipcompliant/shipcompliant');
echo get_class($order);echo "\n";
$d= $shipcompliant->checkMarketplaceOrder($order);

echo "...".$d["status"];


echo "\n--\n";

?>
