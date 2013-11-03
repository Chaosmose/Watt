
n.n.n / 2013-11-03 
==================

  * Re-packaging
  * Imports issues fix
  * Cleaning
  * Watt registry optimization
  * removal of WTM singleton dependencies
  * Large refactory to give a complete independance to packages in WTM
  * WT_KVC_KEY_FAULT_TOLERENCE conditional compilation directive
  * KVC Fault tolerence attempt
  * WTM simplification (removal of bands)
  * Registry enumeration
  * Move a WattObject to a new registry invisible category
  * Registry merging
  * Menus extractibility
  * Pod updates
  * Pod updates
  * Removal of url support on WattBundleManager (this should be handled from a higher layer)
  * Extension quirk fix
  * Pack / unpack allows destination overwriting
  * Call block on unpack failure
  * WattBundlePackager emancipation
  * Packaging support
  * Dataset cleaning
  * XCtest
  * Removal of AFNetworking dependency
  * Extraction exception bug fix
  * Extractible reimplementation
  * WattExtraction support
  * Fully functional WattCopying implementation (object graph level carbon copy from a registry to another)
  * WattCopying does not rely on NSCopying implementation to deal with complex circular referecing copies
  * WattCopying protocol
  * WattCopying <NSCopying> flexion
  * matrixBackgroundColor support
  * Workspace files
  * XC basic unit test
  * Matrix background image support
  * Matrix autoresizing background
  * Quick addition of a background image view
  * Added a XCTest
  * WattModel use A NSMutableDictionary metadata
  * Header and footer rotation support
  * Matrix header and footer support
  * Properties macros
  * Footer and Header on the WTMScene
  * Collection indexation method
  * Selectors refactory exceptions fixes
  * Bundle name change
  * Attempt to use correctly cocoapods resource_bundles
  * Pod spec update
  * Pods attempt to preserve paths
  * Experiments with cocoa pods resource_bundles
  * Pod spec update
  * Pod spec
  * Watt model metadata support
  * Configuration
  * Zip background mode
  * Watt bundle packager background mode support
  * Fully fonctionnal matrix support
  * Packaging of Matrix VC (to facilitate extraction)
  * Dependency update
  * Matrix view controller container
  * Matrix view controller
  * Members & assets collection generation
  * Behaviors can be attached to columns
  * Credentials
  * Alert macro for IOS
  * Pod spec update
  * Cleaning
  * Basic Sound manager pre-release
  * Internationalized sound recorder
  * Sound Recorder
  * Registry crash fix
  * Import soup
  * Podspecs updates
  * Autoreloading
  * wtmSaveRegistry macro
  * WTM sound duration fix
  * Cells referencing
  * Updates
  * Circular desialiasing prevention flag
  * Better exception handling on auto save
  * Table, Column and lines facilities in WTMApi
  * WTM Table api
  * sound recorder
  * Simplified behavior model
  * wtmRegistry macro alias
  * History & state
  * Optimization of registry auto saving
  * WIOS recorder autosaving support
  * Project retro compatibility with Xcode 4.x
  * Cleaning
  * Configuration xcode
  * Project update
  * WIOS imports
  * Registry autosaving
  * Registry sets hasChanged on registration & reregistration of watt objects
  * We check object changes if the registry is not already set to YES
  * WattApi writeRegistryIfNecessary method ( relies on watt object hasChanged state
  * Project update
  * Functional WIOS sound recorder
  * Registry and watt object  has changed flag
  * Sound manager base
  * WTMIOS sound cell bases
  * WTMIOS sound controller base
  * Flexions + misc fixes
  * WTMIOS podspec
  * Creation of WTMIOS
  * Collection filtering by blocks
  * Menu and Menu section indexes are set when using WTMApi creation facility
  * filteredCollectionUsingPredicate always return a collection even if void
  * Collection sorting support
  * Registry reference passed when filtering collection by predicate
  * UIImage+wattAdaptive packaged in WTM
  * Collection move object selector creation
  * Reversible Collection block enumeration
  * Quirk fix
  * Element cells api and structure optimization
  * WTM Element api simplication
  * Creation of table, columns, line, and elements cells
  * Activity nature removal
  * Clarification on WattObject unregistration in collection context
  * External import @class generation
  * Removal of WTM/WattBundlePackager
  * Removal of WTM/WattBundlePackager
  * Removal of WTM/WattBundlePackager
  * External dependency optimization
  * WTMHyperlink updateImageOnChange option
  * Flexions using external referencing
  * WTM pod spec cleaning
  * WTMHyperlink updateUrlOnChange addition
  * Packager is part of Watt
  * WattApi reorganization
  * WTM / Watt de-correlation
  * Imports soup
  * Read me update
  * Cleaning
  * WTM splits from Watt
  * ACL adjustment (system:systemGroup)
  * WattAcl rigths settings facilities
  * Acl method extensions, group & owner by ID
  * Inheritance & Acl adjustments
  * WattAcl static facilities
  * Menu index
  * Model update
  * Added allowExploration property  for Hyperlinks
  * Fixes soup mixing (based on path extension)
  * Forced soup paths support (DRM)
  * Explicit soup declaration by extension
  * Members creation fix
  * Members facilities
  * Removal of extensive logging
  * Object graph consistency when moving a registry with deleted entries
  * Watt bundle are .watt
  * Removal of the LGPL text in the ReadMe
  * Reorganization and integration of the WattEditor for mac OS
  * FirstObject collection accessor + WattApi
  * Flexions adjustments
  * wattTodo() macro
  * Watt packaging with symbolic links
  * Watt sample
  * Target with flexions script
  * Pod update
  * Imports
  * Podspec
  * WattM becomes Watt
  * Header and import repackaging
  * Refactory
  * Trying to use SSZipArchive
  * Watt packaging
  * Added dependcies to AFNetworking and ZipArchive
  * Watt packaging
  * Alias compact serialization
  * WattApi implementation in progress
  * Model foot object holds owner, rights, group, comments, ... properties
  * Creation of WattAcl
  * Menu section are reattached to the shelf
  * Description of ancestors
  * Extended api interface with basic ACL Controls (but currently no implementation)
  * Additional models
  * Flexions
  * Model as parent of most models with generic properties like : objectName, extra ...
  * Linked assets dependencies generalization ( including referer counting for deletion automation)
  * Multiple adaptive paths
  * Members refererCounter (to deal with linked media dependencies)
  * Collection dealiasing
  * Collection aliases resolution
  * No aliases resolution in collections
  * Optimization on collection alias resolution
  * Typed block enumeration on collections
  * Eradication of int s
  * Adaptive path fix
  * Menu reference has an UInstID to allow cross registry referral
  * Better support of inheritance
  * Root uinstID constant definition
  * Remove object by reference from collections
  * Deletion of Datum & collection
  * Cleaning
  * Predicate filtering on Collection
  * Target configuration
  * normalization of properties
  * Normalization of entities pictures & relative path
  * We use collection's index for ordering
  * Introduction of bands and generalization of categories
  * Import quirks fix
  * Conditionnal compiling (Mac os X support)
  * Cocoapod syncrhonization issue
  * Adaptive path resolution (images)
  * Menu referenceID support to alias registry based entities
  * Member thumbnail support
  * Url string support for menus
  * Video duration as a float
  * Video duration fix
  * Removal of IOS specific dependencies
  * Removal of CGRect and CGSize for cross platform support (encoded in a string)
  * Support of Mac OS X 10.7
  * Image filename in menu & menu sections
  * Menu section generated classes
  * Added menu sections
  * Added Menu model
  * Category classifier an coverPicture
  * Activity to package homologous relationship
  * Commenting temporarily warnings
  * Extra removal (we use simple dictionaries)
  * Models simplification
  * Reciprocity of relations to facilitate the main model usage
  * Collection and registry search facilities
  * Activity can has a picture as representation
  * Models and pretest updates
  * Optionnal alaises resolution
  * Graph linear serialization/deserialization
  * Aliasing process
  * resolveAliases
  * Registry lazy deserialization
  * Removal of WattM as prefix
  * Header updates
  * Header conditional compiling TARGET_OS_IPHONE
  * Fundations added to prefix
  * Fundation adde to WattM prefix
  * PodSpec update added a prefix header
  * Header update
  * Core engine refactory
  * Clarification of Watt core classes an WattM
  * Added a specific target for Flexions
  * Usage of initInDefaultRegistry
  * semantic key changes for WattCoding
  * Registry support
  * Import cleaning
  * Invoke flexions build phase
  * Flexions is used in the early build phase
  * Podspec
  * LGPL license file
  * Podspec name update
  * Encoding issues
  * Pod spec update
  * WattCoding protocol support
  * Api structuration
  * WattMApi & I18N
  * WattMApi & I18N
  * KVC serialization
  * State
  * Auto instantiation of Collections on INIT
  * State
  * Extended model
  * Cleaning
  * Collection accessors
  * New base class for the Models
  * Refactory
  * Xuser state ?
  * Flexions regeneration
  * Xuser state
  * Collection of Datum (data)
  * Regeneration using Flexion
  * Licensing
  * Datum serializer
  * Fundation skeleton
  * Datum collection
  * Scene instead of pages
  * Regeneration
  * Systematic inclusion of ACL and RM
  * Flexions 1.0 support + Regeneration
  * Re packaging
  * Reorganization
  * Flexions configuration
  * first commit

n.n.n / 2013-09-05 
==================

  * Optimization of registry auto saving
  * WIOS recorder autosaving support
  * Project retro compatibility with Xcode 4.x
  * Cleaning
  * Configuration xcode
  * Project update
  * WIOS imports
  * Registry autosaving
  * Registry sets hasChanged on registration & reregistration of watt objects
  * We check object changes if the registry is not already set to YES
  * WattApi writeRegistryIfNecessary method ( relies on watt object hasChanged state
  * Project update
  * Functional WIOS sound recorder
  * Registry and watt object  has changed flag
  * Sound manager base
  * WTMIOS sound cell bases
  * WTMIOS sound controller base
  * Flexions + misc fixes
  * WTMIOS podspec
  * Creation of WTMIOS
  * Collection filtering by blocks
  * Menu and Menu section indexes are set when using WTMApi creation facility
  * filteredCollectionUsingPredicate always return a collection even if void
  * Collection sorting support
  * Registry reference passed when filtering collection by predicate
  * UIImage+wattAdaptive packaged in WTM
  * Collection move object selector creation
  * Reversible Collection block enumeration
  * Quirk fix
  * Element cells api and structure optimization
  * WTM Element api simplication
  * Creation of table, columns, line, and elements cells
  * Activity nature removal
  * Clarification on WattObject unregistration in collection context
  * External import @class generation
  * Removal of WTM/WattBundlePackager
  * Removal of WTM/WattBundlePackager
  * Removal of WTM/WattBundlePackager
  * External dependency optimization
  * WTMHyperlink updateImageOnChange option
  * Flexions using external referencing
  * WTM pod spec cleaning
  * WTMHyperlink updateUrlOnChange addition
  * Packager is part of Watt
  * WattApi reorganization
  * WTM / Watt de-correlation
  * Imports soup
  * Read me update
  * Cleaning
  * WTM splits from Watt
  * ACL adjustment (system:systemGroup)
  * WattAcl rigths settings facilities
  * Acl method extensions, group & owner by ID
  * Inheritance & Acl adjustments
  * WattAcl static facilities
  * Menu index
  * Model update
  * Added allowExploration property  for Hyperlinks
  * Fixes soup mixing (based on path extension)
  * Forced soup paths support (DRM)
  * Explicit soup declaration by extension
  * Members creation fix
  * Members facilities
  * Removal of extensive logging
  * Object graph consistency when moving a registry with deleted entries
  * Watt bundle are .watt
  * Removal of the LGPL text in the ReadMe
  * Reorganization and integration of the WattEditor for mac OS
  * FirstObject collection accessor + WattApi
  * Flexions adjustments
  * wattTodo() macro
  * Watt packaging with symbolic links
  * Watt sample
  * Target with flexions script
  * Pod update
  * Imports
  * Podspec
  * WattM becomes Watt
  * Header and import repackaging
  * Refactory
  * Trying to use SSZipArchive
  * Watt packaging
  * Added dependcies to AFNetworking and ZipArchive
  * Watt packaging
  * Alias compact serialization
  * WattApi implementation in progress
  * Model foot object holds owner, rights, group, comments, ... properties
  * Creation of WattAcl
  * Menu section are reattached to the shelf
  * Description of ancestors
  * Extended api interface with basic ACL Controls (but currently no implementation)
  * Additional models
  * Flexions
  * Model as parent of most models with generic properties like : objectName, extra ...
  * Linked assets dependencies generalization ( including referer counting for deletion automation)
  * Multiple adaptive paths
  * Members refererCounter (to deal with linked media dependencies)
  * Collection dealiasing
  * Collection aliases resolution
  * No aliases resolution in collections
  * Optimization on collection alias resolution
  * Typed block enumeration on collections
  * Eradication of int s
  * Adaptive path fix
  * Menu reference has an UInstID to allow cross registry referral
  * Better support of inheritance
  * Root uinstID constant definition
  * Remove object by reference from collections
  * Deletion of Datum & collection
  * Cleaning
  * Predicate filtering on Collection
  * Target configuration
  * normalization of properties
  * Normalization of entities pictures & relative path
  * We use collection's index for ordering
  * Introduction of bands and generalization of categories
  * Import quirks fix
  * Conditionnal compiling (Mac os X support)
  * Cocoapod syncrhonization issue
  * Adaptive path resolution (images)
  * Menu referenceID support to alias registry based entities
  * Member thumbnail support
  * Url string support for menus
  * Video duration as a float
  * Video duration fix
  * Removal of IOS specific dependencies
  * Removal of CGRect and CGSize for cross platform support (encoded in a string)
  * Support of Mac OS X 10.7
  * Image filename in menu & menu sections
  * Menu section generated classes
  * Added menu sections
  * Added Menu model
  * Category classifier an coverPicture
  * Activity to package homologous relationship
  * Commenting temporarily warnings
  * Extra removal (we use simple dictionaries)
  * Models simplification
  * Reciprocity of relations to facilitate the main model usage
  * Collection and registry search facilities
  * Activity can has a picture as representation
  * Models and pretest updates
  * Optionnal alaises resolution
  * Graph linear serialization/deserialization
  * Aliasing process
  * resolveAliases
  * Registry lazy deserialization
  * Removal of WattM as prefix
  * Header updates
  * Header conditional compiling TARGET_OS_IPHONE
  * Fundations added to prefix
  * Fundation adde to WattM prefix
  * PodSpec update added a prefix header
  * Header update
  * Core engine refactory
  * Clarification of Watt core classes an WattM
  * Added a specific target for Flexions
  * Usage of initInDefaultRegistry
  * semantic key changes for WattCoding
  * Registry support
  * Import cleaning
  * Invoke flexions build phase
  * Flexions is used in the early build phase
  * Podspec
  * LGPL license file
  * Podspec name update
  * Encoding issues
  * Pod spec update
  * WattCoding protocol support
  * Api structuration
  * WattMApi & I18N
  * WattMApi & I18N
  * KVC serialization
  * State
  * Auto instantiation of Collections on INIT
  * State
  * Extended model
  * Cleaning
  * Collection accessors
  * New base class for the Models
  * Refactory
  * Xuser state ?
  * Flexions regeneration
  * Xuser state
  * Collection of Datum (data)
  * Regeneration using Flexion
  * Licensing
  * Datum serializer
  * Fundation skeleton
  * Datum collection
  * Scene instead of pages
  * Regeneration
  * Systematic inclusion of ACL and RM
  * Flexions 1.0 support + Regeneration
  * Re packaging
  * Reorganization
  * Flexions configuration
  * first commit

n.n.n / 2013-08-15 
==================

  * Removal of WTM/WattBundlePackager
  * Removal of WTM/WattBundlePackager
  * Removal of WTM/WattBundlePackager
  * External dependency optimization
  * WTMHyperlink updateImageOnChange option
  * Flexions using external referencing
  * WTM pod spec cleaning
  * WTMHyperlink updateUrlOnChange addition
  * Packager is part of Watt
  * WattApi reorganization
  * WTM / Watt de-correlation
  * Imports soup
  * Read me update
  * Cleaning
  * WTM splits from Watt
  * ACL adjustment (system:systemGroup)
  * WattAcl rigths settings facilities
  * Acl method extensions, group & owner by ID
  * Inheritance & Acl adjustments
  * WattAcl static facilities
  * Menu index
  * Model update
  * Added allowExploration property  for Hyperlinks
  * Fixes soup mixing (based on path extension)
  * Forced soup paths support (DRM)
  * Explicit soup declaration by extension
  * Members creation fix
  * Members facilities
  * Removal of extensive logging
  * Object graph consistency when moving a registry with deleted entries
  * Watt bundle are .watt
  * Removal of the LGPL text in the ReadMe
  * Reorganization and integration of the WattEditor for mac OS
  * FirstObject collection accessor + WattApi
  * Flexions adjustments
  * wattTodo() macro
  * Watt packaging with symbolic links
  * Watt sample
  * Target with flexions script
  * Pod update
  * Imports
  * Podspec
  * WattM becomes Watt
  * Header and import repackaging
  * Refactory
  * Trying to use SSZipArchive
  * Watt packaging
  * Added dependcies to AFNetworking and ZipArchive
  * Watt packaging
  * Alias compact serialization
  * WattApi implementation in progress
  * Model foot object holds owner, rights, group, comments, ... properties
  * Creation of WattAcl
  * Menu section are reattached to the shelf
  * Description of ancestors
  * Extended api interface with basic ACL Controls (but currently no implementation)
  * Additional models
  * Flexions
  * Model as parent of most models with generic properties like : objectName, extra ...
  * Linked assets dependencies generalization ( including referer counting for deletion automation)
  * Multiple adaptive paths
  * Members refererCounter (to deal with linked media dependencies)
  * Collection dealiasing
  * Collection aliases resolution
  * No aliases resolution in collections
  * Optimization on collection alias resolution
  * Typed block enumeration on collections
  * Eradication of int s
  * Adaptive path fix
  * Menu reference has an UInstID to allow cross registry referral
  * Better support of inheritance
  * Root uinstID constant definition
  * Remove object by reference from collections
  * Deletion of Datum & collection
  * Cleaning
  * Predicate filtering on Collection
  * Target configuration
  * normalization of properties
  * Normalization of entities pictures & relative path
  * We use collection's index for ordering
  * Introduction of bands and generalization of categories
  * Import quirks fix
  * Conditionnal compiling (Mac os X support)
  * Cocoapod syncrhonization issue
  * Adaptive path resolution (images)
  * Menu referenceID support to alias registry based entities
  * Member thumbnail support
  * Url string support for menus
  * Video duration as a float
  * Video duration fix
  * Removal of IOS specific dependencies
  * Removal of CGRect and CGSize for cross platform support (encoded in a string)
  * Support of Mac OS X 10.7
  * Image filename in menu & menu sections
  * Menu section generated classes
  * Added menu sections
  * Added Menu model
  * Category classifier an coverPicture
  * Activity to package homologous relationship
  * Commenting temporarily warnings
  * Extra removal (we use simple dictionaries)
  * Models simplification
  * Reciprocity of relations to facilitate the main model usage
  * Collection and registry search facilities
  * Activity can has a picture as representation
  * Models and pretest updates
  * Optionnal alaises resolution
  * Graph linear serialization/deserialization
  * Aliasing process
  * resolveAliases
  * Registry lazy deserialization
  * Removal of WattM as prefix
  * Header updates
  * Header conditional compiling TARGET_OS_IPHONE
  * Fundations added to prefix
  * Fundation adde to WattM prefix
  * PodSpec update added a prefix header
  * Header update
  * Core engine refactory
  * Clarification of Watt core classes an WattM
  * Added a specific target for Flexions
  * Usage of initInDefaultRegistry
  * semantic key changes for WattCoding
  * Registry support
  * Import cleaning
  * Invoke flexions build phase
  * Flexions is used in the early build phase
  * Podspec
  * LGPL license file
  * Podspec name update
  * Encoding issues
  * Pod spec update
  * WattCoding protocol support
  * Api structuration
  * WattMApi & I18N
  * WattMApi & I18N
  * KVC serialization
  * State
  * Auto instantiation of Collections on INIT
  * State
  * Extended model
  * Cleaning
  * Collection accessors
  * New base class for the Models
  * Refactory
  * Xuser state ?
  * Flexions regeneration
  * Xuser state
  * Collection of Datum (data)
  * Regeneration using Flexion
  * Licensing
  * Datum serializer
  * Fundation skeleton
  * Datum collection
  * Scene instead of pages
  * Regeneration
  * Systematic inclusion of ACL and RM
  * Flexions 1.0 support + Regeneration
  * Re packaging
  * Reorganization
  * Flexions configuration
  * first commit

n.n.n / 2013-08-10 
==================

  * Cleaning
  * WTM splits from Watt
  * ACL adjustment (system:systemGroup)
  * WattAcl rigths settings facilities
  * Acl method extensions, group & owner by ID
  * Inheritance & Acl adjustments
  * WattAcl static facilities
  * Menu index
  * Model update
  * Added allowExploration property  for Hyperlinks
  * Fixes soup mixing (based on path extension)
  * Forced soup paths support (DRM)
  * Explicit soup declaration by extension
  * Members creation fix
  * Members facilities
  * Removal of extensive logging
  * Object graph consistency when moving a registry with deleted entries
  * Watt bundle are .watt
  * Removal of the LGPL text in the ReadMe
  * Reorganization and integration of the WattEditor for mac OS
  * FirstObject collection accessor + WattApi
  * Flexions adjustments
  * wattTodo() macro
  * Watt packaging with symbolic links
  * Watt sample
  * Target with flexions script
  * Pod update
  * Imports
  * Podspec
  * WattM becomes Watt
  * Header and import repackaging
  * Refactory
  * Trying to use SSZipArchive
  * Watt packaging
  * Added dependcies to AFNetworking and ZipArchive
  * Watt packaging
  * Alias compact serialization
  * WattApi implementation in progress
  * Model foot object holds owner, rights, group, comments, ... properties
  * Creation of WattAcl
  * Menu section are reattached to the shelf
  * Description of ancestors
  * Extended api interface with basic ACL Controls (but currently no implementation)
  * Additional models
  * Flexions
  * Model as parent of most models with generic properties like : objectName, extra ...
  * Linked assets dependencies generalization ( including referer counting for deletion automation)
  * Multiple adaptive paths
  * Members refererCounter (to deal with linked media dependencies)
  * Collection dealiasing
  * Collection aliases resolution
  * No aliases resolution in collections
  * Optimization on collection alias resolution
  * Typed block enumeration on collections
  * Eradication of int s
  * Adaptive path fix
  * Menu reference has an UInstID to allow cross registry referral
  * Better support of inheritance
  * Root uinstID constant definition
  * Remove object by reference from collections
  * Deletion of Datum & collection
  * Cleaning
  * Predicate filtering on Collection
  * Target configuration
  * normalization of properties
  * Normalization of entities pictures & relative path
  * We use collection's index for ordering
  * Introduction of bands and generalization of categories
  * Import quirks fix
  * Conditionnal compiling (Mac os X support)
  * Cocoapod syncrhonization issue
  * Adaptive path resolution (images)
  * Menu referenceID support to alias registry based entities
  * Member thumbnail support
  * Url string support for menus
  * Video duration as a float
  * Video duration fix
  * Removal of IOS specific dependencies
  * Removal of CGRect and CGSize for cross platform support (encoded in a string)
  * Support of Mac OS X 10.7
  * Image filename in menu & menu sections
  * Menu section generated classes
  * Added menu sections
  * Added Menu model
  * Category classifier an coverPicture
  * Activity to package homologous relationship
  * Commenting temporarily warnings
  * Extra removal (we use simple dictionaries)
  * Models simplification
  * Reciprocity of relations to facilitate the main model usage
  * Collection and registry search facilities
  * Activity can has a picture as representation
  * Models and pretest updates
  * Optionnal alaises resolution
  * Graph linear serialization/deserialization
  * Aliasing process
  * resolveAliases
  * Registry lazy deserialization
  * Removal of WattM as prefix
  * Header updates
  * Header conditional compiling TARGET_OS_IPHONE
  * Fundations added to prefix
  * Fundation adde to WattM prefix
  * PodSpec update added a prefix header
  * Header update
  * Core engine refactory
  * Clarification of Watt core classes an WattM
  * Added a specific target for Flexions
  * Usage of initInDefaultRegistry
  * semantic key changes for WattCoding
  * Registry support
  * Import cleaning
  * Invoke flexions build phase
  * Flexions is used in the early build phase
  * Podspec
  * LGPL license file
  * Podspec name update
  * Encoding issues
  * Pod spec update
  * WattCoding protocol support
  * Api structuration
  * WattMApi & I18N
  * WattMApi & I18N
  * KVC serialization
  * State
  * Auto instantiation of Collections on INIT
  * State
  * Extended model
  * Cleaning
  * Collection accessors
  * New base class for the Models
  * Refactory
  * Xuser state ?
  * Flexions regeneration
  * Xuser state
  * Collection of Datum (data)
  * Regeneration using Flexion
  * Licensing
  * Datum serializer
  * Fundation skeleton
  * Datum collection
  * Scene instead of pages
  * Regeneration
  * Systematic inclusion of ACL and RM
  * Flexions 1.0 support + Regeneration
  * Re packaging
  * Reorganization
  * Flexions configuration
  * first commit

n.n.n / 2013-08-09 
==================

  * ACL adjustment (system:systemGroup)
  * WattAcl rigths settings facilities
  * Acl method extensions, group & owner by ID
  * Inheritance & Acl adjustments
  * WattAcl static facilities
  * Menu index
  * Model update
  * Added allowExploration property  for Hyperlinks
  * Fixes soup mixing (based on path extension)
  * Forced soup paths support (DRM)
  * Explicit soup declaration by extension
  * Members creation fix
  * Members facilities
  * Removal of extensive logging
  * Object graph consistency when moving a registry with deleted entries
  * Watt bundle are .watt
  * Removal of the LGPL text in the ReadMe
  * Reorganization and integration of the WattEditor for mac OS
  * FirstObject collection accessor + WattApi
  * Flexions adjustments
  * wattTodo() macro
  * Watt packaging with symbolic links
  * Watt sample
  * Target with flexions script
  * Pod update
  * Imports
  * Podspec
  * WattM becomes Watt
  * Header and import repackaging
  * Refactory
  * Trying to use SSZipArchive
  * Watt packaging
  * Added dependcies to AFNetworking and ZipArchive
  * Watt packaging
  * Alias compact serialization
  * WattApi implementation in progress
  * Model foot object holds owner, rights, group, comments, ... properties
  * Creation of WattAcl
  * Menu section are reattached to the shelf
  * Description of ancestors
  * Extended api interface with basic ACL Controls (but currently no implementation)
  * Additional models
  * Flexions
  * Model as parent of most models with generic properties like : objectName, extra ...
  * Linked assets dependencies generalization ( including referer counting for deletion automation)
  * Multiple adaptive paths
  * Members refererCounter (to deal with linked media dependencies)
  * Collection dealiasing
  * Collection aliases resolution
  * No aliases resolution in collections
  * Optimization on collection alias resolution
  * Typed block enumeration on collections
  * Eradication of int s
  * Adaptive path fix
  * Menu reference has an UInstID to allow cross registry referral
  * Better support of inheritance
  * Root uinstID constant definition
  * Remove object by reference from collections
  * Deletion of Datum & collection
  * Cleaning
  * Predicate filtering on Collection
  * Target configuration
  * normalization of properties
  * Normalization of entities pictures & relative path
  * We use collection's index for ordering
  * Introduction of bands and generalization of categories
  * Import quirks fix
  * Conditionnal compiling (Mac os X support)
  * Cocoapod syncrhonization issue
  * Adaptive path resolution (images)
  * Menu referenceID support to alias registry based entities
  * Member thumbnail support
  * Url string support for menus
  * Video duration as a float
  * Video duration fix
  * Removal of IOS specific dependencies
  * Removal of CGRect and CGSize for cross platform support (encoded in a string)
  * Support of Mac OS X 10.7
  * Image filename in menu & menu sections
  * Menu section generated classes
  * Added menu sections
  * Added Menu model
  * Category classifier an coverPicture
  * Activity to package homologous relationship
  * Commenting temporarily warnings
  * Extra removal (we use simple dictionaries)
  * Models simplification
  * Reciprocity of relations to facilitate the main model usage
  * Collection and registry search facilities
  * Activity can has a picture as representation
  * Models and pretest updates
  * Optionnal alaises resolution
  * Graph linear serialization/deserialization
  * Aliasing process
  * resolveAliases
  * Registry lazy deserialization
  * Removal of WattM as prefix
  * Header updates
  * Header conditional compiling TARGET_OS_IPHONE
  * Fundations added to prefix
  * Fundation adde to WattM prefix
  * PodSpec update added a prefix header
  * Header update
  * Core engine refactory
  * Clarification of Watt core classes an WattM
  * Added a specific target for Flexions
  * Usage of initInDefaultRegistry
  * semantic key changes for WattCoding
  * Registry support
  * Import cleaning
  * Invoke flexions build phase
  * Flexions is used in the early build phase
  * Podspec
  * LGPL license file
  * Podspec name update
  * Encoding issues
  * Pod spec update
  * WattCoding protocol support
  * Api structuration
  * WattMApi & I18N
  * WattMApi & I18N
  * KVC serialization
  * State
  * Auto instantiation of Collections on INIT
  * State
  * Extended model
  * Cleaning
  * Collection accessors
  * New base class for the Models
  * Refactory
  * Xuser state ?
  * Flexions regeneration
  * Xuser state
  * Collection of Datum (data)
  * Regeneration using Flexion
  * Licensing
  * Datum serializer
  * Fundation skeleton
  * Datum collection
  * Scene instead of pages
  * Regeneration
  * Systematic inclusion of ACL and RM
  * Flexions 1.0 support + Regeneration
  * Re packaging
  * Reorganization
  * Flexions configuration
  * first commit
