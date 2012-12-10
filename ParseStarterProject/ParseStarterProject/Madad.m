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

@implementation Madad

@dynamic date;
@dynamic am;
@dynamic pm;



+(NSArray*)allObjects{
    NSManagedObjectContext *moc = [NSManagedObjectContext defaultContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:[self description] inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setIncludesPendingChanges:YES];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"date" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        return nil;
    }
    return array;
}

+(void)deleteAllInContext:(NSManagedObjectContext*)moc{
    NSFetchRequest * allEvents = [[NSFetchRequest alloc] init];
    [allEvents setEntity:[NSEntityDescription entityForName:@"Madad" inManagedObjectContext:moc]];
    [allEvents setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * Madads = [moc executeFetchRequest:allEvents error:&error];
    //error handling goes here
    for (Madad * madad in Madads) {
        [moc deleteObject:madad];
    }
    NSError *saveError = nil;
    [moc save:&saveError];
}

/*
+(Madad*)createInContext:(NSManagedObjectContext*)context withType:(NSString*)eventType withCalendaerEntry:(GTLCalendarEvent*)entry{
    
    
    NSManagedObjectModel *managedObjectModel = [[context persistentStoreCoordinator] managedObjectModel];
    NSEntityDescription *entity = [managedObjectModel entitiesByName][@"Madad"];
    Madad *newMadad = (Madad*) [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    NSString *ampmString = @"test";//[[entry title] stringValue];
    NSArray *ampm = [ampmString componentsSeparatedByString:@","];
    
    newMadad.am = @([ampm[0]intValue]);
    newMadad.pm = @([ampm[1]intValue]);
    
   // GDataWhen *when = [[entry times] lastObject];
   // GDataDateTime *startTime = [when startTime];
    
    newMadad.date = [NSDate date];//[startTime date];
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return newMadad;
}
 */

+(Madad*)madadForDate:(NSDate*)date{
  
        NSArray *allMadadForDate = [self  allObjects];
        __block Madad *madad;
        __block Madad *foundMadad;
        [allMadadForDate enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             madad = (Madad*)obj;
            if ([madad.date isEqualToDateIgnoringTime:date]) {
                foundMadad = madad;
                 *stop = YES;
            }
        }];
    
    
    return foundMadad;

}




@end
