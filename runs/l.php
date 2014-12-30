<?php
require_once('../app/Mage.php');
Mage::app();
echo "---\n";
$dtstp=1410138334;show($dtstp);
$dtstp=1405560318;show($dtstp);

function show($dtstp){echo "integer:\t$dtstp\n";
echo "native:\t". gmdate("Y-m-d\tH:i:s", $dtstp);
echo "\n";
echo "format:\t". $format=Mage_Core_Model_Locale::FORMAT_TYPE_MEDIUM;
echo "\n";
$one=Mage::helper('core');
echo "converted:\t".$one->formatDate($dtstp, $format, true);
echo "\n";

echo " stp is zend date" . ($dtstp instanceof Zend_Date);
echo "\n";
echo " strtot:\t" . strtotime($dtstp);
echo "\n";
echo "====\n";
}
?>
