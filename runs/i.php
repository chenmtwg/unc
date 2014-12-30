<?php
require_once('../app/Mage.php');
Mage::app();


$product =  Mage::getModel('catalog/product')->load(1970);
echo  htmlspecialchars($product->getName(),ENT_QUOTES, 'UTF-8')."\n";
echo  htmlspecialchars($product->getShortDescription(),ENT_QUOTES, 'UTF-8')."\n";

echo "\n";
?>
