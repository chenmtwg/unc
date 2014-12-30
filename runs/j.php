<?php
require_once('../app/Mage.php');
Mage::app();
                $toGrp="ABA Non-Verified";
                $frmGrp="General";
                $ABACategory="aba";
                $toGrpId=Mage::getModel("customer/group")->load($toGrp, 'customer_group_code')->getId();
                $frmGrpId=Mage::getModel("customer/group")->load($frmGrp, 'customer_group_code')->getId();
                $ABACategoryId=Mage::getModel("catalog/category")->loadByAttribute('url_key', $ABACategory)->getId();


$order =  Mage::getModel('sales/order')->load(13230);
$items= $order->getAllVisibleItems();
$containsABA=false;
foreach ($items as $item)
{
	$itemCate=$item->getProduct()->getCategoryIds();
	if(in_array($ABACategoryId, $itemCate)){
		$containsABA=true;
		break;
	}
}
echo "CONTAINS ABA ITEM: ".$containsABA."\n";
	$curGrp=Mage::getModel('customer/customer')->load($order->getCustomerId())->getGroup_id();
	if($curGrp==$frmGrpId){
echo "Customer in ".$frmGrp." group\n";
	}
echo "\n";
?>
