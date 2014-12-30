<?php
require_once('../app/Mage.php');
Mage::app();


//The order I want to check
    $order_id = 12704;

    //Get the list of items for your order
    $items = Mage::getModel('sales/order_item')
    ->getCollection()
    ->addFilter('order_id',array('eq'=>$order_id));

    //loop through each item
    foreach($items as $item){

        //if the item has not had a rule applied to it skip it
        if($item->getAppliedRuleIds() == '')continue;

        /*
        * I cant remember in the database they might be comma separated or space if multiple rules were applied
        * the getAppliedRuleIds() function is the one you want
        */
        foreach(explode(",",$item->getAppliedRuleIds()) as $ruleID){

            //Load the rule object
            $rule = Mage::getModel('catalogrule/rule')->load($ruleID);

            // Throw out some information like the rule name what product it was applied to

            echo "".$item->getSku()." had rule ".$rule->getName()."(".$item->getAppliedRuleIds().") applied \n";
        }

    }




?>

