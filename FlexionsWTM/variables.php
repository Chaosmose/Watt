<?php

/* @var $f Flexed */

$prefix = "WTM";

if (isset ( $f )) {
	$f->package = "Models/";
	$f->company = "Benoit Pereira da Silva";
	$f->prefix = $prefix;
	$f->author = "benoit@pereira-da-silva.com";
	$f->projectName = "WTM";
	$f->license = FLEXIONS_MODULES_DIR."licenses/LGPL.template.php";
}
$parentClass = "WattModel";
$collectionParentClass="WattCollectionOfModel";
$protocols="WattCoding";
$imports = "\n#import \"$parentClass.h\"\n";
$markAsDynamic = false;
$allowScalars = true;