<?php
require_once('../app/Mage.php');
Mage::app();

	$exclude_category=Mage::getModel('core/variable')->loadByCode('exclude_slot_category')->getValue('plain');
        $exclude_id=Mage::getModel('catalog/category')->loadByAttribute('name', $exclude_category)->getId();

echo "slot excludes $exclude_id<br>";

	$exclude_category=Mage::getModel('core/variable')->loadByCode('exclude_state_category')->getValue('plain');
        $exclude_id=Mage::getModel('catalog/category')->loadByAttribute('name', $exclude_category)->getId();

echo "state excludes $exclude_id\n";


?>
