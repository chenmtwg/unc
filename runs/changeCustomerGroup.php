<?php
require_once('../app/Mage.php');
Mage::app();

$newGroupName="ABA Non-Verified";
$newGroupName="General";
$customerId=12594;


$customer=Mage::getModel("customer/customer")->load($customerId);
echo "customer:".$customer->getId().", Name:".$customer->getFirstname();
$custGrp=Mage::getModel("customer/group")->load($customer->getGroup_id());
echo ". Grp ".$custGrp->getId()."(".$custGrp->getCustomerGroupCode().")\n";
$newGroup=Mage::getModel("customer/group")->load($newGroupName, 'customer_group_code');
$customer->setGroupId($newGroup->getId())->save();
echo "NOW: customer:".$customer->getId().", Name:".$customer->getFirstname();
$custGrp=Mage::getModel("customer/group")->load($customer->getGroup_id());
echo ". Grp ".$custGrp->getId()."(".$custGrp->getCustomerGroupCode().")\n";
echo "\n";
?>
