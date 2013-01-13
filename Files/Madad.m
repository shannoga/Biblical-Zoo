//
//  Madad.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 18/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "Madad.h"
#import "NSDate-Utilities.h"
#import "JerusalemBiblicalZooAppDelegate.h"
#import "CGICalendar.h"

#define START_DATE @"DTSTART"
#define TITLE @"SUMMARY"

@implementation Madad

@dynamic date;
@dynamic am;
@dynamic pm;



+(void)createMadad:(CGICalendarComponent*)eventComponent{
    //set the start date
    NSDate * sDate = [self dateFromICSString:[[eventComponent propertyForName:START_DATE] value]];

        if(sDate!=nil) {
            if([sDate isLaterThanDate:[NSDate date]] || [sDate isToday]){
            Madad *madad = [Madad createInContext:[NSManagedObjectContext defaultContext]];
            madad.date = sDate;
            NSString *ampmString = [[eventComponent propertyForName:TITLE] value];
            NSArray *ampm = [ampmString componentsSeparatedByString:@","];
                if(ampm.count>1){
                    madad.am = @([ampm[0]intValue]);
                    madad.pm = @([ampm[1]intValue]);
                }
        }
    }
}


+(void)parseMadadsFromArray:(NSArray*)madads  completion:(void (^)(BOOL finished))completion{
    for (CGICalendarComponent *eventComp in madads) {
              [self createMadad:eventComp];
    }
    
    BOOL finished = YES;
    if (completion) {
        completion(finished);
    }
    
}

+(NSDate*)dateFromICSString:(NSString*)dateString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
    
}



+(Madad*)madadForDate:(NSDate*)date{  
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@",date];
    return  (Madad*)[Madad findFirstWithPredicate:predicate];

}




@end
