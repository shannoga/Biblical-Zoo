//
//  AnimalPostsTableViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 7/30/13.
//
//

#import <Parse/Parse.h>
@interface AnimalPostsTableViewController : PFQueryTableViewController<MBProgressHUDDelegate>{
    MBProgressHUD *refreshHUD;
    BOOL askingQuestion;
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *cityTF;
@property (nonatomic, strong) UIView *fieldsView;
 - (id)initWithStyle:(UITableViewStyle)style forAnimal:(Animal*)anAnimal;
@end
