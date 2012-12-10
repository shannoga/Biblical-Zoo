//
//  Place.h
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject
@property (nonatomic,retain) NSDate   * createdAt;
@property (nonatomic,retain) NSDate   * updatedAt;
@property (nonatomic,retain) NSString * objectId;
@property (nonatomic,retain) NSNumber * latitude;
@property (nonatomic,retain) NSNumber * longitude;
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * nameEn;
@property (nonatomic,retain) NSNumber * audioGuide;
@end
