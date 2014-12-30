<?php echo $_SERVER['SERVER_NAME']; ?>
<?php
echo "<br>";
require_once('../app/Mage.php');
Mage::app();

$orderID=$_GET['order'];

$order=Mage::getModel('sales/order')->loadByIncrementId($orderID);
$curSt=$order->getStatus();
echo $order->getStatusLabel();
$order->setStatus('pending');
$order->save();
echo "<br>";
echo $order->getStatusLabel();
echo "<br>";
$order->setStatus($curSt)->save();
if($order->getStatus() == $curSt){
	echo "Status reverted back";
}
Mage::log( "-- that was bullshit");
?>
