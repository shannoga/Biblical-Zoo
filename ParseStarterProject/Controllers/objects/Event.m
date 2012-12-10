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

+(void)createEvent:(CGICalendarComponent*)eventComponent calendarName:(NSString*)calendarName startDate:(NSDate*)startDate{
    //set the start date
  

        Event *event = [Event createEntity];
    
        NSDate * sDate = [self dateFromICSString:[[eventComponent propertyForName:START_DATE] value]];
        NSDate *finalDate = [self finalDateFromGeneratedStartDate:startDate originalDate:sDate];
    
        event.startDate = finalDate;
        
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
        
        
}
+(void)parseEventsFromArray:(NSArray*)events forClendarName:(NSString*)calendarName{
    
    
    for (CGICalendarComponent *eventComp in events) {
        NSDate * sDate = [self dateFromICSString:[[eventComp propertyForName:START_DATE] value]];
        
        if ([eventComp isEvent] && sDate) {
            NSString * repeat = [[eventComp propertyForName:REAPET] value];
            if(repeat){
                    NSDictionary *dic = [self repeatDictionaryFromString:repeat];
                    NSArray *datesArray = [self repeatEventsDatesArrayWithDictionary:dic];
                    for (NSDate *date in datesArray) {
                        [self createEvent:eventComp calendarName:calendarName startDate:date];
                        NSLog(@"datesArray= %@",datesArray);
                    }
                }
            }
        }
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
        repaetDictionary[keyVal[0]] = keyVal[1];
    }
    NSLog(@"repaetDictionary = %@",repaetDictionary);

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
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSWeekdayCalendarUnit) fromDate:originalDate];
    [weekdayComponents setHour:sDate.hour];
    [weekdayComponents setMinute:sDate.minute];
    [weekdayComponents setDay:originalDate.day];
    [weekdayComponents setMonth:originalDate.month];
    [weekdayComponents setYear:originalDate.year];
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
        return kEventTypeFeeding;
    }else if ([string isEqualToString:@"Workshop"]) {
        return kEventTypeFeeding;
    }
    return returnedType;
}

-(NSArray*)colors{
    
    NSArray * cellColors;
    
    switch ([self.type intValue]) {
        case kEventTypeFeeding:
            cellColors = @[(id)[UIColorFromRGB(0x5e939d) CGColor],//feedings
                          (id)[UIColorFromRGB(0x5e939d) CGColor]];
            break;
        case kEventTypeExhibition:
            cellColors = @[(id)[UIColorFromRGB(0x91bbc0) CGColor],
                          (id)[UIColorFromRGB(0x91bbc0) CGColor]];
            break;
        case kEventTypeKids:
            cellColors = @[(id)[UIColorFromRGB(0x6db472) CGColor],//kids
                          (id)[UIColorFromRGB(0x6db472) CGColor]];
            break;
        case kEventTypeMusic:
            cellColors = @[(id)[UIColorFromRGB(0xFF733B) CGColor],
                          (id)[UIColorFromRGB(0xFF733B) CGColor]];
            break;
        case kEventTypeShow:
            cellColors = @[(id)(id)[UIColorFromRGB(0xFFCC41) CGColor],
                          (id)[UIColorFromRGB(0xFFCC41) CGColor]];
            break;
        case kEventTypeWorkShop:
            cellColors = @[(id)[UIColorFromRGB(0xA86EAD) CGColor],
                          (id)[UIColorFromRGB(0xA86EAD) CGColor]];
            break;
            
    }
    
    
    return cellColors;
}


-(UIImage*)icon{
    UIImage *cellImage= [UIImage imageNamed:[NSString stringWithFormat:@"event_%@.png",[self.typeString lowercaseString]]];
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


-(NSString*)hebrewDataToStringForMonth:(NSInteger)monthIndex andDay:(NSInteger)dayIndex{
    NSString* hebrewDate;
    NSArray * daysNames;
    NSArray * monthesNames;
    
    daysNames = @[@"א",@"ב",@"ג",@"ד",@"ה",@"ו",@"ז",@"ח",@"ט",@"י",@"יא",@"יב",@"יג",@"יד",@"יז",@"טו",@"טז",@"יח",@"יט",@"כ",@"כא",@"כב",@"כג",@"כד",@"כה",@"כו",@"כז",@"כח",@"כט",@"ל",@"לא",@"לב"];
    monthesNames= @[@"תשרי",@"חשוון",@"כסלו",@"טבת",@"שבט",@"אדר",@"ניסן",@"אייר",@"סיון",@"תמוז",@"אב",@"אלול"];
    
    
    hebrewDate = [NSString stringWithFormat:@"%@ %@",daysNames[dayIndex],monthesNames[monthIndex]];
    
    return hebrewDate; 
}


-(NSString*)dateToStringForSectionTitels{
	NSString *formattedDateString;

    NSDate *localDate = [self.startDate toLocalTime];
  
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[Helper currentLang]]];
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
		formattedDateString = [dateFormatter stringFromDate:localDate];
    


    return formattedDateString;
}
/*

 if([localDate isToday]) {
 formattedDateString = NSLocalizedString(@"Today",nil);
 }else{

-(NSString*)dateToStringForSectionTitels{
	NSString *formattedDateString;
    
    NSDate *localDate = [self.startDate toLocalTime];
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    formattedDateString = [dateFormatter stringFromDate:localDate];
    
    return [NSString stringWithFormat:@"%@",localDate];
    
    return formattedDateString;
}

 */


@end
