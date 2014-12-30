<?php
require_once('../app/Mage.php');
Mage::app();

        $category_definition_list = array(
                'wines-under-15',
                'wines-15-25',
                'wines-25-50',
                'wines-50-125',
                'wines-125',
                'gifts-under-50',
                'gifts-50-100',
                'gifts-over-100',
                'gifts-by-price',
                '90-ratings',
                'last-call',
                'sale-wines'
        );

$category_definitions = array();
foreach ($category_definition_list as $cat_key){
 $catId=$category = Mage::getModel('catalog/category')
        ->getCollection()
        ->addAttributeToFilter('url_key', $cat_key)
        ->getFirstItem()
	->getEntityId();
 echo $cat_key . " -> ". $catId."\n";
	$category_definitions [$cat_key] = $catId;
}

$id=1970;

$product=  Mage::getModel('catalog/product')->load($id);

echo $product->getName()."\n";
//var_dump( $product->getOrigData());

 $origIDs = $product->getCategoryIds();

	        if (array_intersect($origIDs, $category_definitions)){
	            $currentIDs = array_diff($origIDs,$category_definitions);
	            $product->setCategoryIds($currentIDs);
	            try{
	                //$product->save();
	                echo ' => Stripped successfully from '.implode(',', array_intersect($origIDs, $category_definitions));
	                echo "\n -----------------------------------------------------";
	            }
	            catch(Exception $e){
	            	echo ' => Could not be stripped from '.implode(',', array_intersect($origIDs, $category_definitions));
	            	echo "\n -----------------------------------------------------";
	                //throw $e->getMessage();
	            }
	            
	            unset($currentIDs);
	        }
	        else{
		        echo ' => Not currently in a slot category.';
	            echo "\n -----------------------------------------------------";
	        }

 $collections['90-ratings'][] = $product->getSku();
var_dump($collections);



            $keys = array_keys($collections);
            $i = 0;
            foreach ($collections as $collection){
                $category = $keys[$i];
                echo 'Category:'.$category."\n";
                echo 'Populated with: '.implode(',',$sku)."\n";
                foreach ($collection as $sku){
                    $product = Mage::getModel('catalog/product')->loadByAttribute('sku',$sku);
                    $currentIDs = $product->getCategoryIds();
                    $c = Mage::getModel('catalog/category')->load($category, 'url_key');
                    $currentIDs[] = $c->getId();
                    $product->setCategoryIds($currentIDs);
                    
                    try{
                        $product->save();
                        echo $sku.":".$c->getId()."\n";
                    }
                    catch(Exception $e){
                    	echo $sku.' could not be repopulated'."\n";

                        throw $e->getMessage();
                    }
                    unset($currentIDs);
                }
                $i++;
            }


echo "\n";
?>

