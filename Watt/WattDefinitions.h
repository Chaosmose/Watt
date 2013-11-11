//
//  WattDefinitions.h
//  Watt
//
//  Created by Benoit Pereira da Silva on 03/11/2013.
//
//


#ifndef WattDefinitions_h
#define WattDefinitions_h


typedef enum WattSerializationModes{
    WattJx=0,   // Json + soup      * Default
    WattJ=1,    // Json  + no soup
    WattPx=2,   // Plist + soup
    WattP=3     // Plist + no soup
    // We plan to add Message Pack + soup
}WattSerializationMode;


//  WT_CODING_KEYS

#define __uinstID__             @"i"
#define __className__           @"c"
#define __properties__          @"p"
#define __collection__          @"cl"
#define __isAliased__           @"a"


// WT_CONST
#define kCategoryNameShared         @"shared"
#define kWattMe                     @"user-me"
#define kWattMyGroup                @"my-group"
#define kWattMyGroupName            @"users"

#endif
