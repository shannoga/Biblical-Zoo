//
//  Event.m
//  ParseStarterProject
//
//  Created by shani hajbi on 15/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "Event.h"
#import "Constants.h"
#import "NSDate-Utilities.h"
#import "CGICalendar.h"

@interface Event(Private)

@end

@implementation Event

@dynamic type;
@dynamic typeString;
@dynamic startDate;
@dynamic title;
@dynamic eventDescription;
@dynamic location;


#define END_DATE @"DTEND"
#define START_DATE @"DTSTART"
#define TITLE @"SUMMARY"
#define LOCATION @"LOCATION"
#define DESCRIPTION @"DESCRIPTION"
#define REAPET @"RRULE"
#define DAYS_ARRAY  @[@"SU",@"MO",@"TU",@"WE",@"TH",@"FR",@"SA"]


#define REAPET_DAYES @"BYDAY"
#define REAPET_FREQ @"FREQ"
#define REAPET_UNTIL @"UNTIL"

+(void)createEvent:(CGICalendarComponent*)eventComponent calendarName:(NSString*)calendarName startDate:(NSDate*)startDate isReapeater:(BOOL)reapeter{
    //set the start date
    NSDate * sDate = [self dateFromICSString:[[eventComponent propertyForName:START_DATE] value]];
   
    Event *event = [Event createInContext:[NSManagedObjectContext defaultContext]];
    if(reapeter) {
      
        NSDate *finalDate = [self finalDateFromGeneratedStartDate:startDate originalDate:sDate];
        event.startDate = finalDate;
    }else{
        event.startDate = [sDate toLocalTime];
    }
        //get the title
        NSString * rowTitle = [[eventComponent propertyForName:TITLE] value];
        NSString *localTitle = [self localStringFromDoubleLangString:rowTitle];
        event.title = localTitle;
        
        //set the description
        NSString * rowDescription = [[eventComponent propertyForName:DESCRIPTION] value];
        NSString *localDescription = [self localStringFromDoubleLangString:rowDescription];
        event.eventDescription = localDescription;
        
        
        //set the location
        NSString * rowLocation = [[eventComponent propertyForName:LOCATION] value];
        NSString *localLocation = [self localStringFromDoubleLangString:rowLocation];
        event.location = localLocation;
        
        
        //set the type
        
        NSString *cleanedCalendarName = [self cleanCalendarTitle:calendarName];
        event.typeString = cleanedCalendarName;
        event.type = [NSNumber numberWithInt:[Event eventTypeFromString:cleanedCalendarName]];
    
   // [[NSManagedObjectContext defaultContext] saveNestedContexts];

}

+(void)parseEventsFromArray:(NSArray*)events forClendarName:(NSString*)calendarName completion:(void (^)(BOOL finished))completion{

    for (CGICalendarComponent *eventComp in events) {
        NSDate * sDate = [self dateFromICSString:[[eventComp propertyForName:START_DATE] value]];
        
        if ([eventComp isEvent] && sDate) {
            NSString * repeat = [[eventComp propertyForName:REAPET] value];
            if(repeat!=NULL){
                NSDictionary *dic = [self repeatDictionaryFromString:repeat];
                NSArray *datesArray = [self repeatEventsDatesArrayWithDictionary:dic];
                NSArray *filteredDates = [self removeOldDatesFromArray:datesArray];
                
                for (NSDate *date in filteredDates) {
                    [self createEvent:eventComp calendarName:calendarName startDate:date isReapeater:YES];
                }
            }else{
                NSDate * sDate = [self dateFromICSString:[[eventComp propertyForName:START_DATE] value]];
                if ([sDate isLaterThanDate:[NSDate date]] || [sDate isToday]) {
                    [self createEvent:eventComp calendarName:calendarName startDate:nil isReapeater:NO];
                }
            
            }
        }
    }
   
    BOOL finished = YES;
    if (completion) {
        completion(finished);
    }
}

+(NSArray*)removeOldDatesFromArray:(NSArray*)datesArray{
    NSMutableArray *mutable =[NSMutableArray array];
    for (NSDate *date in datesArray) {
        if([date isLaterThanDate:[NSDate date]] || [date isToday] ){
            [mutable addObject:date];
        }else{
            //NSLog(@"date %@ is in the past",date);
        }
    }
    //NSLog(@"befor count = %i | after count = %i",[datesArray count],[mutable count]);
    return [NSArray arrayWithArray:mutable];
    
}

+(NSArray*)repeatEventsDatesArrayWithDictionary:(NSDictionary*)dic{
    NSMutableArray *allDatesForReapeter = [NSMutableArray array];
    
    NSString *reapetFreq = dic[REAPET_FREQ];
    NSString *reapetDays = dic[REAPET_DAYES];
    NSDate * repeatEndDate = [self dateFromICSString:dic[REAPET_UNTIL]];
    //gat all the first days to reapet
    NSArray *starterDates = [self reapeterStarterDates:reapetDays];
    
    //add the first dates to the array
    
    if ([reapetFreq isEqualToString:@"WEEKLY"]) {
        for (NSDate *date in starterDates) {
            NSArray * datesSet = [self datesSetForWeeklyRepeaterWithStartDate:date EndDate:repeatEndDate];
            [allDatesForReapeter addObjectsFromArray:datesSet];
        }
    }else if([reapetFreq isEqualToString:@"DAILY"]){
        
    }
    return [NSArray arrayWithArray:allDatesForReapeter];
}

+(NSArray*)reapeterStarterDates:(NSString*)days{

    NSMutableArray * repeaterStartDayes = [NSMutableArray array];
    NSArray * array = [days componentsSeparatedByString:@","];
    
    for (NSString*day in array) {
        NSInteger weekday = [self weekDayFromString:day];
        NSDate *date  = [self nextDayInWeekForDay:weekday];
        [repeaterStartDayes addObject:date];
    }
    return [NSArray arrayWithArray:repeaterStartDayes];
}
+(NSArray*)datesSetForWeeklyRepeaterWithStartDate:(NSDate*)startDate EndDate:(NSDate*)endDate{

    NSMutableArray *datesArray = [@[startDate]mutableCopy];
    NSDate *futureDate=nil;
    for (NSInteger i=0; i<4; i++) {
        futureDate = [startDate dateByAddingDays:(i+1)*7];
        [datesArray addObject:futureDate];
    }
    return [NSArray arrayWithArray:datesArray];
}

+(NSDictionary*)repeatDictionaryFromString:(NSString*)string{

    NSMutableDictionary *repaetDictionary = [NSMutableDictionary dictionary];
    NSArray *components = [string componentsSeparatedByString:@";"];
    
    for (NSString * component in components) {
        
        NSArray * keyVal = [component componentsSeparatedByString:@"="];
        if(keyVal.count>1){
        repaetDictionary[keyVal[0]] = keyVal[1];
        }
    }
   // NSLog(@"repaetDictionary = %@",repaetDictionary);
    return [NSDictionary dictionaryWithDictionary:repaetDictionary];
}

+(NSDate*)nextDayInWeekForDay:(NSInteger)dayInteger{

    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSWeekdayCalendarUnit | NSHourCalendarUnit fromDate:now];
    NSInteger weekday = [dateComponents weekday];
    
    NSDate *nextDay = nil;
    if (weekday == dayInteger) {
        nextDay = now;
    }
    else  {
        NSInteger daysGap = dayInteger-weekday;
        if (daysGap<0) {
            daysGap = 7+daysGap;
        }
        nextDay = [NSDate dateWithDaysFromNow:daysGap];
    }
    return nextDay;
}

+(NSDate*)finalDateFromGeneratedStartDate:(NSDate*)sDate originalDate:(NSDate*)originalDate{
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [[NSDateComponents alloc] init];

    [weekdayComponents setHour:originalDate.hour];
    [weekdayComponents setMinute:originalDate.minute];
    [weekdayComponents setDay:sDate.day];
    [weekdayComponents setMonth:sDate.month];
    [weekdayComponents setYear:sDate.year];
    NSDate *date = [gregorian dateFromComponents:weekdayComponents];
    return date;
}

+(NSInteger)weekDayFromString:(NSString*)str{
   __block NSUInteger weekDay = 0;
    [DAYS_ARRAY enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:str]) {
            weekDay = idx+1;
            *stop =YES;
        }
    }];
    return weekDay;
}


+(NSString*)cleanCalendarTitle:(NSString*)title{
    NSString *cleanedTitle = title;
    if ([title hasSuffix:@"s"]&&![title isEqualToString:@"Kids"]){
        cleanedTitle = [title  substringToIndex:[title length] - 1];
    }
    return cleanedTitle;
}


+(NSString*)localStringFromDoubleLangString:(NSString*)title{
    NSArray *titels = [title componentsSeparatedByString:@"|"];
    if ([titels count]) {
        
        NSString *title;
        if ([Helper isRightToLeft]) {
            title = titels[0];
        }else{
            if ([titels count]>1){
                title = titels[1]; 
            }else{
                 title = NSLocalizedString(@"No Valeu", nil);
            }
        }
        return title;
    }
    return nil;
}


+(NSDate*)dateFromICSString:(NSString*)dateString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss'Z'"];
    NSDate *date = [dateFormat dateFromString:dateString];
    return date;
    
}

-(NSString*)timeAsString{
    NSDate *startDate = [self startDate];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    
    NSString *theTime = [timeFormat stringFromDate:startDate];
    return theTime;
    
}
-(NSString*)dateAsString{
    NSDate *startDate = [self startDate];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yy"];
    
    NSString *theDate = [dateFormat stringFromDate:startDate];
    return theDate;
    
}



+(EventTypes)eventTypeFromString:(NSString*)string{
    EventTypes returnedType = 0;
    if ([string isEqualToString:@"Feeding"]) {
        return kEventTypeFeeding;
    }else if ([string isEqualToString:@"Exhibition"]) {
        return kEventTypeExhibition;
    }else if ([string isEqualToString:@"Kids"]) {
        return kEventTypeKids;
    }else if ([string isEqualToString:@"Music"]) {
        return kEventTypeMusic;
    }else if ([string isEqualToString:@"Show"]) {
        return kEventTypeShow;
    }else if ([string isEqualToString:@"Workshop"]) {
        return kEventTypeWorkShop;
    }
    return returnedType;
}

-(NSArray*)colors{
    NSArray * cellColors;
    switch ([self.type intValue]) {
        case kEventTypeFeeding:
            cellColors = @[(id)[UIColorFromRGB(0xDED4C8) CGColor],//feedings
                          (id)[UIColorFromRGB(0xDED4C8) CGColor]];
            //0x8C817B nice purple brown color
            break;
        case kEventTypeExhibition:
            cellColors = @[(id)[UIColorFromRGB(0xBDB38C) CGColor],
                          (id)[UIColorFromRGB(0xBDB38C) CGColor]];
            break;
        case kEventTypeKids:
            cellColors = @[(id)[UIColorFromRGB(0xD4963E) CGColor],//kids
                          (id)[UIColorFromRGB(0xD4963E) CGColor]];
            break;
        case kEventTypeMusic:
            //0x749FC1 nice blue 
            cellColors = @[(id)[UIColorFromRGB(0x62736F) CGColor],
                          (id)[UIColorFromRGB(0x62736F) CGColor]];
            break;
        case kEventTypeShow:
            cellColors = @[(id)(id)[UIColorFromRGB(0xBDB38C) CGColor],
                          (id)[UIColorFromRGB(0xBDB38C) CGColor]];
            break;
        case kEventTypeWorkShop:
            cellColors = @[(id)[UIColorFromRGB(0x7F7960) CGColor],
                          (id)[UIColorFromRGB(0x7F7960) CGColor]];
            break;
            
    }
    
    return cellColors;
}


-(UIImage*)icon{
    UIImage *cellImage;
   
    cellImage= [UIImage imageNamed:[NSString stringWithFormat:@"event_%@.png",[self.typeString lowercaseString]]];
    if (cellImage==nil) {
        cellImage= [UIImage imageNamed:@"event_special.png"];
    }
    
    return cellImage;
    
}


-(NSString*)dateToString{
    
	  NSString *formattedDateString;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self.startDate];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate]) {
		formattedDateString = NSLocalizedString(@"Today", nil);
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[Helper currentLang]]];
		formattedDateString = [dateFormatter stringFromDate:self.startDate];
    }
    return formattedDateString;
}

/*
-(NSString*)hebrewDataToStringForMonth:(NSInteger)monthIndex andDay:(NSInteger)dayIndex{
    NSString* hebrewDate;
    NSArray * daysNames;
    NSArray * monthesNames;
    
    daysNames = @[@"א",@"ב",@"ג",@"ד",@"ה",@"ו",@"ז",@"ח",@"ט",@"י",@"יא",@"יב",@"יג",@"יד",@"יז",@"טו",@"טז",@"יח",@"יט",@"כ",@"כא",@"כב",@"כג",@"כד",@"כה",@"כו",@"כז",@"כח",@"כט",@"ל",@"לא",@"לב"];
    monthesNames= @[@"תשרי",@"חשוון",@"כסלו",@"טבת",@"שבט",@"אדר",@"ניסן",@"אייר",@"סיון",@"תמוז",@"אב",@"אלול"];
    
    
    hebrewDate = [NSString stringWithFormat:@"%@ %@",daysNames[dayIndex],monthesNames[monthIndex]];
    
    return hebrewDate; 
}
*/

-(NSString*)dateToStringForSectionTitels{
	NSString *formattedDateString;

    NSDate *localDate = [self.startDate toLocalTime];
  
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[Helper currentLang]]];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
		formattedDateString = [dateFormatter stringFromDate:localDate];
    


    return formattedDateString;
}


@end
