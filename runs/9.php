<?php
require_once('../app/Mage.php');
Mage::app();


$websiteId = Mage::app()->getWebsite()->getId();
$store = Mage::app()->getStore();
$customer=Mage::getModel("customer/customer");
$customer -> setWebsiteId($websiteId)
	-> setStore($store)
	->setFirstname('MMMMM')
	->setLastname('CCCCC')
	->setEmail('AAAAA@noemail.uncorked.com');
try{
	$customer->save();
}catch(Exception $e){
	echo "Error: ".$e->getMessage(). "\n";
}
echo $customer->getId()."\n";
$customer->setEmail($customer->getId()."@noemail.uncorked.com");
$customer->save();
echo $customer->getEmail()."\n";
?>

