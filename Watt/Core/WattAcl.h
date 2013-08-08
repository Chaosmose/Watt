//
//  WattAcl.h
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 10/07/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum watt_Actions{
    WattREAD=0,     //view the file
    WattWRITE=1,    //create, edit or delete
    WattEXECUTE=2   //run a script or enter a directory ?
}Watt_Action;

// http://mason.gmu.edu/~montecin/UNIXpermiss.htm

#ifndef WTAPI_CONST
#define WTAPI_CONST
#define WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME @"WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME"
#endif

@interface WattAcl : NSObject

+(NSString*)stringRightsFrom:(NSUInteger)numericRights;

+(NSUInteger)numericRightsFromString:(NSString*)stringRights;

+(BOOL)actionIsAllowed:(Watt_Action)action
            withRights:(NSUInteger)rights
            imTheOwner:(BOOL)owned
            imInTheOwnerGroup:(BOOL)inTheGroup;

@end
