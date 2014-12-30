<?php
require_once('../app/Mage.php');
Mage::app();

$orderId=13218;

$order =  Mage::getModel('sales/order')->load($orderId);

echo "id:\t".$orderId."\n";
echo "Inc id:\t".$order->getIncrementId()."\n";
echo "sku:\t"."ORDER_DETAILS"."\n";
echo "Type:\t".$order->getOrderType()."\n";
echo "Class:\t".$order->getOrderClass()."\n";
echo "SHIPPING:\n";
echo " State:\t".$order->getShippingAddress()->getregion()."\n";
echo " Cntry:\t".$order->getShippingAddress()->getcountry()."\n";
//var_dump($order->getShippingAddress());
echo "\n";
echo "BILLING:\n";
echo " State:\t".$order->getBillingAddress()->getregion()."\n";
echo " Cntry:\t".$order->getBillingAddress()->getcountry()."\n";





?>

