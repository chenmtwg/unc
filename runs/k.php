<?php
require_once('../app/Mage.php');
Mage::app();

$order =  Mage::getModel('sales/order')->load(13230);
ABACustomer($order,false, "ABA Non-Verified", "General","aba");

        function ABACustomer($order, $makeChanges=false, $toGrp="ABA Non-Verified", $frmGrp="General", $ABACategory="aba")
        {
                $toGrpId=Mage::getModel("customer/group")->load($toGrp, 'customer_group_code')->getId();
                $frmGrpId=Mage::getModel("customer/group")->load($frmGrp, 'customer_group_code')->getId();
                $ABACategoryId=Mage::getModel("catalog/category")->loadByAttribute('url_key', $ABACategory)->getId();
          if($toGrpId && $frmGrpId && $ABACategoryId) {
                $customer=Mage::getModel('customer/customer')->load($order->getCustomerId());
                $customerGroupId=$customer->getGroup_id();

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
                if($containsABA && $frmGrpId==$customerGroupId ){
                        echo ("Customer ".$customer->getEmail()." ".(($makeChanges)?"is being":"WILL BE")." moved to Group $toGrp");
//                        if($makeChanges){$customer->setGroupId($toGrpId)->save();}
                }
          }else{
                echo ("Shipcompliant_Licensees_Helper_Data->ABACustomer:  From Group, To Group or ABA Category can not be found ");
          }

        }

echo "\n";
?>
