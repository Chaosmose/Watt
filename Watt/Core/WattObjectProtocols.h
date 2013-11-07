//
//  WattObjectProtocols.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 03/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

@class WattRegistry;

#pragma mark - WattCopying

@protocol WattCopying
@required
/**
 *  Equivalent to NSCopying but with a reference to an explicit registry
 *  You should implement this method (sample) :
 *
 * - (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry{
 *  <YourClass> *instance=[super wattCopyInRegistry:destinationRegistry];
 *  instance->_registry=destinationRegistry;
 *  instance->_aString=[_aString copy];
 *  instance->_aScalar=_aScalar;
 *  instance->_aWattCopyableObject=[_aWattCopyableObject wattCopyInRegistry:destinationRegistry];
 *  return instance;
 *  }
 *
 *  @param destinationRegistry the registry
 *
 *  @return the copy of the instance in the destinationRegistry
 */
- (instancetype)wattCopyInRegistry:(WattRegistry*)destinationRegistry;
@optional

/**
 *  Implemented in WattObject (no need normaly to implement)
 *  If the copy allready exists in the destination registry
 *  This method returns the existing reference
 *
 *  @param destinationRegistry the registry
 *
 *  @return return the copy
 */
- (instancetype)instancebyCopyTo:(WattRegistry*)destinationRegistry;
@end


#pragma mark - WattExtraction

#warning We should deprecate WattExtraction and exclude props according to ExclusionPaths based on _propertiesKeys

// WOOZOO's SUGGESTIONS !
// NOTE WE COULD IMPLEMENT AN EXTRACTION WITH ExclusionPaths : "ClassName.propertyName.propertyName"
// or Inclusion Path
// or Predicate filters

@protocol WattExtraction <NSObject>
@required
/**
 *  Equivalent to WattCopying but without integration of non extractible properties
 *  You should implement this method the same way WattCopying but :
 *  instance->_aExtractible=< the copy logic >
 *  instance->_aNonExtractible=nil;
 *  return instance;
 *  }
 *
 *  @param destinationRegistry the registry
 *
 *  @return the copy of the instance in the destinationRegistry
 */
- (instancetype)wattExtractAndCopyToRegistry:(WattRegistry*)destinationRegistry;

- (instancetype)extractInstancebyCopyTo:(WattRegistry*)destinationRegistry;

//- (instancetype)wattExtractAndCopyToRegistry:(WattRegistry*)destinationRegistry withExclusionPathList:(NSArray*)exclusionPathList;
@end

#pragma mark - WattCoding

@protocol WattCoding <NSObject>
@required
- (NSDictionary *)dictionaryRepresentationWithChildren:(BOOL)includeChildren;
- (NSMutableDictionary*)dictionaryOfPropertiesWithChildren:(BOOL)includeChildren;
@end