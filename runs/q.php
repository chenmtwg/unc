<?php
require_once('../app/Mage.php');
Mage::app();
			$conversion = array(
	            'arizona' => '600',
	            'california' => '602',
	            'colorado' => '603',
	            'connecticut' => '604',
	            'dc' => '605',
	            'florida' => '607', 
	            'georgia' => '608',
	            'idaho' => '610',
	            'illinois' => '611',
	            'iowa' => '613',
	            'kansas' => '614',
	            'louisiana' => '616',
	            'maine' => '617',
	            'maryland' => '618',
	            'massachusetts' => '619',
	            'michigan' => '620',
	            'minnesota' => '621',
	            'missouri' => '623',
	            'nebraska' => '625',
	            'nevada' => '626',
	            'new-hampshire' => '627',
	            'new-jersey' => '628',
	            'new-mexico' => '629',
	            'new-york' => '630',
	            'north-carolina' => '631',
	            'north-dakota' => '632',
	            'ohio' => '633',
	            'oregon' => '635',
	            'south-carolina' => '638',
	            'tennessee' => '640',
	            'texas' => '641',
	            'vermont' => '643',
	            'virginia' => '644',
	            'washington' => '645',
	            'west-virginia' => '646',
	            'wisconsin' => '647',
	            'wyoming' => '648'
			);
                
	        foreach (array_keys($conversion) as $category){
				$categories[] = Mage::getModel('catalog/category')->load($category, 'url_key')->getId();
            }
 $categories[] = Mage::getModel('catalog/category')->load('all-states', 'url_key')->getId();
echo implode (",", $categories);
echo "\n";
$id=1970;

$product=  Mage::getModel('catalog/product')->load($id);
$states = explode(',',$product->getData('compliant_states'));
$origIDs=$product->getCategoryIds();
$category_definitions=$categories;
$b=array_intersect($origIDs, $category_definitions);

echo "orig = ".count($origIDs).". def = ".count($category_definitions).", removing= ".count($b)."\n";

$currentIDs=array_diff($origIDs, $category_definitions);

echo " new id = ".count($currentIDs)."\n";


$intersection=array_intersect($states,$conversion);
var_dump($intersection);





echo "\n"; ?>

