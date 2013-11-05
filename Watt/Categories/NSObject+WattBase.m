//
//  NSObject+WattBase.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 05/11/2013.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "NSObject+WattBase.h"

@implementation NSObject (WattBase)



#pragma mark - Unique identification

/**
 *  Returns an unique identifier string
 *
 *  @return the identifier
 */
- (NSString *)uuidString{
    return [NSObject uuidString];
}

/**
 *  Returns an unique identifier string
 *
 *  @return the identifier
 */
+ (NSString *)uuidString{
    // Returns a UUID
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return uuidStr;

}

#pragma  mark - exceptions

/**
 *  Raises an exception
 *
 *  @param format the format
 */
- (void)raiseExceptionWithFormat:(NSString *)format, ...{
    va_list args;
    va_start(args, format);
    NSString *s = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if(s)
        [NSException raise:@"Watt Exception" format:@"%@",s];
    else
        [NSException raise:@"Watt Exception" format:@"Internal error"];
    
}

@end
