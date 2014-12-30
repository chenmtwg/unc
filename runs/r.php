<?php
require_once('../app/Mage.php');
Mage::app();

$orderID=1216153353 ;

$order=Mage::getModel('sales/order')->loadByIncrementId($orderID);

echo $order -> getId();

echo "\n";

echo $order -> getStoreId();
echo "\n";
echo $order->getStore()->getWebsiteId();
echo "\n";

echo Mage::app()->getStore()->getWebsiteId();









echo "\n"; ?>

