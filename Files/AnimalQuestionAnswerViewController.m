//
//  AnimalQuestionAnswerViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/1/13.
//
//

#import "AnimalQuestionAnswerViewController.h"

@interface AnimalQuestionAnswerViewController ()

@end

@implementation AnimalQuestionAnswerViewController
@synthesize questionLabel,answerTextView;
@synthesize questionObject;


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *directionalString;
    NSString *key = [Helper isRightToLeft]? @"question":@"question_en";
    NSString *quest = self.questionObject[key];
    if(quest != nil && [Helper isRightToLeft]){
        directionalString = [@"\u200F" stringByAppendingString:quest];
    }else if([Helper isRightToLeft]){
        directionalString=@"";
    }else{
        directionalString=quest;
    }

    [self.questionLabel setText:directionalString];

    key = [Helper isRightToLeft]? @"answer":@"answer_en";
    NSString *answer = self.questionObject[key];
    if(answer != nil && [Helper isRightToLeft]){
    directionalString = [@"\u200F" stringByAppendingString:answer];
    }else if([Helper isRightToLeft]){
            directionalString=@"";
    }else{
         directionalString=answer;
    }
    self.answerTextView.text = directionalString;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
