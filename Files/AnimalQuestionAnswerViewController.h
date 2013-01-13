//
//  AnimalQuestionAnswerViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/1/13.
//
//

#import <UIKit/UIKit.h>

@interface AnimalQuestionAnswerViewController : UIViewController
@property (nonatomic, strong) PFObject *questionObject;
@property (nonatomic, strong) IBOutlet UILabel *questionLabel;
@property (nonatomic, strong) IBOutlet UITextView *answerTextView;
@end
