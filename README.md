Disclamer : 
===========

Watt & WTM are currently in early intensive research and development phases and not publicly released or Documented.
Watt is created by Benoit Pereira da Silva and is licensed under LGPL.

Watt
====

Watt is a model driven framework based extensively on code generation (Flexions)
The models are modelized hacking the XCode datamodeler (used by cored data), and generating sources on the fly (in building phase) within xcode using Flexions (a simple code generator by BPdS)

It allows :
- to generate normalized models sources files from xcdatamodel files.
- to serialize object graphs
- to move object graphs from a device to another transparently
- it integrates a unix like ACL layer
- it will be fully ported to Java/Android when it should be mature (mid 2014).

A WattRegisty is managed by a WattRegistryPool that deals with the data persistency and the file system.
Any WattObject can reference object in another registry by an WattExternalReference.
I have generated a base model  : WattModel that holds external references collection in a WattCollectionOfExternalReference


WTM
====

WTM is an Hyper&Multi/Media engine based on a portable packageable format built.
WTM is built using watt & Flexions.

If you use the PlayerSampleFlexions you need to install Flexions (a code generator) at the same level as the root Watt folder
https://github.com/benoit-pereira-da-silva/Flexions.git

The Watt.podspec refers to the Watt/Watt (the engine)

You can experiment Watt by using :
pod 'Watt', {:git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}
pod 'WTM", {:git => 'https://github.com/benoit-pereira-da-silva/Watt.git'}