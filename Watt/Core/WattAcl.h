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

// Watt acl was inspired by the unix permissions.
// http://mason.gmu.edu/~montecin/UNIXpermiss.htm

// But !
// Most of the time WTMModels are not owned by anyone.
// Owned object are used only if complex workflows can apply.
// By default a user owns mosts of the objects.

/* 
 
 A classic approach to protect an object is to use the "system" user

 
 [wattAPI.acl applyRights:[wattAPI.acl rightsFromString:@"RWXR--R--"]
                 andOwner:wattAPI.system
                       on:objectReference];
*/

#ifndef WTAPI_CONST
#define WTAPI_CONST
#define WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME @"WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME"
#endif


@class WTMModel;
@class WTMGroup;
@class WTMUser;

@interface WattAcl : NSObject

#pragma mark - rights facilities 

- (void)applyRights:(NSUInteger)rights
           andOwner:(WTMUser*)owner
                on:(WTMModel*)model;

- (NSString*)rightsFromInteger:(NSUInteger)numericRights;

- (NSUInteger)rightsFromString:(NSString*)stringRights;


#pragma  mark - access control 

// The acl method
- (BOOL)actionIsAllowed:(Watt_Action)action on:(WTMModel*)model;

- (BOOL)actionIsAllowed:(Watt_Action)action
            withRights:(NSUInteger)rights
            imTheOwner:(BOOL)owned
            imInTheOwnerGroup:(BOOL)inTheGroup;


- (BOOL)mIOwnerOf:(WTMModel*)model;
- (BOOL)mIIntheGroup:(WTMGroup*)group;




@end
