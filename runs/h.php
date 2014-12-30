<?php echo $_SERVER['SERVER_NAME']; ?>
<?php
require_once('../app/Mage.php');
Mage::app();


$products=Mage::getModel('catalog/product')->getCollection();
foreach($products as $Product){
	$product= Mage::getModel('catalog/product')->load($Product->getId());
	$review=$product->getData("professional_reviews");
	if($review != null){
		echo $product->getSku().":".count($review).":".$review."\n";
	}
}


echo "\n++++++++++++++++++++++++++============\n";
/*$ids=Array(1373,1580,1617,1621,1640,1661,1666,1699,1744,1746,1759);

foreach ($ids as $id){
	$product=Mage::getModel('catalog/product')->load($id);
	echo $product->getSku().":".$product->getStatus()."\n";
}

echo "\n++++++++++++++++++++++++++============\n";

$category="gifts-by-price";

 $c = Mage::getModel('catalog/category')->load($category, 'url_key');
echo "$category id is ";
echo $c->getId();


echo "\n++++++++++++++++++++++++++============\n";
 $products=Mage::getModel('catalog/product')->getCollection();
echo count($products)." products \n";
foreach ($products as $product){
	$sku=$product->getSku();
//	if($sku == ""){ echo $product->getId()." NO SKU\n"; continue;}
	$images = Mage::getModel('catalog/product')->load($product->getId())->getMediaGalleryImages();
//	if(count($images)<2){echo "productID " . $product->getId() . ": SKU ".$product->getSku().":\t". count($images)." images \n";}
	echo $product -> getStatus()."\n";
}
*/

echo "\n";
?>
