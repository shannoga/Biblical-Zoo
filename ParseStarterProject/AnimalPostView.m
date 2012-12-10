//
//  AnimalPostView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 7/3/12.
//
//

#import "AnimalPostView.h"
#import "Animal.h"
#import "AnimalUserPostsViewer.h"
#import <QuartzCore/QuartzCore.h>
@implementation AnimalPostView
@synthesize postView;
@synthesize viewPosts;
@synthesize labelView;
@synthesize animal;
@synthesize userName;
@synthesize cityField;
@synthesize postViewer;
@synthesize addPostView;
@synthesize posts;
@synthesize prev;
@synthesize next;

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = UIColorFromRGB(0xf8eddf);
        currentPostNumber = 0;
        
         postViewer = [[AnimalUserPostsViewer alloc] initWithFrame:CGRectInset(self.bounds, 10, 20)];
        [self addSubview:postViewer];
        
        addPostView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 600)];
        addPostView.backgroundColor = UIColorFromRGB(0xf8eddf);
        addPostView.hidden =YES;
        [self addSubview:addPostView];
        
        self.animal = anAnimal;
        self.labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 320, 50)];
        self.labelView.lineBreakMode = UILineBreakModeWordWrap;
        self.labelView.numberOfLines =3;
        self.labelView.textAlignment = UITextAlignmentCenter;
        self.labelView.text = NSLocalizedString(@"Post label", nil);
        self.labelView.backgroundColor = [UIColor clearColor];
        self.labelView.font = [UIFont boldSystemFontOfSize:12];
        self.labelView.textColor = [UIColor whiteColor];
        [self addSubview:labelView];
        
        UIButton *addPostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addPostBtn addTarget:self 
                   action:@selector(addPost)
         forControlEvents:UIControlEventTouchDown];
        UIImage *btnImage = [UIImage imageNamed:@"pencil"];
        [addPostBtn setImage:btnImage forState:UIControlStateNormal];
        addPostBtn.frame = CGRectMake(self.frame.size.width/2-[btnImage size].width/2, 10, [btnImage size].width, [btnImage size].height);
        [self addSubview:addPostBtn];
        
         next = [UIButton buttonWithType:UIButtonTypeCustom];
        [next addTarget:self 
                   action:@selector(nextPost)
         forControlEvents:UIControlEventTouchDown];
         btnImage = [UIImage imageNamed:@"arr-right"];
         [next setImage:btnImage forState:UIControlStateNormal];
        next.frame = CGRectMake(300-[btnImage size].width, 10, [btnImage size].width, [btnImage size].height);
        [self addSubview:next];
        
        prev = [UIButton buttonWithType:UIButtonTypeCustom];
        [prev addTarget:self 
                   action:@selector(prevPost)
         forControlEvents:UIControlEventTouchDown];
        btnImage = [UIImage imageNamed:@"arr-left"];
        [prev setImage:btnImage forState:UIControlStateNormal];
        prev.frame = CGRectMake(20, 10, [btnImage size].width, [btnImage size].height);
        [self addSubview:prev];
        
        self.postView = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, 300, 100)];
        self.postView.backgroundColor = [UIColor whiteColor];
        self.postView.editable = YES;
        self.postView.textColor = [UIColor blackColor];
        self.postView.font = [UIFont systemFontOfSize:14];
        self.postView.layer.cornerRadius = 5;
        self.postView.delegate=self;
        [addPostView addSubview:self.postView];
        
        self.userName = [[UITextField alloc] initWithFrame:CGRectMake(10, 180, 130, 25)];
        self.userName.placeholder = NSLocalizedString(@"Name", nil);
        self.userName.backgroundColor = [UIColor whiteColor];
        self.userName.delegate=self;
        self.userName.layer.cornerRadius = 5;
         [addPostView addSubview:self.userName];
        
        self.cityField = [[UITextField alloc] initWithFrame:CGRectMake(180, 180, 130, 25)];
        self.cityField.placeholder = NSLocalizedString(@"City / Country", nil);
        self.cityField.backgroundColor = [UIColor whiteColor];
        self.cityField.delegate = self;
        self.cityField.layer.cornerRadius = 5;
        [addPostView addSubview:self.cityField];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setTintColor:[UIColor brownColor]];
        [toolbar sizeToFit];
        
        UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(resignKeyboard)];
        UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Post", nil) style:UIBarButtonItemStyleDone target:self action:@selector(sendPost)];
        
        
        NSArray *itemsArray = @[doneButton,flexButton,postBtn];
        
     
        [toolbar setItems:itemsArray];
        
        [self.postView setInputAccessoryView:toolbar];
         [self.userName setInputAccessoryView:toolbar];
         [self.cityField setInputAccessoryView:toolbar];
        
        
      
        
        
    }
    return self;
}



-(void)getPosts{
    PFQuery *query = [PFQuery queryWithClassName:@"AnimalPost"];
    [query whereKey:@"visible" equalTo:@YES];
    [query whereKey:@"local" equalTo:[Helper currentLang]];
    [query whereKey:@"animalNameEn" equalTo:animal.nameEn];
    [query orderByDescending:@"updatedAt"];
    query.limit = 10;
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
        
            if ([objects count]>0) {
                posts = [NSArray arrayWithArray:objects];
                [self.postViewer switchToPost:(PFObject*)posts[currentPostNumber]];
            }
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"No Internet Connection",nil)
                                  message:NSLocalizedString(@"If you don't have intenrt services you can find an Internet acsses in the enternce to the zoo",nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"okay",nil)
                                  otherButtonTitles:nil];
            [alert show];
        }
    }];
}
-(void)addPost{
  
    [self.postView becomeFirstResponder];
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
    self.postViewer.hidden = YES;
    self.addPostView.hidden = NO;
}
-(void)notifEditingEnd{
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:@"PostEditingEnded" 
     object:nil];
    self.postViewer.hidden = NO;
     self.addPostView.hidden = YES;
 
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

-(void)sendPost{
    if (![self verifyPost]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post Attantion", nil)
                                                        message:NSLocalizedString(@"Post Missing Data Massege", nill) delegate:self cancelButtonTitle:NSLocalizedString(@"O.K", nil) otherButtonTitles:nil];
        [alert show];
        return; 
    }
    
    // Create the object.
    PFObject *userPost = [PFObject objectWithClassName:@"AnimalPost"];
    userPost[@"text"] = self.postView.text;
    if(animal.nameEn!=nil){
    userPost[@"animalNameEn"] = self.animal.nameEn;
    }
    NSString * userNameAndCity = [NSString stringWithFormat:@"%@, %@",self.userName.text,self.cityField.text];
    userPost[@"user"] = userNameAndCity;
    userPost[@"local"] = [Helper currentLang];
    userPost[@"visible"] = @YES;
    [userPost saveEventually];
    
     [self.postView resignFirstResponder];  
     [self.cityField resignFirstResponder];   
     [self.userName resignFirstResponder];  
     [self notifEditingEnd];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Post Tanks", nil)
                                                    message:NSLocalizedString(@"Post Suscess Massege", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"O.K", nil) otherButtonTitles:nil];
    [alert show];
                                                                                                                                                                                                             
}


-(void)nextPost{
    if(currentPostNumber+1 < [posts count])
    [self.postViewer switchToPost:(PFObject*)posts[currentPostNumber++]];
    
    if (currentPostNumber == [posts count]-1) {
        prev.enabled = YES;
        next.enabled = NO;
    }
}

-(void)prevPost{
    if(currentPostNumber-1 >=0)
       [self.postViewer switchToPost:(PFObject*)posts[currentPostNumber--]];
    
    if (currentPostNumber == 0) {
        prev.enabled = NO;
        next.enabled = YES;
    }
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
