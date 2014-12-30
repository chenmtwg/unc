<?php

require_once '../app/Mage.php';
Mage::app();

$productCollection = Mage::getModel('catalog/product')->getCollection();
foreach($productCollection as $product) {
    $productModel = Mage::getModel('catalog/product')->load($product->getId());
    //echo $productModel->getSmallImage() . " ** " . $productModel->getThumbnail() ."\n";
    if($productModel->getSmallImage() != null && $productModel->getSmallImage() != "" && $productModel->getSmallImage() != "no_selection") {
        $productModel->setThumbnail($productModel->getSmallImage())->save();
        echo $productModel->getName() . " thumnail image is changed \n";
    }
            
            
}
