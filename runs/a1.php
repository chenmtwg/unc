<?php
require_once('../app/Mage.php');
Mage::app();



$orderCollection = Mage::getModel('sales/order')->getCollection();


echo "\n";
$i=0;
foreach ($orderCollection as $order){
	$i++;
	echo $i."\n";
}
?>

