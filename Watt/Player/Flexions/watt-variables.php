<?php

/* @var $f Flexed */

$prefix = "WTM";

if (isset ( $f )) {
	$f->package = "Models/";
	$f->company = "Benoit Pereira da Silva";
	$f->prefix = $prefix;
	$f->author = "benoit@pereira-da-silva.com";
	$f->projectName = "Watt-Multimedia-Engine";
	$f->license = FLEXIONS_ROOT_DIR."flexions/helpers/licenses/LGPL.tpl.php";
}

$imports = "\n#import <Foundation/Foundation.h>\n\n";
$parentClass = "NSObject";
$markAsDynamic = false;
$allowScalars = true;