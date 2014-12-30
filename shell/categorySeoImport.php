<?php

require_once '../app/Mage.php';
Mage::app();

$csvPath = Mage::getBaseDir() . DS . "var" . DS . "import" . DS . "categorySeoImport.csv";
if(!file_exists($csvPath)) {
    die("FILE DOESN'T EXIST :: " . $csvPath );
}

$csvObj = new Varien_File_Csv();
$csvObj->setDelimiter("|");
$csvObj->setEnclosure('"');
$csvData = $csvObj->getData($csvPath);
$newCsvData = array();
$seoLog =  Mage::getBaseDir() . DS . "var" . DS . "log" . DS . "seoLog.log";
$handle = fopen($seoLog,"w");
echo "Log file is stored into " . $seoLog . "\n";
fwrite($handle, "total number of records to import is " . count($csvData) . "\n");
$count = 0;
if(count($csvData) > 1) {
    unset($csvData[0]);
}

foreach($csvData as $key=> $data) {   
   $collection = Mage::getResourceModel('core/url_rewrite_collection')
                  ->addFieldToFilter('request_path' , array('like' => '%'.  trim($data[0]) .'%'));
   $categoryId = $collection->getFirstItem()->getCategoryId();
   
   if($categoryId > 0) {
       $catModel = Mage::getModel('catalog/category')->load($categoryId);
       $catModel->setMetaKeywords(trim($data[1]))
                ->setMetaDescription(trim($data[2]))
                ->save();
       $msg = "Seo is updated for category id " . $categoryId . ", url :: " . $data[0] ."\n";  
       echo $msg;
       $count++;
   }
   else {
        $msg = "Category not found for url::  " . $data[0] ."\n";
        echo $msg;
   }
   fwrite($handle,$msg);
   $dataArray[] = $categoryId;
   $count++;
} 
fwrite($handle, $count . " is imported out of  " . count($csvData) . "\n");
echo "count " . count($dataArray);
exit;
$categoryCollection = Mage::getModel('catalog/category')->getCollection();
foreach($categoryCollection as $category) {
    $cat = Mage::getModel('catalog/category')->load($category->getEntityId());
    $collection = Mage::getResourceModel('core/url_rewrite_collection')->addFieldToFilter('request_path' , array('like' => '%'.$cat->getName() .'%'));
    print_r($collection->getFirstItem()->getRequestPath())  . "\n"  ;
    echo  $category->getName() . "\n";
    
   
    
}

