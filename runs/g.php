<?php
require_once('../app/Mage.php');
Mage::app();


$products =  Mage::getModel('catalog/product')->getCollection();
foreach ($products as $product){
	$sku=Mage::getModel('catalog/product')->load($product->getId())->getSku();
}


?>

