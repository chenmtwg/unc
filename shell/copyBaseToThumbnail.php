<?php

require_once '../app/Mage.php';
Mage::app();

$productCollection = Mage::getModel('catalog/product')->getCollection();
foreach($productCollection as $product) {
    $productModel = Mage::getModel('catalog/product')->load($product->getId());
    if($productModel->getImage() != null && $productModel->getImage() != "" && $productModel->getImage() != "no_selection") {
        $productModel->setThumbnail($productModel->getImage())->save();
        echo $productModel->getName() . " thumnail image is changed \n";
    }


}
