<?php
require_once('../app/Mage.php');
Mage::app();

$sku='0893407502011';
$id=  Mage::getModel('catalog/product')->getIdBySku($sku);
$product=  Mage::getModel('catalog/product')->load($id);

?>

