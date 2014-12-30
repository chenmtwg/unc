<?php
require '../app/Mage.php';
Mage::app();

 $products=Mage::getModel('catalog/product')->getCollection();
$noSku=0;$lowImg=0;
foreach ($products as $Product){
        $product= Mage::getModel('catalog/product')->load($Product->getId());
        $sku=$product->getSku();
        if($sku == ""){ echo "productID ".$product->getId()." NO SKU\n";
$noSku++;continue;
}
        $images = $product->getMediaGalleryImages();
        if(count($images)<2){echo "productID " . $product->getId() . ": SKU ".$product->getSku().":\t". count($images)." image \n";
$lowImg++;
}

}
echo "=== SUMMARY ==\n";
echo count($products)." active products found\n";
echo "$noSku products have invalid sku, $lowImg products has less than 2 images (assuming not having label)\n";
echo "\n";


?>
