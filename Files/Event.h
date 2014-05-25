//
//  Event.h
//  ParseStarterProject
//
//  Created by shani hajbi on 15/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Constants.h"

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * typeString;
@property (nonatomic, retain) NSDate   *startDate;
@property (nonatomic, retain) NSDate   *endDate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* eventDescription;
@property (nonatomic, retain) NSString* location;

+(EventTypes)eventTypeFromString:(NSString*)string;
+(void)parseEventsFromArray:(NSArray*)events forClendarName:(NSString*)calendarName completion:(void (^)(BOOL finished))completion;
+(NSString*)localStringFromDoubleLangString:(NSString*)title;
+(NSDate*)finalDateFromGeneratedStartDate:(NSDate*)sDate originalDate:(NSDate*)originalDate;
-(NSString*)dateToStringForSectionTitels;
-(NSString*)timeAsString;
-(NSString*)dateAsString;
-(NSArray*)colors;
-(UIImage*)icon;

@end