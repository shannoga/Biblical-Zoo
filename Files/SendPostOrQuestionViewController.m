//
//  sendPostOrQuestionViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/14/14.
//
//

#import "SendPostOrQuestionViewController.h"

@implementation SendPostOrQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.contentTextView becomeFirstResponder];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        if (self.postType == PostTypePost)
        {
             [self sendPost];
        }
        else
        {
            [self sendQuestion];
        }
       
    }
}

-(BOOL)verifyPost{
    if (self.contentTextView.text.length > 0 && self.nameTextField.text.length > 0 && self.cityTextField.text.length > 0) {
        return YES;
    }
    [self showVeiricationAlert];
    return NO;
}

- (void)showVeiricationAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Post Attantion"]
                                                    message:[Helper languageSelectedStringForKey:@"Post Missing Data Massege"] delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
    [alert show];
}

-(void)sendPost
{
    if (![self verifyPost]) return;
    // Create the object.
    PFObject *userPost = [PFObject objectWithClassName:@"AnimalPost"];
    userPost[@"text"] = self.contentTextView.text;
    if(self.animal.nameEn!=nil){
        userPost[@"animalNameEn"] = self.animal.nameEn;
    }
    NSString * userNameAndCity = [NSString stringWithFormat:@"%@, %@",self.nameTextField.text,self.cityTextField.text];
    userPost[@"user"] = userNameAndCity;
    userPost[@"animal_id"] = self.animal.objectId;
    userPost[@"visible"] = @NO;
    
    [userPost saveEventually];
    
    [self.contentTextView resignFirstResponder];
    [self.cityTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Post Tanks"]
                                                    message:[Helper languageSelectedStringForKey:@"Post Suscess Massege"] delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
    [alert show];
    
}

-(void)sendQuestion{
    if (![self verifyPost]) return;

    PFObject *userQuestion = [PFObject objectWithClassName:@"AnimalQuestions"];
    NSString *key = [Helper appLang]==kHebrew?@"question":@"question_en";
    userQuestion[key] = self.contentTextView.text;
    
    NSString * userNameAndCity = [NSString stringWithFormat:@"%@, %@",self.nameTextField.text,self.cityTextField.text];
    userQuestion[@"user_name"] = userNameAndCity;
    userQuestion[@"visible"] = @NO;
    
    [userQuestion saveEventually];
    
    
    [self.contentTextView setText:@""];
    [self.nameTextField setText:@""];
    [self.cityTextField setText:@""];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Question Tanks"]
                                                    message:[Helper languageSelectedStringForKey:@"Question Suscess Massege"] delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
    [alert show];
}



@end
