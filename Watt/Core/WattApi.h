// This file is part of "Watt"
//
// "Watt" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// "Watt" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "Watt"  If not, see <http://www.gnu.org/licenses/>
//
//  WattApi.h
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

// This is a cross platform authoring and runtime api
// to developp multimedia project
// That intent to be fully supported by mac os x and IOS

// Port to Java targetting Android & non android system is possible.
// Watt is a model driven framework relying on files.


#import "WattUtils.h"

@class WattUser, WattGroup, WattModel,WattRegistry;

////////////
// WATT_ACL
////////////


// Watt acl was inspired by the unix permissions.
// Most of the time WattModels are not owned by anyone!
// Owned object are used only if complex workflows can apply.

/*
 
 A classic approach to protect an object is to use the "system" user
 
 [<API> applyRights:[<API> rightsFromString:@"RWXR--R--"]
            andOwner:<API>.system
                 on:objectReference];
 */

typedef enum watt_Actions{
    WattREAD=0,     //view the file
    WattWRITE=1,    //create, edit or delete
    WattEXECUTE=2   //run a script or enter a directory ?
}Watt_Action;


#ifndef WATT_CONST
#define WATT_CONST
#define WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME @"WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME"
#endif


@interface WattApi : NSObject

@property (nonatomic,strong)    WattUser *me;
@property (nonatomic,readonly)  WattUser *system;
@property (nonatomic,readonly)  WattGroup *systemGroup;


#pragma mark - Registry


- (void)mergeRegistry:(WattRegistry*)sourceRegistry
                 into:(WattRegistry*)destinationRegistry
       reIndexUinstID:(BOOL)index;


#pragma mark - ACL

#pragma mark - rights facilities

- (void)applyRights:(NSUInteger)rights
           andOwner:(WattUser*)owner
                 on:(WattModel*)model;

- (NSString*)rightsFromInteger:(NSUInteger)numericRights;

- (NSUInteger)rightsFromString:(NSString*)stringRights;


#pragma  mark - access control

// The acl method
- (BOOL)actionIsAllowed:(Watt_Action)action on:(WattModel*)model;

- (BOOL)actionIsAllowed:(Watt_Action)action
             withRights:(NSUInteger)rights
             imTheOwner:(BOOL)owned
      imInTheOwnerGroup:(BOOL)inTheGroup;


- (BOOL)mIOwnerOf:(WattModel*)model;

- (BOOL)mIIntheGroup:(WattGroup*)group;

@end
