<?php
require_once('app/Mage.php');
Mage::app();


$order =  Mage::getModel('sales/order')->load(13218);

echo "\nContainsGiftItem: ".$order->getContainsGiftItems();
echo "\nIs Gift?: ".$order->getOrderType();




echo "\n";
?>

