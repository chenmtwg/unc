#!/bin/bash
# Patch apllying tool template
# v0.1.2
# (c) Copyright 2013. Magento Inc.
#
# DO NOT CHANGE ANY LINE IN THIS FILE.

# 1. Check required system tools
_check_installed_tools() {
    local missed=""

    until [ -z "$1" ]; do
        type -t $1 >/dev/null 2>/dev/null
        if (( $? != 0 )); then
            missed="$missed $1"
        fi
        shift
    done

    echo $missed
}

REQUIRED_UTILS='sed patch'
MISSED_REQUIRED_TOOLS=`_check_installed_tools $REQUIRED_UTILS`
if (( `echo $MISSED_REQUIRED_TOOLS | wc -w` > 0 ));
then
    echo -e "Error! Some required system tools, that are utilized in this sh script, are not installed:\nTool(s) \"$MISSED_REQUIRED_TOOLS\" is(are) missed, please install it(them)."
    exit 1
fi

# 2. Determine bin path for system tools
CAT_BIN=`which cat`
PATCH_BIN=`which patch`
SED_BIN=`which sed`
PWD_BIN=`which pwd`
BASENAME_BIN=`which basename`

BASE_NAME=`$BASENAME_BIN "$0"`

# 3. Help menu
if [ "$1" = "-?" -o "$1" = "-h" -o "$1" = "--help" ]
then
    $CAT_BIN << EOFH
Usage: sh $BASE_NAME [--help] [-R|--revert] [--list]
Apply embedded patch.

-R, --revert    Revert previously applied embedded patch
--list          Show list of applied patches
--help          Show this help message
EOFH
    exit 0
fi

# 4. Get "revert" flag and "list applied patches" flag
REVERT_FLAG=
SHOW_APPLIED_LIST=0
if [ "$1" = "-R" -o "$1" = "--revert" ]
then
    REVERT_FLAG=-R
fi
if [ "$1" = "--list" ]
then
    SHOW_APPLIED_LIST=1
fi

# 5. File pathes
CURRENT_DIR=`$PWD_BIN`/
APP_ETC_DIR=`echo "$CURRENT_DIR""app/etc/"`
APPLIED_PATCHES_LIST_FILE=`echo "$APP_ETC_DIR""applied.patches.list"`

# 6. Show applied patches list if requested
if [ "$SHOW_APPLIED_LIST" -eq 1 ] ; then
    echo -e "Applied/reverted patches list:"
    if [ -e "$APPLIED_PATCHES_LIST_FILE" ]
    then
        if [ ! -r "$APPLIED_PATCHES_LIST_FILE" ]
        then
            echo "ERROR: \"$APPLIED_PATCHES_LIST_FILE\" must be readable so applied patches list can be shown."
            exit 1
        else
            $SED_BIN -n "/SUP-\|SUPEE-/p" $APPLIED_PATCHES_LIST_FILE
        fi
    else
        echo "<empty>"
    fi
    exit 0
fi

# 7. Check applied patches track file and its directory
_check_files() {
    if [ ! -e "$APP_ETC_DIR" ]
    then
        echo "ERROR: \"$APP_ETC_DIR\" must exist for proper tool work."
        exit 1
    fi

    if [ ! -w "$APP_ETC_DIR" ]
    then
        echo "ERROR: \"$APP_ETC_DIR\" must be writeable for proper tool work."
        exit 1
    fi

    if [ -e "$APPLIED_PATCHES_LIST_FILE" ]
    then
        if [ ! -w "$APPLIED_PATCHES_LIST_FILE" ]
        then
            echo "ERROR: \"$APPLIED_PATCHES_LIST_FILE\" must be writeable for proper tool work."
            exit 1
        fi
    fi
}

_check_files

# 8. Apply/revert patch
# Note: there is no need to check files permissions for files to be patched.
# "patch" tool will not modify any file if there is not enough permissions for all files to be modified.
# Get start points for additional information and patch data
SKIP_LINES=$((`$SED_BIN -n "/^__PATCHFILE_FOLLOWS__$/=" "$CURRENT_DIR""$BASE_NAME"` + 1))
ADDITIONAL_INFO_LINE=$(($SKIP_LINES - 3))p

_apply_revert_patch() {
    DRY_RUN_FLAG=
    if [ "$1" = "dry-run" ]
    then
        DRY_RUN_FLAG=" --dry-run"
        echo "Checking if patch can be applied/reverted successfully..."
    fi
    echo "$SED_BIN -e '1,/^__PATCHFILE_FOLLOWS__$/d' "$CURRENT_DIR""$BASE_NAME" | $PATCH_BIN $DRY_RUN_FLAG $REVERT_FLAG -p0"
    PATCH_APPLY_REVERT_RESULT=`$SED_BIN -e '1,/^__PATCHFILE_FOLLOWS__$/d' "$CURRENT_DIR""$BASE_NAME" | $PATCH_BIN $DRY_RUN_FLAG $REVERT_FLAG -p0`
    PATCH_APPLY_REVERT_STATUS=$?
    if [ $PATCH_APPLY_REVERT_STATUS -eq 1 ] ; then
        echo -e "ERROR: Patch can't be applied/reverted successfully.\n\n$PATCH_APPLY_REVERT_RESULT"
        exit 1
    fi
    if [ $PATCH_APPLY_REVERT_STATUS -eq 2 ] ; then
        echo -e "ERROR: Patch can't be applied/reverted successfully."
        exit 2
    fi
}

REVERTED_PATCH_MARK=
if [ -n "$REVERT_FLAG" ]
then
    REVERTED_PATCH_MARK=" | REVERTED"
fi

_apply_revert_patch dry-run
_apply_revert_patch

# 9. Track patch applying result
echo "Patch was applied/reverted successfully."
ADDITIONAL_INFO=`$SED_BIN -n ""$ADDITIONAL_INFO_LINE"" "$CURRENT_DIR""$BASE_NAME"`
APPLIED_REVERTED_ON_DATE=`date -u +"%F %T UTC"`
APPLIED_REVERTED_PATCH_INFO=`echo -n "$APPLIED_REVERTED_ON_DATE"" | ""$ADDITIONAL_INFO""$REVERTED_PATCH_MARK"`
echo -e "$APPLIED_REVERTED_PATCH_INFO\n$PATCH_APPLY_REVERT_RESULT\n\n" >> "$APPLIED_PATCHES_LIST_FILE"

exit 0


SUPEE-1041 ALL | EE_1.12.0.2 | v2 | 447dbd6c6932d6ed1e2baeda49d9426b1a309050 | Tue Jul 1 17:27:24 2014 -0700 | v1.12.0.2..HEAD

__PATCHFILE_FOLLOWS__
diff --git app/code/core/Mage/Adminhtml/controllers/Catalog/ProductController.php app/code/core/Mage/Adminhtml/controllers/Catalog/ProductController.php
index 75f0fe0..caa53f2 100644
--- app/code/core/Mage/Adminhtml/controllers/Catalog/ProductController.php
+++ app/code/core/Mage/Adminhtml/controllers/Catalog/ProductController.php
@@ -718,8 +718,8 @@ class Mage_Adminhtml_Catalog_ProductController extends Mage_Adminhtml_Controller
                  * Do copying data to stores
                  */
                 if (isset($data['copy_to_stores'])) {
-                    foreach ($data['copy_to_stores'] as $storeTo=>$storeFrom) {
-                        $newProduct = Mage::getModel('catalog/product')
+                    foreach ($data['copy_to_stores'] as $storeTo => $storeFrom) {
+                        Mage::getModel('catalog/product')
                             ->setStoreId($storeFrom)
                             ->load($productId)
                             ->setStoreId($storeTo)
@@ -727,8 +727,6 @@ class Mage_Adminhtml_Catalog_ProductController extends Mage_Adminhtml_Controller
                     }
                 }
 
-                Mage::getModel('catalogrule/rule')->applyAllRulesToProduct($productId);
-
                 $this->_getSession()->addSuccess($this->__('The product has been saved.'));
             } catch (Mage_Core_Exception $e) {
                 $this->_getSession()->addError($e->getMessage())
diff --git app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Eav/Abstract.php app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Eav/Abstract.php
index 6df910e..9490de8 100755
--- app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Eav/Abstract.php
+++ app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Eav/Abstract.php
@@ -99,9 +99,7 @@ abstract class Mage_Catalog_Model_Resource_Product_Indexer_Eav_Abstract
             $adapter->delete($this->getMainTable(), $where);
 
             // insert new index
-            $this->useDisableKeys(false);
             $this->insertFromTable($this->getIdxTable(), $this->getMainTable());
-            $this->useDisableKeys(true);
 
             $adapter->commit();
         } catch (Exception $e) {
diff --git app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price.php app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price.php
index 306131c..ad75151 100755
--- app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price.php
+++ app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price.php
@@ -131,9 +131,7 @@ class Mage_Catalog_Model_Resource_Product_Indexer_Price extends Mage_Index_Model
             $write->delete($this->getIdxTable(), $where);
 
             // insert new index
-            $this->useDisableKeys(false);
             $this->insertFromTable($this->getIdxTable(), $this->getMainTable());
-            $this->useDisableKeys(true);
 
             $this->commit();
         } catch (Exception $e) {
diff --git app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price/Default.php app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price/Default.php
index db68cf0..a89e262 100755
--- app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price/Default.php
+++ app/code/core/Mage/Catalog/Model/Resource/Product/Indexer/Price/Default.php
@@ -136,11 +136,9 @@ class Mage_Catalog_Model_Resource_Product_Indexer_Price_Default
      */
     public function reindexEntity($entityIds)
     {
-        $this->useDisableKeys(false);
         $this->_prepareFinalPriceData($entityIds);
         $this->_applyCustomOption();
         $this->_movePriceDataToIndexTable();
-        $this->useDisableKeys(true);
 
         return $this;
     }
diff --git app/code/core/Mage/CatalogRule/Model/Observer.php app/code/core/Mage/CatalogRule/Model/Observer.php
index b16251c..f7db54a 100644
--- app/code/core/Mage/CatalogRule/Model/Observer.php
+++ app/code/core/Mage/CatalogRule/Model/Observer.php
@@ -41,6 +41,7 @@ class Mage_CatalogRule_Model_Observer
      * Apply all catalog price rules for specific product
      *
      * @param   Varien_Event_Observer $observer
+     *
      * @return  Mage_CatalogRule_Model_Observer
      */
     public function applyAllRulesOnProduct($observer)
@@ -51,15 +52,25 @@ class Mage_CatalogRule_Model_Observer
         }
 
         $productWebsiteIds = $product->getWebsiteIds();
-
-        $rules = Mage::getModel('catalogrule/rule')->getCollection()
+        /**
+         * @var Mage_CatalogRule_Model_Rule $ruleModel
+         */
+        $ruleModel = Mage::getModel('catalogrule/rule');
+        $ruleCollection = $ruleModel->getCollection()
             ->addFieldToFilter('is_active', 1);
 
-        foreach ($rules as $rule) {
+        if (!$ruleCollection->count()) {
+            return $this;
+        }
+
+        foreach ($ruleCollection as $rule) {
             $websiteIds = array_intersect($productWebsiteIds, $rule->getWebsiteIds());
             $rule->applyToProduct($product, $websiteIds);
         }
 
+        $ruleModel->getResource()->applyAllRulesForDateRange(null, null, $product);
+        $ruleModel->updateAfterApplyToProduct($product);
+
         return $this;
     }
 
diff --git app/code/core/Mage/CatalogRule/Model/Resource/Rule.php app/code/core/Mage/CatalogRule/Model/Resource/Rule.php
index 42738c1..85b6751 100755
--- app/code/core/Mage/CatalogRule/Model/Resource/Rule.php
+++ app/code/core/Mage/CatalogRule/Model/Resource/Rule.php
@@ -116,26 +116,24 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
      * @param Mage_CatalogRule_Model_Rule $rule
      *
      * @return Mage_CatalogRule_Model_Resource_Rule
+     *
+     * @throws Exception
      */
     public function updateRuleProductData(Mage_CatalogRule_Model_Rule $rule)
     {
         $ruleId = $rule->getId();
-        $write  = $this->_getWriteAdapter();
-        $write->beginTransaction();
+        $writeAdapter = $this->_getWriteAdapter();
+        $writeAdapter->beginTransaction();
+
+        $whereExpr = array();
+        $whereExpr[] = $writeAdapter->quoteInto('rule_id = ?', $ruleId, Zend_Db::INT_TYPE);
         if ($rule->getProductsFilter()) {
-            $write->delete(
-                $this->getTable('catalogrule/rule_product'),
-                array(
-                    'rule_id=?' => $ruleId,
-                    'product_id IN (?)' => $rule->getProductsFilter()
-                )
-            );
-        } else {
-            $write->delete($this->getTable('catalogrule/rule_product'), $write->quoteInto('rule_id=?', $ruleId));
+            $whereExpr[] = $writeAdapter->quoteInto('product_id IN (?)', $rule->getProductsFilter(), Zend_Db::INT_TYPE);
         }
+        $writeAdapter->delete($this->getTable('catalogrule/rule_product'), $whereExpr);
 
         if (!$rule->getIsActive()) {
-            $write->commit();
+            $writeAdapter->commit();
             return $this;
         }
 
@@ -162,9 +160,8 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
         $subActionAmount = $rule->getSubDiscountAmount();
         $actionStop = $rule->getStopRulesProcessing();
 
-        $rows = array();
-
         try {
+            $rows = array();
             foreach ($productIds as $productId) {
                 foreach ($websiteIds as $websiteId) {
                     foreach ($customerGroupIds as $customerGroupId) {
@@ -183,24 +180,23 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
                             'sub_discount_amount' => $subActionAmount,
                         );
 
-                        if (count($rows) == 1000) {
-                            $write->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
+                        if (count($rows) >= 1000) {
+                            $writeAdapter->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
                             $rows = array();
                         }
                     }
                 }
             }
             if (!empty($rows)) {
-               $write->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
+               $writeAdapter->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
             }
 
-            $write->commit();
+            $writeAdapter->commit();
         } catch (Exception $e) {
-            $write->rollback();
+            $writeAdapter->rollback();
             throw $e;
         }
 
-
         return $this;
     }
 
@@ -215,7 +211,7 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
     {
         $read = $this->_getReadAdapter();
         $select = $read->select()->from($this->getTable('catalogrule/rule_product'), 'product_id')
-            ->where('rule_id=?', $ruleId);
+            ->where('rule_id = ?', $ruleId);
 
         return $read->fetchCol($select);
     }
@@ -225,38 +221,40 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
      *
      * @param int|string $fromDate
      * @param int|string $toDate
+     * @param int|string|Zend_Date $date
      * @param int|null $productId
      *
      * @return Mage_CatalogRule_Model_Resource_Rule
      */
     public function removeCatalogPricesForDateRange($fromDate, $toDate, $productId = null)
     {
-        $write = $this->_getWriteAdapter();
-        $conds = array();
-        $cond = $write->quoteInto('rule_date between ?', $this->formatDate($fromDate));
-        $cond = $write->quoteInto($cond.' and ?', $this->formatDate($toDate));
-        $conds[] = $cond;
+        $writeAdapter = $this->_getWriteAdapter();
+        $cond = $writeAdapter->quoteInto('rule_date BETWEEN ?', $this->formatDate($fromDate));
+        $cond = $writeAdapter->quoteInto($cond . ' AND ?', $this->formatDate($toDate));
+        $deleteConditions = array($cond);
         if (!is_null($productId)) {
-            $conds[] = $write->quoteInto('product_id=?', $productId);
+            $deleteConditions[] = $writeAdapter->quoteInto('product_id = ?', $productId);
         }
 
         /**
          * Add information about affected products
          * It can be used in processes which related with product price (like catalog index)
          */
-        $select = $this->_getWriteAdapter()->select()
+        $select = $writeAdapter->select()
             ->from($this->getTable('catalogrule/rule_product_price'), 'product_id')
-            ->where(implode(' AND ', $conds))
+            ->where(implode(' AND ', $deleteConditions))
             ->group('product_id');
 
-        $replace = $write->insertFromSelect(
+        $replace = $writeAdapter->insertFromSelect(
             $select,
             $this->getTable('catalogrule/affected_product'),
             array('product_id'),
             true
         );
-        $write->query($replace);
-        $write->delete($this->getTable('catalogrule/rule_product_price'), $conds);
+
+        $writeAdapter->query($replace);
+        $writeAdapter->delete($this->getTable('catalogrule/rule_product_price'), $deleteConditions);
+
         return $this;
     }
 
@@ -270,13 +268,13 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
      */
     public function deleteOldData($date, $productId = null)
     {
-        $write = $this->_getWriteAdapter();
-        $conds = array();
-        $conds[] = $write->quoteInto('rule_date<?', $this->formatDate($date));
+        $deleteConditions = array('rule_date < ?' => $this->formatDate($date));
         if (!is_null($productId)) {
-            $conds[] = $write->quoteInto('product_id=?', $productId);
+            $deleteConditions['product_id = ?'] = $productId;
         }
-        $write->delete($this->getTable('catalogrule/rule_product_price'), $conds);
+
+        $this->_getWriteAdapter()->delete($this->getTable('catalogrule/rule_product_price'), $deleteConditions);
+
         return $this;
     }
 
@@ -306,11 +304,11 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
         $select = $read->select()
             ->from(array('rp' => $this->getTable('catalogrule/rule_product')))
             ->where($read->quoteInto('rp.from_time = 0 or rp.from_time <= ?', $toDate)
-            . ' OR ' . $read->quoteInto('rp.to_time = 0 or rp.to_time >= ?', $fromDate))
+            . ' OR ' .$read->quoteInto('rp.to_time = 0 or rp.to_time >= ?', $fromDate))
             ->order(array('rp.website_id', 'rp.customer_group_id', 'rp.product_id', 'rp.sort_order', 'rp.rule_id'));
 
         if (!is_null($productId)) {
-            $select->where('rp.product_id=?', $productId);
+            $select->where('rp.product_id = ?', $productId);
         }
 
         /**
@@ -324,13 +322,13 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
             . ') and %1$s.store_id=%2$s';
 
         $select->join(
-            array('pp_default'=>$priceTable),
+            array('pp_default' => $priceTable),
             sprintf($joinCondition, 'pp_default', Mage_Core_Model_App::ADMIN_STORE_ID),
-            array('default_price'=>'pp_default.value')
+            array('default_price' => 'pp_default.value')
         );
 
         if ($websiteId !== null) {
-            $website  = Mage::app()->getWebsite($websiteId);
+            $website = Mage::app()->getWebsite($websiteId);
             $defaultGroup = $website->getDefaultGroup();
             if ($defaultGroup instanceof Mage_Core_Model_Store_Group) {
                 $storeId = $defaultGroup->getDefaultStoreId();
@@ -340,18 +338,18 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
 
             $select->joinInner(
                 array('product_website' => $this->getTable('catalog/product_website')),
-                'product_website.product_id=rp.product_id ' .
-                'AND rp.website_id=product_website.website_id ' .
-                'AND product_website.website_id='.$websiteId,
+                'product_website.product_id = rp.product_id ' .
+                'AND rp.website_id = product_website.website_id ' .
+                'AND product_website.website_id = ' . $websiteId,
                 array()
             );
 
-            $tableAlias = 'pp'.$websiteId;
-            $fieldAlias = 'website_'.$websiteId.'_price';
+            $tableAlias = 'pp' . $websiteId;
+            $fieldAlias = 'website_' . $websiteId . '_price';
             $select->joinLeft(
                 array($tableAlias=>$priceTable),
                 sprintf($joinCondition, $tableAlias, $storeId),
-                array($fieldAlias=>$tableAlias.'.value')
+                array($fieldAlias=>$tableAlias . '.value')
             );
         } else {
             foreach (Mage::app()->getWebsites() as $website) {
@@ -383,34 +381,35 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
      *
      * @param int|string|null $fromDate
      * @param int|string|null $toDate
-     * @param int $productId
+     * @param int|null $productId
+     *
      *
      * @return Mage_CatalogRule_Model_Resource_Rule
+     *
+     * @throws Exception
      */
     public function applyAllRulesForDateRange($fromDate = null, $toDate = null, $productId = null)
     {
-        $write = $this->_getWriteAdapter();
-        $write->beginTransaction();
+        $writeAdapter = $this->_getWriteAdapter();
+        $writeAdapter->beginTransaction();
 
         Mage::dispatchEvent('catalogrule_before_apply', array('resource' => $this));
 
         $clearOldData = false;
         if ($fromDate === null) {
-            $fromDate = mktime(0,0,0,date('m'),date('d')-1);
+            $fromDate = mktime(0, 0, 0, date('m'), date('d') - 1);
             /**
              * If fromDate not specified we can delete all data oldest than 1 day
              * We have run it for clear table in case when cron was not installed
              * and old data exist in table
              */
             $clearOldData = true;
-        }
-        if (is_string($fromDate)) {
+        } elseif (is_string($fromDate)) {
             $fromDate = strtotime($fromDate);
         }
         if ($toDate === null) {
-            $toDate = mktime(0,0,0,date('m'),date('d')+1);
-        }
-        if (is_string($toDate)) {
+            $toDate = mktime(0, 0, 0, date('m'), date('d') + 1);
+        } elseif (is_string($toDate)) {
             $toDate = strtotime($toDate);
         }
 
@@ -425,8 +424,6 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
             $this->deleteOldData($fromDate, $productId);
         }
 
-        $dayPrices  = array();
-
         try {
             /**
              * Update products rules prices per each website separately
@@ -457,9 +454,9 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
                     /**
                      * Build prices for each day
                      */
-                    for ($time=$fromDate; $time<=$toDate; $time+=self::SECONDS_IN_DAY) {
-                        if (($ruleData['from_time']==0 || $time >= $ruleData['from_time'])
-                            && ($ruleData['to_time']==0 || $time <=$ruleData['to_time'])
+                    for ($time = $fromDate; $time <= $toDate; $time += self::SECONDS_IN_DAY) {
+                        if (($ruleData['from_time'] == 0 || $time >= $ruleData['from_time'])
+                            && ($ruleData['to_time'] == 0 || $time <= $ruleData['to_time'])
                         ) {
                             $priceKey = $time . '_' . $productKey;
 
@@ -499,31 +496,30 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
                     }
 
                     $prevKey = $productKey;
-                    if (count($dayPrices)>1000) {
+                    if (count($dayPrices) >= 1000) {
                         $this->_saveRuleProductPrices($dayPrices);
                         $dayPrices = array();
                     }
                 }
                 $this->_saveRuleProductPrices($dayPrices);
             }
-            $this->_saveRuleProductPrices($dayPrices);
 
-            $write->delete($this->getTable('catalogrule/rule_group_website'), array());
+            $writeAdapter->delete($this->getTable('catalogrule/rule_group_website'));
 
             $timestamp = Mage::getModel('core/date')->gmtTimestamp();
 
-            $select = $write->select()
+            $select = $writeAdapter->select()
                 ->distinct(true)
                 ->from(
                     $this->getTable('catalogrule/rule_product'),
                     array('rule_id', 'customer_group_id', 'website_id')
                 )->where("{$timestamp} >= from_time AND (({$timestamp} <= to_time AND to_time > 0) OR to_time = 0)");
             $query = $select->insertFromSelect($this->getTable('catalogrule/rule_group_website'));
-            $write->query($query);
+            $writeAdapter->query($query);
 
-            $write->commit();
+            $writeAdapter->commit();
         } catch (Exception $e) {
-            $write->rollback();
+            $writeAdapter->rollback();
             throw $e;
         }
 
@@ -534,7 +530,7 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
             'product' => $product,
             'product_condition' => $productCondition
         ));
-        $write->delete($this->getTable('catalogrule/affected_product'));
+        $writeAdapter->delete($this->getTable('catalogrule/affected_product'));
 
         return $this;
     }
@@ -553,8 +549,8 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
             $productPrice = $productData['rule_price'];
         } else {
             $websiteId = $ruleData['website_id'];
-            if (isset($ruleData['website_'.$websiteId.'_price'])) {
-                $productPrice = $ruleData['website_'.$websiteId.'_price'];
+            if (isset($ruleData['website_' . $websiteId . '_price'])) {
+                $productPrice = $ruleData['website_' . $websiteId . '_price'];
             } else {
                 $productPrice = $ruleData['default_price'];
             }
@@ -606,8 +602,7 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
     }
 
     /**
-     * Get catalog rules product price for specific date, website and
-     * customer group
+     * Get catalog rules product price for specific date, website and customer group
      *
      * @param int|string $date
      * @param int $wId
@@ -645,7 +640,8 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
             ->where('rule_date = ?', $this->formatDate($date, false))
             ->where('website_id = ?', $websiteId)
             ->where('customer_group_id = ?', $customerGroupId)
-            ->where('product_id IN(?)', $productIds);
+            ->where('product_id IN (?)', $productIds);
+
         return $adapter->fetchPairs($select);
     }
 
@@ -689,9 +685,9 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
         $read = $this->_getReadAdapter();
         $select = $read->select()
             ->from($this->getTable('catalogrule/rule_product_price'), '*')
-            ->where('rule_date=?', $this->formatDate($date, false))
-            ->where('website_id=?', $wId)
-            ->where('product_id=?', $pId);
+            ->where('rule_date = ?', $this->formatDate($date, false))
+            ->where('website_id = ?', $wId)
+            ->where('product_id = ?', $pId);
 
         return $read->fetchAll($select);
     }
@@ -704,6 +700,8 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
      * @param array $websiteIds
      *
      * @return Mage_CatalogRule_Model_Resource_Rule
+     *
+     * @throws Exception
      */
     public function applyToProduct($rule, $product, $websiteIds)
     {
@@ -714,19 +712,19 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
         $ruleId    = $rule->getId();
         $productId = $product->getId();
 
-        $write = $this->_getWriteAdapter();
-        $write->beginTransaction();
+        $writeAdapter = $this->_getWriteAdapter();
+        $writeAdapter->beginTransaction();
 
-        $write->delete($this->getTable('catalogrule/rule_product'), array(
-            $write->quoteInto('rule_id=?', $ruleId),
-            $write->quoteInto('product_id=?', $productId),
+        $writeAdapter->delete($this->getTable('catalogrule/rule_product'), array(
+            'rule_id = ?' => $ruleId,
+            'product_id = ?' => $productId
         ));
 
         if (!$rule->getConditions()->validate($product)) {
-            $write->delete($this->getTable('catalogrule/rule_product_price'), array(
-                $write->quoteInto('product_id=?', $productId),
-            ));
-            $write->commit();
+            $writeAdapter->delete($this->getTable('catalogrule/rule_product_price'),
+                array('product_id = ?' => $productId));
+            $writeAdapter->commit();
+
             return $this;
         }
 
@@ -760,24 +758,22 @@ class Mage_CatalogRule_Model_Resource_Rule extends Mage_Rule_Model_Resource_Abst
                         'sub_discount_amount' => $subActionAmount,
                     );
 
-                    if (count($rows) == 1000) {
-                        $write->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
+                    if (count($rows) >= 1000) {
+                        $writeAdapter->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
                         $rows = array();
                     }
                 }
             }
 
             if (!empty($rows)) {
-                $write->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
+               $writeAdapter->insertMultiple($this->getTable('catalogrule/rule_product'), $rows);
             }
         } catch (Exception $e) {
-            $write->rollback();
+            $writeAdapter->rollback();
             throw $e;
         }
 
-        $this->applyAllRulesForDateRange(null, null, $product);
-
-        $write->commit();
+        $writeAdapter->commit();
 
         return $this;
     }
diff --git app/code/core/Mage/CatalogRule/Model/Rule.php app/code/core/Mage/CatalogRule/Model/Rule.php
index 65249d0..c52ab4d 100644
--- app/code/core/Mage/CatalogRule/Model/Rule.php
+++ app/code/core/Mage/CatalogRule/Model/Rule.php
@@ -266,12 +266,29 @@ class Mage_CatalogRule_Model_Rule extends Mage_Rule_Model_Abstract
     /**
      * Apply all price rules to product
      *
+     * @deprecated
+     *
      * @param  int|Mage_Catalog_Model_Product $product
+     *
      * @return Mage_CatalogRule_Model_Rule
      */
     public function applyAllRulesToProduct($product)
     {
         $this->_getResource()->applyAllRulesForDateRange(NULL, NULL, $product);
+        $this->updateAfterApplyToProduct($product);
+
+        return $this;
+    }
+
+    /**
+     * Update cache and index after apply rules to product
+     *
+     * @param  Mage_Catalog_Model_Product|int product
+     *
+     * @return Mage_CatalogRule_Model_Rule
+     */
+    public function updateAfterApplyToProduct($product)
+    {
         $this->_invalidateCache();
 
         if ($product instanceof Mage_Catalog_Model_Product) {
@@ -287,6 +304,8 @@ class Mage_CatalogRule_Model_Rule extends Mage_Rule_Model_Abstract
                 Mage_Catalog_Model_Product_Indexer_Price::EVENT_TYPE_REINDEX_PRICE
             );
         }
+
+        return $this;
     }
 
     /**
@@ -380,6 +399,7 @@ class Mage_CatalogRule_Model_Rule extends Mage_Rule_Model_Abstract
             $types = $types->asArray();
             Mage::app()->getCacheInstance()->invalidateType(array_keys($types));
         }
+
         return $this;
     }
 
diff --git app/code/core/Mage/Index/Model/Indexer.php app/code/core/Mage/Index/Model/Indexer.php
index 6698f3f..a868f8b 100644
--- app/code/core/Mage/Index/Model/Indexer.php
+++ app/code/core/Mage/Index/Model/Indexer.php
@@ -162,7 +162,6 @@ class Mage_Index_Model_Indexer
         $allowTableChanges = $this->_allowTableChanges && !$resourceModel->isInTransaction();
         if ($allowTableChanges) {
             $this->_currentEvent = array($entity, $type);
-            $this->_changeKeyStatus(false);
         }
 
         $resourceModel->beginTransaction();
@@ -176,7 +175,6 @@ class Mage_Index_Model_Indexer
         }
         if ($allowTableChanges) {
             $this->_allowTableChanges = true;
-            $this->_changeKeyStatus(true);
             $this->_currentEvent = null;
         }
         Mage::dispatchEvent('end_index_events' . $this->_getEventTypeName($entity, $type));
@@ -254,7 +252,6 @@ class Mage_Index_Model_Indexer
             $allowTableChanges = $this->_allowTableChanges && !$resourceModel->isInTransaction();
             if ($allowTableChanges) {
                 $this->_currentEvent = $event;
-                $this->_changeKeyStatus(false);
             }
 
             $resourceModel->beginTransaction();
@@ -266,14 +263,12 @@ class Mage_Index_Model_Indexer
                 $resourceModel->rollBack();
                 if ($allowTableChanges) {
                     $this->_allowTableChanges = true;
-                    $this->_changeKeyStatus(true);
                     $this->_currentEvent = null;
                 }
                 throw $e;
             }
             if ($allowTableChanges) {
                 $this->_allowTableChanges = true;
-                $this->_changeKeyStatus(true);
                 $this->_currentEvent = null;
             }
             $event->save();
@@ -330,6 +325,8 @@ class Mage_Index_Model_Indexer
     /**
      * Enable/Disable keys in index tables
      *
+     * @deprecated
+     *
      * @param bool $enable
      * @return Mage_Index_Model_Indexer
      */
diff --git app/code/core/Mage/Sales/Model/Abstract.php app/code/core/Mage/Sales/Model/Abstract.php
index 72969f6..4decc24 100644
--- app/code/core/Mage/Sales/Model/Abstract.php
+++ app/code/core/Mage/Sales/Model/Abstract.php
@@ -43,14 +43,14 @@ abstract class Mage_Sales_Model_Abstract extends Mage_Core_Model_Abstract
      * Processing object after save data
      * Updates relevant grid table records.
      *
-     * @return Mage_Core_Model_Abstract
+     * @return Mage_Sales_Model_Abstract
      */
-    protected function _afterSave()
+    public function afterCommitCallback()
     {
         if (!$this->getForceUpdateGridRecords()) {
             $this->_getResource()->updateGridRecords($this->getId());
         }
-        return parent::_afterSave();
+        return parent::afterCommitCallback();
     }
 
     /**
diff --git app/code/core/Mage/Sales/Model/Resource/Quote.php app/code/core/Mage/Sales/Model/Resource/Quote.php
index 9fad0ff..0f946a0 100755
--- app/code/core/Mage/Sales/Model/Resource/Quote.php
+++ app/code/core/Mage/Sales/Model/Resource/Quote.php
@@ -181,23 +181,24 @@ class Mage_Sales_Model_Resource_Quote extends Mage_Sales_Model_Resource_Abstract
      */
     public function markQuotesRecollectOnCatalogRules()
     {
-        $tableQuote = $this->getTable('sales/quote');
-        $subSelect = $this->_getReadAdapter()
-            ->select()
-            ->from(array('t2' => $this->getTable('sales/quote_item')), array('entity_id' => 'quote_id'))
-            ->from(array('t3' => $this->getTable('catalogrule/rule_product_price')), array())
-            ->where('t2.product_id = t3.product_id')
-            ->group('quote_id');
+        $quoteItemTable     = $this->getTable('sales/quote_item');
+        $productPriceTable  = $this->getTable('catalogrule/rule_product_price');
 
-        $select = $this->_getReadAdapter()->select()->join(
-            array('t2' => $subSelect),
-            't1.entity_id = t2.entity_id',
-            array('trigger_recollect' => new Zend_Db_Expr('1'))
-        );
+        $select = $this->_getReadAdapter()->select();
+        $subSelect = clone $select;
 
-        $updateQuery = $select->crossUpdateFromSelect(array('t1' => $tableQuote));
+        $subSelect
+            ->distinct()
+            ->from(array('qi' => $quoteItemTable), array('entity_id' => 'quote_id'))
+            ->join(array('pp' => $productPriceTable), 'qi.product_id = pp.product_id', array());
 
-        $this->_getWriteAdapter()->query($updateQuery);
+        $select
+            ->join(array('tmp' => $subSelect), 'q.entity_id = tmp.entity_id',
+                array('trigger_recollect' => new Zend_Db_Expr(1)));
+
+        $writeAdapter = $this->_getWriteAdapter();
+        $sql = $writeAdapter->updateFromSelect($select, array('q' => $this->getTable('sales/quote')));
+        $writeAdapter->query($sql);
 
         return $this;
     }
