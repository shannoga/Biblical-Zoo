//
//  QuestionAnswerPopupViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/17/14.
//
//

#import <UIKit/UIKit.h>

@interface QuestionAnswerPopupViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *answerTextView;
@property (nonatomic,strong) PFObject *questionObject;
@end
