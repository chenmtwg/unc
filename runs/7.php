<?php
require_once('../app/Mage.php');
Mage::app();
echo "1\n";

$product =  Mage::getModel('catalog/product')->loadByAttribute('sku', "0030808002010");

echo $product->getData('compliant_states');


?>

