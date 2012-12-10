//
//  AnimalDataTableView.h
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import <UIKit/UIKit.h>
#import "Animal.h"
@interface AnimalDataTableView : UIView <UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *tableViewdata;
   
}
@property (nonatomic,assign) Animal *animal;
- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal;
@end
