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
//  WTMApi.m
//
//  Created by Benoit Pereira da Silva on 17/05/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//



#import "WattACL.h"
#import "Watt.h"

@interface WattACL()
@end

@implementation WattACL{
    WattUser     *  _system;
    WattGroup    * _systemGroup;
}



// system and systemGroup are not in any registry
// Their uinstID is NSIntegerMax

-(WattUser*)system{
    if(!_system){
        _system=[[WattUser alloc] initInRegistry:nil
                            withPresetIdentifier:NSIntegerMax];
        _system.group=[self systemGroup];
    }
    return _system;
}

-(WattGroup*)systemGroup{
    if(!_systemGroup){
        _systemGroup=[[WattGroup alloc] initInRegistry:nil
                                  withPresetIdentifier:NSIntegerMax];
    }
    return _systemGroup;
}





#pragma mark - ACL

#pragma mark - rights facilities

- (void)applyRights:(NSUInteger)rights
           andOwner:(WattUser*)owner
                 on:(WattModel*)model{
    if(!model)
        [ NSException raise:@"WattACL" format:@"Attempt to setup rights on void model"];
    model.rights=rights;
    if(owner){
        model.ownerID=owner.uinstID;
        model.groupID=owner.group.uinstID;
    }
}

/*
 
 @"RWXRWXRWX"
 
 OWNER  400- 200  - 100
 GROUP   40-  20  -  10
 OTHERS   4-   2  -   1
 
 */


- (NSString*)rightsFromInteger:(NSUInteger)numericRights{
    
    if(numericRights>777){
        numericRights=0;
    }
    
    NSInteger values[9];
    values[0]=400;
    values[1]=200;
    values[2]=100;
    values[3]=40;
    values[4]=20;
    values[5]=10;
    values[6]=4;
    values[7]=2;
    values[8]=1;
    
    NSString *allRightsString= @"RWXRWXRWX";
    NSMutableString *rights=[NSMutableString string];
    NSInteger nRights=numericRights;
    
    for (NSInteger i=0; i<9; i++) {
        if(nRights-values[i]>=0){
            nRights=nRights-values[i];
            NSString * unitaryString = [allRightsString substringWithRange:NSMakeRange(i, 1)];
            [rights appendString:unitaryString];
        }else{
            [rights appendString:@"-"];
        }
    }
    return rights;
}

- (NSUInteger)rightsFromString:(NSString*)stringRights{
    
    while ([stringRights length]<9) {
        stringRights=[NSString stringWithFormat:@"-%@",stringRights];
    }
    
    NSInteger values[9];
    values[0]=400;
    values[1]=200;
    values[2]=100;
    values[3]=40;
    values[4]=20;
    values[5]=10;
    values[6]=4;
    values[7]=2;
    values[8]=1;
    
    NSString *allRightsString= @"RWXRWXRWX";
    
    NSUInteger rights=0;
    for (NSInteger i=0; i<9; i++) {
        NSString * unitaryString = [stringRights substringWithRange:NSMakeRange(i, 1)];
        NSString * unitaryStringForAllRights = [allRightsString substringWithRange:NSMakeRange(i, 1)];
        if([[unitaryString lowercaseString] isEqualToString:[unitaryStringForAllRights lowercaseString]]){
            rights=rights+values[i];
        }
    }
    
    return rights;
}




#pragma  mark - access control

// The acl method
- (BOOL)actionIsAllowed:(Watt_Action)action on:(WattModel*)model{
    WattGroup*modelGroup=(WattGroup*)[model.registry objectWithUinstID:model.groupID];
    if(model.groupID==0 && model.ownerID==0){
        return YES; // If ownerID and groupID are not defined the operation is allowed.
    }else{
        BOOL authorized=[self actionIsAllowed:action
                                   withRights:model.rights
                                   imTheOwner:[self mIOwnerOf:model]
                            imInTheOwnerGroup:[self mIIntheGroup:modelGroup]];
        
        if(!authorized){
            [[NSNotificationCenter defaultCenter] postNotificationName:WATT_ACTION_IS_NOT_AUTHORIZED_NOTIFICATION_NAME
                                                                object:self
                                                              userInfo:@{@"reference":model,@"action":@(action)}];
        }
        
        
        return authorized;
    }
}


- (BOOL)actionIsAllowed:(Watt_Action)action
             withRights:(NSUInteger)rights
             imTheOwner:(BOOL)owned
      imInTheOwnerGroup:(BOOL)inTheGroup{
    
    WTLog(@"Rights %@ (%@) action %@",[self rightsFromInteger:rights],@(rights),@(action));
    
    NSInteger values[9];
    values[0]=400;
    values[1]=200;
    values[2]=100;
    values[3]=40;
    values[4]=20;
    values[5]=10;
    values[6]=4;
    values[7]=2;
    values[8]=1;
    
    NSInteger hasTheRight[9];
    NSInteger nRights=rights;
    NSUInteger castedAction=(NSUInteger)action;
    
    for (NSInteger i=0; i<9; i++) {
        if(nRights-values[i]>=0){
            nRights=nRights-values[i];
            hasTheRight[i]=1;
        }else{
            hasTheRight[i]=0;
        }
    }
    
    if(owned){
        // The user is the owner
        if(hasTheRight[castedAction+0]==1){
            return YES;
        }
    }else if(inTheGroup){
        // In the group
        if(hasTheRight[castedAction+3]==1){
            return YES;
        }
    }else{
        // Public
        if(hasTheRight[castedAction+6]==1){
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)mIOwnerOf:(WattModel*)model{
    if(model.ownerID==0 || model.groupID==0){
        return YES;
    }
    WattUser*owner=nil;
    if (model.groupID==self.system.uinstID) {
        owner=self.system;
    }else{
        owner=(WattUser*)[model.registry objectWithUinstID:model.groupID];
    }
    if(owner && self.me){
        return [owner isEqual:self.me];
    }
    return NO;
}

- (BOOL)mIIntheGroup:(WattGroup*)group{
    if(!group){
        return YES;
    }else {
        return [[self me].group isEqual:group];
    }
}



@end