<?php
require_once('../app/Mage.php');
Mage::app();


$brtOdrObs =  Mage::getModel('bronto_order/observer');

$brtOdrObs->processOrders(true);



?>

