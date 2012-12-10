//
//  ExhibitAnnotation.h
//  ParseStarterProject
//
//  Created by shani hajbi on 15/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exhibit.h"

@interface ExhibitAnnotation : NSObject<MKAnnotation>

@property (nonatomic,strong) Exhibit * exhibit;



@end
