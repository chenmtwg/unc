<?php
require_once('../app/Mage.php');
Mage::app();

$rules=Mage::helper ( 'rewards/transfer' );//->getSpendingRule()->getCollection();
echo get_class($rules)."<br>";
foreach ($rules as $rule){
	
	echo "  ".get_class($rule)."<br>";
}
?>

