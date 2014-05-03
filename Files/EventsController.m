//
//  EventsController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/2/14.
//
//

#import "EventsController.h"
#import "MXLCalendarManager.h"
#import "Event.h"
#import "NSDate-Utilities.h"


@interface EventsController()
@property (nonatomic,strong) MXLCalendarManager *calendarManager;
@property (nonatomic,strong) NSArray *calendarURLs;
@property (nonatomic,strong) NSDictionary *calendarsName;

@property (nonatomic,strong) NSTimer *timeout;
@property (nonatomic, copy) requestCompletioHandler completionHandler;


@end

@implementation EventsController

+ (id)sharedController {
    static EventsController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[self alloc] init];
    });
    return sharedController;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSArray*)calendarURLs
{
    if (!_calendarURLs) {
        _calendarURLs = @[
                          @{@"url":@"https://www.google.com/calendar/ical/h6e63v9e90ekuv35jbhh8qmgbc%40group.calendar.google.com/public/basic.ics",@"name":@"Feeding"},
                          @{@"url":@"https://www.google.com/calendar/ical/r3mos73aqqvud1du3bn42mpsmo%40group.calendar.google.com/public/basic.ics",@"name":@"Music"},
                          @{@"url":@"https://www.google.com/calendar/ical/hvft2h1m5dpgui1o8lgueoemto%40group.calendar.google.com/public/basic.ics",@"name":@"Show"},
                          @{@"url":@"https://www.google.com/calendar/ical/36f9lqe80tg3f23peaid7m4asc%40group.calendar.google.com/public/basic.ics",@"name":@"Talk"},
                          @{@"url":@"https://www.google.com/calendar/ical/k2nk1v47vt0dk8l0pkufdigrug%40group.calendar.google.com/public/basic.ics",@"name":@"Exhibition"},
                          @{@"url":@"https://www.google.com/calendar/ical/biblicalzoo%40gmail.com/public/basic.ics",@"name":@"Feeding"},
                          @{@"url":@"https://www.google.com/calendar/ical/eh8h86b49r6hjp9nc31orrjpb8%40group.calendar.google.com/public/basic.ics",@"name":@"Lion"},//lion
                          ];
    }
    
    return _calendarURLs;
}

- (MXLCalendarManager*)calendarManager
{
    if(!_calendarManager)
    {
       _calendarManager = [[MXLCalendarManager alloc] init];
    }
    return _calendarManager;
}

- (void)startTimeoutTimer
{
    self.timeout = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopRequest:) userInfo:nil repeats:NO];
}

- (void)fetchEventsWithCompletionHandler:(requestCompletioHandler)handler
{
    self.completionHandler = handler;
    [Event truncateAll];
    [[NSManagedObjectContext defaultContext] saveInBackgroundErrorHandler:^(NSError *error) {
        if (self.completionHandler)
        {
            self.completionHandler(NO);
        }
    } completion:^{
        [self startTimeoutTimer];
        __block NSUInteger counter = 0;
        [self.calendarURLs enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL *stop) {
            NSURL *url = [NSURL URLWithString:obj[@"url"]];
            [self.calendarManager scanICSFileAtRemoteURL:url  withCompletionHandler:^(MXLCalendar *calendar, NSError *error) {
                [self storeWeeklyEventsForCalendar:calendar calendarName:obj[@"name"]  completionBlock:^{
                    counter += 1;
                    if (counter == _calendarURLs.count) {
                        [self.timeout invalidate];
                        if (self.completionHandler) {
                            self.completionHandler(YES);
                        }
                        
                    }
                    
                }];
            }];
            
        }];
    }];
}

- (void)stopRequest:(NSTimer*)timer
{
    [timer invalidate];
    if (self.completionHandler)
    {
        self.completionHandler(NO);
        self.completionHandler = nil;
    }
}


- (void)storeWeeklyEventsForCalendar:(MXLCalendar*)calendar calendarName:(NSString*)calendarName completionBlock:(void(^)(void))completionBlock
{
    
    // Run on a background thread
    
        // If the day hasn't already loaded events...
    NSUInteger dayNumber = 0;
    while (dayNumber < 7) {
        NSDate *date = [NSDate dateWithDaysFromNow:dayNumber];
        if (![calendar hasLoadedAllEventsForDate:date]) {
            // Loop through each event and check whether it occurs on the selected date
            for (MXLCalendarEvent *event in calendar.events) {
                // If it does, save it for the date
                if ([event checkDate:date]) {
                    [calendar addEvent:event onDate:date];
                }
            }
            // Set that the calendar HAS loaded all the events for today
            [calendar loadedAllEventsForDate:date];
        }
        
        // load up the events for today
        NSMutableArray * arr = [calendar eventsForDate:date];
        [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            MXLCalendarEvent *calendarEvent =  (MXLCalendarEvent*)obj;
            Event *event = [Event createInContext:[NSManagedObjectContext defaultContext]];
            event.startDate = [Event finalDateFromGeneratedStartDate:date originalDate:calendarEvent.eventStartDate];
            event.eventDescription = [Event localStringFromDoubleLangString:calendarEvent.eventDescription];
            event.location = [Event localStringFromDoubleLangString:calendarEvent.eventLocation];
            event.title = [Event localStringFromDoubleLangString:calendarEvent.eventSummary];
            event.type = @([Event eventTypeFromString:calendarName]);
            event.typeString = calendarName;

            
        }];

        dayNumber ++;
    }
        completionBlock();
}






@end
