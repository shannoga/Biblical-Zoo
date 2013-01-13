//
//  Madad.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 18/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Madad : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * am;
@property (nonatomic, retain) NSNumber * pm;



+(Madad*)madadForDate:(NSDate*)date;
+(void)parseMadadsFromArray:(NSArray*)madads  completion:(void (^)(BOOL finished))completion;
    
@end
