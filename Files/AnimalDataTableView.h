//
//  AnimalDataTableView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>
#import "Animal.h"
@interface AnimalDataTableView : UITableViewController{
    NSMutableArray *tableViewdata;
   
}
@property (nonatomic,assign) Animal *animal;
- (id)initWithStyle:(UITableViewStyle)style withAnimal:(Animal*)anAnimal;
@end
