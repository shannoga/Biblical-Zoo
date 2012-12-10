//
//  ExhibitAnimalsViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animal.h"
#import "Exhibit.h"

@interface ExhibitAnimalsViewController : UITableViewController{
}

@property (nonatomic,retain) Exhibit * exhibit;
@property (nonatomic,retain) NSArray * animals;

@end
