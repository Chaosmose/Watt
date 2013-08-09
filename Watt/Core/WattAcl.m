//
//  WattAcl.m
//  PlayerSample
//
//  Created by Benoit Pereira da Silva on 10/07/13.
//  Copyright (c) 2013 Pereira da Silva. All rights reserved.
//

#import "WattAcl.h"

#import "WTMModel.h"
#import "WTMGroup.h"
#import "WattApi.h"

@implementation WattAcl


#pragma mark - rights facilities

- (void)setUpRights:(NSUInteger)rights
           andOwner:(WTMUser*)owner
                for:(WTMModel*)model{
    if(!model)
        [wattAPI raiseExceptionWithFormat:@"WattAcl attempt to setup rights on void model"];
    model.rights=rights;
    if(owner){
        model.ownerID=owner.uinstID;
        model.groupID=owner.group.uinstID;
    }
}

/*
 
 @"RWXRWXRWX"
 
 OWNER 400-200-100
 GROUP 40-20-10
 OTHERS 4-2-1
 
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
- (BOOL)actionIsAllowed:(Watt_Action)action on:(WTMModel*)model{
        WTMGroup*modelGroup=(WTMGroup*)[model.registry objectWithUinstID:model.groupID];
        return [self actionIsAllowed:action
                         withRights:model.rights
                         imTheOwner:[self mIOwnerOf:model]
                  imInTheOwnerGroup:[self mIIntheGroup:modelGroup]];
}


- (BOOL)actionIsAllowed:(Watt_Action)action
            withRights:(NSUInteger)rights
            imTheOwner:(BOOL)owned
     imInTheOwnerGroup:(BOOL)inTheGroup{
         
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

- (BOOL)mIOwnerOf:(WTMModel*)model{
    WTMUser*owner=(WTMUser*)[model.registry objectWithUinstID:model.groupID];
    if(owner && [wattAPI me]){
        return [owner.identity isEqualToString:[wattAPI me].identity];
    }
    return NO;
}

- (BOOL)mIIntheGroup:(WTMGroup*)group{
    if(!group){
        return YES;
    }else{
        return [[wattAPI me].group isEqual:group];
    }
}


@end
