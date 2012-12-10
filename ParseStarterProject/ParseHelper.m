//
//  ParseHelper.m
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "ParseHelper.h"
#import <Parse/Parse.h>
#import "Animal.h"
#import "Exhibit.h"

@implementation ParseHelper



+(BOOL)existOnLocalDBForEntityName:(NSString*)entityName byObjectId:(NSString*)animalObjectId inContext:(NSManagedObjectContext*)context{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    
    NSPredicate *predicare = [NSPredicate predicateWithFormat:@"objectId == %@",animalObjectId];
    [request setPredicate:predicare];
    
    [request setIncludesPendingChanges:YES];
    
    NSError *err;
    NSUInteger count = [context countForFetchRequest:request error:&err];
    if(count == 0) {
        return NO;
    }
    NSLog(@"entityName count = %i",count);
    return YES;
}

+(BOOL)objectExistOnParseForObjectId:(NSString*)objectId inClass:(NSString*)className{
    PFQuery *query = [PFQuery queryWithClassName:className];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    [query whereKey:@"objectId" greaterThan:objectId];
    return  [query countObjects]>0;
}

@end
