<?php
require_once('../app/Mage.php');
Mage::app();

$products = Mage::getModel('catalog/product')->getCollection()
 ->addAttributeToSelect('*')
 ->addAttributeToSelect('status', array('eq' => Mage_Catalog_Model_Product_Status::STATUS_DISABLED));

$count=0;
echo "SKU| Name|ShortDesc|LongDesc|Price|Images\n";
foreach ($products as $prod){
 echo $prod->getSku()."|";
 echo $prod->getName()."|";
 echo $prod->getShortDescription()."|";
 echo $prod->getDescription()."|";
 echo $prod->getPrice()."|";
 echo count(Mage::getModel('catalog/product')->load($prod->getId())->getMediaGalleryImages());
 echo "\n";
 $count++;
}


echo "$count\n";
?>
