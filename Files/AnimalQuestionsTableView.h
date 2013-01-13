//
//  AnimalQuestionsTableView.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/21/12.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface AnimalQuestionsTableView :PFQueryTableViewController <MBProgressHUDDelegate>{
    MBProgressHUD *refreshHUD;
    BOOL askingQuestion;
}
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *cityTF;
@property (nonatomic, strong) UIView *fieldsView;
@end
