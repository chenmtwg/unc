<?php
require_once('../app/Mage.php');
Mage::app();

$orderId="1216153331";

$rewardsTransfer =  Mage::getModel('rewards/transfer');
echo "rewards\n";
$col = $rewardsTransfer->getCollection ()->addFilter('reference_type', TBT_Rewards_Model_Transfer_Reference::REFERENCE_ORDER) -> addFilter('reference_id', $orderId);
echo "get ".count($col)." transfers for order $orderId\n";


?>

