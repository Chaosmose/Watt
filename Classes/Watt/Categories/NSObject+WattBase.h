//
//  NSObject+WattBase.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 05/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A generic exception name.
 *  Used when calling raiseExceptionWithFormat:..
 */
static NSString *wattExceptionName=@"WattException";

@interface NSObject (WattBase)

#pragma mark - Unique identification

/**
 *  Returns an unique identifier string
 *
 *  @return the identifier
 */
- (NSString *)uidStringCreate;

/**
 *  Returns an unique identifier string
 *
 *  @return the identifier
 */
+ (NSString *)uidStringCreate;


#pragma  mark - exceptions

/**
 *  Raises an exception
 *
 *  @param format the format
 */
- (void)raiseExceptionWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end