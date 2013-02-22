//
//  AnimalAddPostView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/16/12.
//
//

#import "AnimalAddPostView.h"
#import <QuartzCore/QuartzCore.h>
@implementation AnimalAddPostView

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animal = anAnimal;
        self.postView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 100)];
        self.postView.backgroundColor = [UIColor whiteColor];
        self.postView.editable = YES;
        self.postView.textColor = [UIColor blackColor];
        self.postView.font = [UIFont systemFontOfSize:14];
        self.postView.layer.cornerRadius = 5;
        self.postView.delegate=self;
        [self addSubview:self.postView];
        
        self.userName = [[UITextField alloc] initWithFrame:CGRectMake(10, 180, 130, 25)];
        self.userName.placeholder = [Helper languageSelectedStringForKey:@"Name"];
        self.userName.backgroundColor = [UIColor whiteColor];
        self.userName.delegate=self;
        self.userName.layer.cornerRadius = 5;
        [self addSubview:self.userName];
        
        self.cityField = [[UITextField alloc] initWithFrame:CGRectMake(180, 180, 130, 25)];
        self.cityField.placeholder = [Helper languageSelectedStringForKey:@"City / Country"];
        self.cityField.backgroundColor = [UIColor whiteColor];
        self.cityField.delegate = self;
        self.cityField.layer.cornerRadius = 5;
        [self addSubview:self.cityField];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setTintColor:[UIColor brownColor]];
        [toolbar sizeToFit];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(resignKeyboard)];
        
        UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Post"] style:UIBarButtonItemStyleDone target:self action:@selector(sendPost)];
        
        
        NSArray *itemsArray = @[doneButton,flexButton,postBtn];
        
        
        [toolbar setItems:itemsArray];
        
        [self.postView setInputAccessoryView:toolbar];
        [self.userName setInputAccessoryView:toolbar];
        [self.cityField setInputAccessoryView:toolbar];
    }
    return self;
}

-(void)resignKeyboard {
    [self.postView resignFirstResponder];
    [self.cityField resignFirstResponder];
    [self.userName resignFirstResponder];
    [self notifEditingEnd];
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self notifEditingBegin];
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self notifEditingBegin];
}

-(BOOL)verifyPost{
    if (self.postView.text.length > 0 && self.userName.text.length > 0 && self.cityField.text.length > 0) {
        return YES;
    }
    return NO;
}


-(void)notifEditingBegin{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"PostEditingStarted"
     object:nil];
  
}
-(void)notifEditingEnd{
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"PostEditingEnded"
     object:nil];
   
    
}

-(void)sendPost{
    if (![self verifyPost]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Post Attantion"]
                                                        message:[Helper languageSelectedStringForKey:@"Post Missing Data Massege"] delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Create the object.
    PFObject *userPost = [PFObject objectWithClassName:@"AnimalPost"];
    userPost[@"text"] = self.postView.text;
    if(self.animal.nameEn!=nil){
        userPost[@"animalNameEn"] = self.animal.nameEn;
    }
    NSString * userNameAndCity = [NSString stringWithFormat:@"%@, %@",self.userName.text,self.cityField.text];
    userPost[@"user"] = userNameAndCity;
    userPost[@"animal_id"] = self.animal.objectId;
    userPost[@"visible"] = @NO;
    
    [userPost saveEventually];
    
    [self.postView resignFirstResponder];
    [self.cityField resignFirstResponder];
    [self.userName resignFirstResponder];
    [self notifEditingEnd];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Post Tanks"]
                                                    message:[Helper languageSelectedStringForKey:@"Post Suscess Massege"] delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
    [alert show];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
