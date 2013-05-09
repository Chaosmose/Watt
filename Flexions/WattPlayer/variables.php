<?php

/* @var $f Flexed */

$prefix = "WTM";

if (isset ( $f )) {
	$f->package = "Models/";
	$f->company = "Benoit Pereira da Silva";
	$f->prefix = $prefix;
	$f->author = "benoit@pereira-da-silva.com";
	$f->projectName = "Watt";
	$f->license = FLEXIONS_ROOT_DIR."flexions/helpers/licenses/LGPL.tpl.php";
}

$imports = "\n#import \"WTMObject.h\"\n\n";
$parentClass = "WTMObject";
$markAsDynamic = false;
$allowScalars = true;