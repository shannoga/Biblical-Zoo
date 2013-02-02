//
//  AnimalSpecificQuestionsTableView.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/20/13.
//
//

#import <UIKit/UIKit.h>
#import "AnimalViewController.h"

@interface AnimalSpecificQuestionsTableView : UIView<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *refreshHUD;
}

@property (nonatomic,assign) Animal *animal;
@property (nonatomic,strong) NSArray *tableViewdata;
@property (nonatomic, strong) AnimalViewController *parentController;
- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal withParentController:(AnimalViewController*)animalController;


@end
