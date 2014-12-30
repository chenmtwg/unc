<?php
require_once('../app/Mage.php');
Mage::app();


$customer =  Mage::getModel('customer/customer')->load(12569);

echo $customer -> getData('available_credits')."<br>";
echo $customer -> getData('last_date_earned_credits')."<br>";
echo $customer -> getData('credits_expiration')."<br>";

$d=array();

$d['available_credits']=$customer -> getData('available_credits');
$d['last_date_earned_credits']=$customer -> getData('last_date_earned_credits');
$d['credits_expiration']=$customer -> getData('credits_expiration');

echo $d['available_credits']."<br>";


$d2['available_credits']=50750;
$d2['last_date_earned_credits']='2014-06-03 14:25:12';
$d2['credits_expiration']='2';

echo  $d==$d2;
?>

