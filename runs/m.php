<?php
require_once('../app/Mage.php');
Mage::app();



// Change to your postcode / country.
$zipcode = '60015';
$country = 'US';

// Update the cart's quote.
$cart = Mage::getSingleton('checkout/cart');
$address = $cart->getQuote()->getShippingAddress();
$address->setCountryId($country)
        ->setPostcode($zipcode)
        ->setCollectShippingrates(true);
$cart->save();
// Find if our shipping has been included.
$rates = $address->collectShippingRates()
                 ->getGroupedAllShippingRates();

foreach ($rates as $carrier) {
    foreach ($carrier as $rate) {
        print_r($rate->getData());
    }
}


echo "=======================\n";
$carriers = Mage::getStoreConfig('carriers', Mage::app()->getStore()->getId());
foreach ($carriers as $carrierCode => $carrierConfig) {
if($carrierConfig["active"] == "1")
print_R($carrierConfig);
}
?>

