<?php

/* @var $f Flexed */

$prefix = "Watt";

if (isset ( $f )) {
	$f->package = "";
	$f->company = "Benoit Pereira da Silva";
	$f->prefix = $prefix;
	$f->author = "benoit@pereira-da-silva.com";
	$f->projectName = "Watt";
	$f->license = FLEXIONS_ROOT_DIR."flexions/helpers/licenses/LGPL.tpl.php";
}
$parentClass = "WattObject";
$collectionParentClass="WattCollectionOfObject";
$protocols="WattCoding,WattCopying";
$imports = "\n#import \"$parentClass.h\"\n";
$markAsDynamic = false;
$allowScalars = true;