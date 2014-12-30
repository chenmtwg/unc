<?php
require_once('../app/Mage.php');
Mage::app();

$collection =  Mage::getModel('customer/customer')->getCollection()->addAttributeTOSelect('*');

echo "Customers: ";
echo $collection->count();
echo "\n";
foreach ($collection as $customer){

        echo $customer->getData("member_number"). ":";
        echo $customer->getData("dob"). ":";
        echo $customer->getData("prefix"). ":";
        echo $customer->getData("firstname"). ":";
        echo $customer->getData("middlename"). ":";
        echo $customer->getData("lastname"). ":";

        $add=Mage::getModel('customer/address')->load($customer->default_billing);
        echo $add->getData("street").":";
        echo $add->getData("company").":";
        echo $add->getData("city").":";
        echo $add->getData("region").":";
        echo $add->getData("postcode").":";
        echo $add->getData("telephone").":";
        echo $customer->getData("email").":";

        echo "\n";
}


?>

