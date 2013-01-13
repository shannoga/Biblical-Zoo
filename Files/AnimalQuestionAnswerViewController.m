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
    NSString *quest = self.questionObject[@"question"];
    if(quest != nil){
        directionalString = [@"\u200F" stringByAppendingString:quest];
    }else{
        directionalString=@"";
    }
    
    [self.questionLabel setText:directionalString];

    
    NSString *answer = self.questionObject[@"answer"];
    if(answer != nil){
    directionalString = [@"\u200F" stringByAppendingString:answer];
    }else{
            directionalString=@"";
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
