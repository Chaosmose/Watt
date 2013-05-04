#!/bin/sh 

# Author benoit@pereira-da-silva.com 
# Last update 2013/01/01

########################
# Installation related variables
########################

# the relative path to flexions.php
cmdPath="../../../Flexions/src/flexions.php"

# the source folder
source="./"

# the destination folder
# destination="../../../Flexions/src/out/"
destination="../../WattPlayer/Generated/"


# the optional web url to invoke from a browser 
webBaseUrl="http://flexions.local/flexions.php?"

########################
# Project specific variables 
########################

descriptor="wattM.xcdatamodel/contents"
templates="entities/Model.h.php,entities/Model.m.php"
pre="pre-processor.php"
post="post-processor.php"

########################
# Command feed back 
########################

clear 
echo \# invoking :
echo php  -f ${cmdPath}flexions.php source=${source} destination=${destination} descriptor=${descriptor} templates=${templates}  preProcessors=${pre} postProcessors=${post}
echo 
echo \# You could alternatively invoke Flexion in you browser by setting the document root to Flexions/src folder
echo ${webBaseUrl}source=${source}\&destination=${destination}\&descriptor=${descriptor}\&templates=${templates}\&preProcessors=${pre}\&postProcessors=${post}
echo 

########################
# Invoke the command
########################

php  -f ${cmdPath} source=${source} destination=${destination} descriptor=${descriptor} templates=${templates}  preProcessors=${pre} postProcessors=${post}
