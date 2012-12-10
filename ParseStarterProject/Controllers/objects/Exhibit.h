//
//  Exhibit.h
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Place.h"
#import <Parse/Parse.h>
@class Animal;

@interface ImageToDataTransformer : NSValueTransformer {
}
@end
@interface Exhibit : Place

@property (nonatomic,retain) NSSet *animals;
@property (nonatomic, retain) UIImage *mapIcon;
@property (nonatomic, retain) NSNumber *manyAnimals;

+(NSArray*)allObjects;
+(BOOL)createFromParseExhibitObject:(PFObject*)exhibit inContext:(NSManagedObjectContext*)context;
+(BOOL)updateFromParseExhibitObject:(PFObject*)exhibit inContext:(NSManagedObjectContext*)context;
+(Exhibit*)findExhibitWithId:(NSString*)exhibitId;
-(NSArray*)localAnimals;
@end

@interface Exhibit (CoreDataGeneratedAccessors)
- (void)addAnimalsObject:(Animal *)value;
- (void)removeAnimalsObject:(Animal *)value;
- (void)addAnimals:(NSSet *)values;
- (void)removeAnimals:(NSSet *)values;
-(UIImage*)icon;
-(NSArray*)colors;
@end
