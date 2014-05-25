//
//  QuestionAnswerPopupViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/17/14.
//
//

#import "QuestionAnswerPopupViewController.h"

@interface QuestionAnswerPopupViewController ()

@end

@implementation QuestionAnswerPopupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
          self.answerTextView.textAlignment = [Helper appLang]==kHebrew ?NSTextAlignmentRight : NSTextAlignmentLeft;
    self.view.layer.cornerRadius = 10;
    if (self.questionObject)
    {
        NSString *directionalString;
        NSString *key = [Helper appLang]==kHebrew? @"question":@"question_en";
        NSString *quest = self.questionObject[key];
        if(quest != nil && [Helper appLang]==kHebrew){
            directionalString = [@"\u200F" stringByAppendingString:quest];
        }else if([Helper appLang]==kHebrew){
            directionalString=@"";
        }else{
            directionalString=quest;
        }
        
        //[self.questionLabel setText:directionalString];
        
        key = [Helper appLang]==kHebrew? @"answer":@"answer_en";
        NSString *answer = self.questionObject[key];
        if(answer != nil && [Helper appLang]==kHebrew){
            directionalString = [@"\u200F" stringByAppendingString:answer];
        }else if([Helper appLang]==kHebrew){
            directionalString=@"";
        }else{
            directionalString=answer;
        }
        self.answerTextView.text = directionalString;
    }
//    UIToolbar *toolbarBackground = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
//    [self.view addSubview:toolbarBackground];
//    [self.view sendSubviewToBack:toolbarBackground];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
