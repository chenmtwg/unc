<?php
require_once('../app/Mage.php');
Mage::app();


$collection =  Mage::getModel('customer/customer')->getCollection()->addAttributeTOSelect('*');

echo "Customers: ";
echo $collection->count();
echo "<br>";
$i=0;
$customerIDs=array();
foreach ($collection as $customer){
	$customerIDs[] = $customer->getID();
}
echo sizeof($customerIDs);
echo "<br> ==== <br>";

$orderCollection = Mage::getModel('sales/order')->getCollection();

echo "Orders: ";
//echo $orderCollection->count();
echo "<br>";
$orderedID=array();
foreach ($orderCollection as $order){
	$i++;
	if($i>2)break;
	$thisOrderCustID=$order->getData('customer_id');
	echo $thisOrderCustID;
	/*if(!in_array($thisOrderCustID, $customerIDs)){
		$orderedIDs[] = $thisOrderCustID;
	}*/
}
echo sizeof($orderedID);
?>

