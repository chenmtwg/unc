<?php echo $_SERVER['SERVER_NAME']; ?>
<?php
require_once('../app/Mage.php');
Mage::app();

$sku=$_GET['sku'];

$product=Mage::getModel('catalog/product')->loadByAttribute('sku', $sku);
if(!$product){
	echo "BAD SKU";
	return;
}

if($product->getTypeId() != 'bundle' ){
	echo "Not Bundle";
	return;
}

echo "this is a bundle<br>";

$childProducts = Mage::getModel('catalog/product_type_configurable')
                        ->getUsedProducts(null,$product);
echo sizeOf($childProducts);


/*
$ignore=Mage::getModel('core/variable')->loadByCode('exclude_slot_category')->getValue('plain');

echo $ignore . "<br>";

$do_not_display="Do Not Display";

$recorked = Mage::getModel('populator/populate');
$exclude_id=$recorked->pop();

$sku='0509212003507';// no marketplace sku
$sku='1129021202011';// with marketplace sku
$sku='MH131205IMP1';// mens health, belongs to hide_from_slot category
$sku=$_GET['sku'];

	$p = Mage::getModel('catalog/product')->loadByAttribute('sku', $sku);
if($p){
	$theSKU=$p->getSku();
	echo 'sku= '.$theSKU.'<br>';
	echo 'mktplaceSku= '.$p->getMarketplaceSku().'<br>';
	echo $p->getTypeId();

} else{
	echo '$p value is '.($p ? 'true' : 'false');
}

$idList=$p->getCategoryIds();
echo '<br> The product is in '.sizeof($idList).' categorie(s)<br>';	
foreach($idList as $categoryId){
	$c=Mage::getModel('catalog/category')->load($categoryId);
	echo '&nbsp;&nbsp; '. $categoryId. ' =>' . $c->getName().'<br>';
}
echo "==Excluding category : = $exclude_id ===<br>";
//$do_not_display_id=Mage::getModel('catalog/category')->loadByAttribute('name', $do_not_display)->getId();
$do_not_display_id=$exclude_id;
echo 'include: '.((in_array($do_not_display_id, $idList))?'no':'yes').'<br>';
*/

	
?>
