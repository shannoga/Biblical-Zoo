//
//  AnimalQuestionsTableView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/21/12.
//

#import "AnimalQuestionsTableView.h"
#import "AnimalQuestionsCell.h"
#import "Reachability.h"
#import "AnimalQuestionAnswerViewController.h"
#import "Animal.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 35.0f

@interface AnimalQuestionsTableView ()
  @property (nonatomic,strong) Animal *animal;
  @property(nonatomic,strong) UIView *explinationView;
@end
@implementation AnimalQuestionsTableView
@synthesize textView,nameTF,cityTF,fieldsView;

- (id)initWithStyle:(UITableViewStyle)style forAnimal:(Animal*)anAnimal
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        if(anAnimal!=nil){
            self.animal = anAnimal;
        }
        self.title = [Helper languageSelectedStringForKey:@"Questions"];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshObjects)];
        self.navigationItem.rightBarButtonItem = barItem;
        
        // The className to query on
        self.className = @"AnimalQuestions";
        
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = NO;
        
        self.loadingViewEnabled = NO;
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 3;
       
        askingQuestion = NO;
        
    }
    return self;
}

-(UIView*)explinationView{
    if(!_explinationView){
        _explinationView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 170)];
        self.explinationView.backgroundColor = [UIColor clearColor];
        
        
        UITextView *postExplainLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 150)];
        postExplainLabel.textAlignment = NSTextAlignmentCenter;
        postExplainLabel.backgroundColor = [UIColor clearColor];
        postExplainLabel.textColor = UIColorFromRGB(0x281502);
        postExplainLabel.editable = NO;
        if([Helper appLang]==kHebrew) {
            postExplainLabel.font = [UIFont fontWithName:@"ArialHebrew" size:16];
        }else{
            postExplainLabel.font = [UIFont fontWithName:@"Futura" size:16];
        }
        postExplainLabel.text =[Helper languageSelectedStringForKey:@"No questions alert body"];
        [self.explinationView addSubview:postExplainLabel];
        
    }
    return _explinationView;
}

-(void)refreshObjects{
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if([reach isReachable]){
        [self loadObjects];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:[Helper languageSelectedStringForKey:@"No Internet Connection"]
                              message:[Helper languageSelectedStringForKey:@"No Internet alert body"]
                              delegate:nil
                              cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                              otherButtonTitles:nil];
		[alert show];
    }
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];

    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query orderByDescending:@"createdAt"];
    if(self.animal!=nil){
        [query whereKey:@"animal_en_name" equalTo:self.animal.nameEn];
    }
    
    NSString *key = [Helper appLang]==kHebrew? @"visible":@"visible_en";
    [query whereKey:key equalTo:@YES];
    
    return query;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight=100;
    self.tableView.sectionIndexMinimumDisplayRowCount=200;
    
    
    UIView *parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    parentView.backgroundColor = UIColorFromRGB(0x8C9544);
    
    
    UIFont *font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:20];
    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    labelView.backgroundColor = UIColorFromRGB(0x8C9544);
    labelView.text = [Helper languageSelectedStringForKey:@"Send a Question"];
    labelView.font = font;
    labelView.textAlignment = NSTextAlignmentCenter;
    labelView.textColor = [UIColor whiteColor];
    labelView.userInteractionEnabled = NO;
    
    self.fieldsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    self.fieldsView.backgroundColor = UIColorFromRGB(0x8C9544);
    self.fieldsView.alpha = 0;

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 280, 100)];
    
    font =  [UIFont fontWithName:@"Futura-CondensedExtraBold" size:14];
    self.textView.font = font;
    self.textView.backgroundColor = UIColorFromRGBA(0xffffff, 1);
    [self.fieldsView addSubview:self.textView];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(180, 120, 120, 25)];
    self.nameTF.backgroundColor = UIColorFromRGBA(0xffffff, 1);
    self.nameTF.placeholder = [Helper languageSelectedStringForKey:@"name"];
    [self.fieldsView addSubview:self.nameTF];
    
    self.cityTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 120, 25)];
    self.cityTF.backgroundColor = UIColorFromRGBA(0xffffff, 1);
    self.cityTF.placeholder = [Helper languageSelectedStringForKey:@"city"];
    [self.fieldsView addSubview:self.cityTF];
    
    if(IS_IPHONE_5){
        self.textView.frame = CGRectMake(20, 20, 280, 140);
        self.nameTF.frame = CGRectMake(180, 170, 120, 25);
        self.cityTF.frame = CGRectMake(20, 170, 120, 25);
    }
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleQuestionFromView)];
    [parentView addGestureRecognizer:recognizer];
    
    [parentView addSubview:labelView];
    self.tableView.tableHeaderView = parentView;
    
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setTintColor:[UIColor brownColor]];
    [toolbar sizeToFit];
    
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(resignKeyboard)];
    
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Send"] style:UIBarButtonItemStyleDone target:self action:@selector(sendQuestion)];
    
    
    NSArray *itemsArray = @[doneButton,flexButton,postBtn];
    
    
    [toolbar setItems:itemsArray];
    
    [self.textView setInputAccessoryView:toolbar];
    [self.nameTF setInputAccessoryView:toolbar];
    [self.cityTF setInputAccessoryView:toolbar];
   
}
-(void)resignKeyboard {
    [self.textView resignFirstResponder];
    [self.nameTF resignFirstResponder];
    [self.cityTF resignFirstResponder];
    [self toggleQuestion];
}
-(BOOL)verifyPost{
    if (self.textView.text.length > 0 && self.nameTF.text.length > 0 && self.cityTF.text.length > 0) {
        return YES;
    }
    return NO;
}

-(void)sendQuestion{
    if (![self verifyPost]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Post Attantion"]
                                                        message:[Helper languageSelectedStringForKey:@"Post Missing Data Massege"] delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Create the object.
    PFObject *userQuestion = [PFObject objectWithClassName:@"AnimalQuestions"];
    NSString *key = [Helper appLang]==kHebrew?@"question":@"question_en";
    userQuestion[key] = self.textView.text;
   
    NSString * userNameAndCity = [NSString stringWithFormat:@"%@, %@",self.nameTF.text,self.cityTF.text];
    userQuestion[@"user_name"] = userNameAndCity;
    userQuestion[@"visible"] = @NO;
    
    [userQuestion saveEventually];
    
    
    [self.textView setText:@""];
    [self.nameTF setText:@""];
    [self.cityTF setText:@""];
    
    
    [self resignKeyboard];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Question Tanks"]
                                                    message:[Helper languageSelectedStringForKey:@"Question Suscess Massege"] delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
    [alert show];
}
-(void)toggleQuestionFromView{
    if (askingQuestion) return;
    [self toggleQuestion];
}
-(void)toggleQuestion{

    [UIView animateWithDuration:.3 animations:^{
        if (askingQuestion) {
            [self.tableView.tableHeaderView setFrame:CGRectMake(0, 0, 320, 60)];
            [self.fieldsView  removeFromSuperview];
            self.fieldsView.alpha =0;
        }else{
            CGRect rect;
            if (IS_IPHONE_5) {
                rect = CGRectMake(0, 0, 320, 240);
            }else{
                rect = CGRectMake(0, 0, 320, 160);
            }

            [self.tableView.tableHeaderView setFrame:rect];
            [self.tableView.tableHeaderView addSubview:self.fieldsView];
             self.fieldsView.alpha =1;
            [self.textView becomeFirstResponder];

        }
        self.tableView.tableHeaderView.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
         NSLog(@"completed");
         askingQuestion = !askingQuestion;
        self.tableView.scrollEnabled = !askingQuestion;
         [self toggleExplinationView];
        self.tableView.tableHeaderView.userInteractionEnabled = YES;
    }];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

-(void)toggleExplinationView{
    if([self.objects count]==0 && !askingQuestion)
    {
        [self.view addSubview:self.explinationView];
    }else{
        [_explinationView removeFromSuperview];
    }
}
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [refreshHUD hide:YES];
    [self toggleExplinationView];
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
    refreshHUD.labelText = [Helper languageSelectedStringForKey:@"Loading"];
    [refreshHUD show:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==[self.objects count])return 0;
    PFObject *object = [self.objects objectAtIndex:[indexPath row]];
   NSString *key = [Helper appLang]==kHebrew?@"question":@"question_en";
    NSString *text = object[key];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
    
}
// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    
    AnimalQuestionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[AnimalQuestionsCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:CellIdentifier];
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.row < [self.objects count]) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        PFObject *questionObject = (self.objects)[indexPath.row];
        AnimalQuestionAnswerViewController * answerController = [[AnimalQuestionAnswerViewController alloc] initWithNibName:@"AnimalQuestionAnswerViewController" bundle:[Helper localizationBundle]];
        answerController.questionObject = questionObject;
        [self.navigationController pushViewController:answerController animated:YES];
    }else{
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        NSLog(@"reach  = %@",[reach isReachable]? @"YES":@"NO");
        
        if(![reach isReachable]){
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:[Helper languageSelectedStringForKey:@"No Internet Connection"]
                                  message:[Helper languageSelectedStringForKey:@"No Internet alert body"]
                                  delegate:nil
                                  cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
	hud = nil;
}
 @end
