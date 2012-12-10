//
//  Animal.h
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
@class Exhibit;

@interface Animal : NSManagedObject
@property (nonatomic,retain) NSString * nameEn;
@property (nonatomic,retain) NSString * exhibitId;
@property (nonatomic,retain) NSString * binomialName;
@property (nonatomic,retain) NSString * bioClass;
@property (nonatomic,retain) NSString * conservationStatus;
@property (nonatomic,retain) NSDate   * createdAt;
@property (nonatomic,retain) NSString * diet;
@property (nonatomic,retain) NSString * family;
@property (nonatomic,retain) NSString * generalDescription;
@property (nonatomic,retain) NSString * habitat;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * objectId;
@property (nonatomic,retain) NSString * socialStructure;
@property (nonatomic,retain) NSDate   * updatedAt;
@property (nonatomic,retain) NSString * verse;
@property (nonatomic,retain) NSString * youTubeUrl;
@property (nonatomic,retain) NSString * zooDescription;
@property (nonatomic,retain) NSString * zooItems;
@property (nonatomic,retain) NSString * local;
@property (nonatomic,retain) Exhibit  * exhibit;
@property (nonatomic,retain) NSNumber * audioGuide;
@property (nonatomic,retain) NSNumber * visible;
@property (nonatomic,retain) NSNumber *  generalExhibitDescription;
+(BOOL)createFromParseAnimalObject:(PFObject*)animal forLocal:(NSString*)local inContext:(NSManagedObjectContext*)context;
+(BOOL)updateFromParseAnimalObject:(PFObject*)animal inContext:(NSManagedObjectContext*)context;
+(NSArray*)findAnimalsWithExhibitId:(NSString*)exhibitIdToFind;
-(NSArray*)images;
-(UIImage*)distributaionMap;
+(NSArray*)allObjects;
@end
