<?php
require_once('../app/Mage.php');
Mage::app();

$myAttri= Mage::getModel('eav/entity_attribute')->loadByCode('catalog_product', 'compliant_state');
echo $myAttri->getAttributId();
echo "<br>";

//$myCategory =  Mage::getModel('catalog/category')->loadByAttribute('url_key', 'gifts-by-price');
$myCategory =  Mage::getModel('catalog/category')->loadByAttribute('url_key', 'all-states');

echo "categoryID: ";
echo $myCategory->getID();
echo "<br>subCategories: ";

$subCategories=$myCategory->getChildren();
$allSubs=explode(",",$subCategories);
echo $subCategories;
echo "<br>--";
foreach ($allSubs as $catId){
	echo  $catId ."  ";
	echo Mage::getModel('catalog/category')->load($catId)->getUrlKey();
	echo "<br>";
}
echo "<br>";
$myCategory =  Mage::getModel('catalog/category')->loadByAttribute('url_key', 'vermont');
$parent= $myCategory->parent_id;

echo Mage::getModel('catalog/category')->load($parent)->getUrlKey();
?>

