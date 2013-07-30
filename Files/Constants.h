//
//  Constants.h
//  ParseStarterProject
//
//  Created by shani hajbi on 14/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

typedef enum EventTypes : NSUInteger{
    kEventTypeFeeding,
    kEventTypeTalk,
    kEventTypeMusic,
    kEventTypeKids,
    kEventTypeExhibition,
    kEventTypeShow,
    kEventTypeWorkShop
}EventTypes;


typedef enum ConservationStatus : NSUInteger {
    ConEX,
    ConEW,
    ConCR,
    ConEN,
    ConVU,
    ConNT,
    ConLC
} ConservationStatus;

typedef enum Langs : NSUInteger{
    kEnglish,
    kHebrew
}Langs;

/*
 *  Detect iphone 5 Macro
 */
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

/*
 *  System Versioning Preprocessor Macros
 */ 

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

