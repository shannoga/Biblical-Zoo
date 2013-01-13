//
//  ParseHelper.h
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseHelper : NSObject;

+(BOOL)existOnLocalDBForEntityName:(NSString*)entityName byObjectId:(NSString*)animalObjectId inContext:(NSManagedObjectContext*)context;

@end
