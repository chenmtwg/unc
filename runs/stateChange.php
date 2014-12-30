<?php
require_once('../app/Mage.php');
Mage::app();

$orderId="1216153333";

$order = Mage::getModel('sales/order')->loadbyIncrementId($orderId);
echo "orig status=".$order->getStatus()."\n";
echo "orig state=".$order->getState()."\n";


$order->setState(Mage_Sales_Model_Order::STATE_NEW, true)->save();
$order->setStatus("Pending")->save();
$order->addStatusHistoryComment('Manually set order to Pending.', false);
$order->save();

echo "new status=".$order->getStatus()."\n";
echo "new state=".$order->getState()."\n";

?>

