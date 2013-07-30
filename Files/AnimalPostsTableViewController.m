//
//  AnimalPostsTableViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 7/30/13.
//
//

#import "AnimalPostsTableViewController.h"
#import "Reachability.h"
#import "Animal.h"
#import "AnimalQuestionsCell.h"
@interface AnimalPostsTableViewController ()
    @property(nonatomic,strong) Animal *animal;
@end

@implementation AnimalPostsTableViewController


@synthesize textView,nameTF,cityTF,fieldsView;

- (id)initWithStyle:(UITableViewStyle)style forAnimal:(Animal*)anAnimal
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        if(anAnimal!=nil){
            self.animal = anAnimal;
        }
        self.title = [Helper languageSelectedStringForKey:@"Posts"];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshObjects)];
        self.navigationItem.rightBarButtonItem = barItem;
        
        // The className to query on
        self.className = @"AnimalPost";
        
        self.tableView.backgroundColor = UIColorFromRGB(0xabc9cb);
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        self.loadingViewEnabled = NO;
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 6;
        
        askingQuestion = NO;
        
    }
    return self;
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnimalPost"];
    [query whereKey:@"visible" equalTo:@YES];
    [query whereKey:@"animal_id" equalTo:self.animal.objectId];
    [query orderByDescending:@"updatedAt"];
    query.limit = 100;
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    return query;
    
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
    labelView.text = [Helper languageSelectedStringForKey:@"Send Your post"];
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
    self.textView.backgroundColor = UIColorFromRGBA(0xffffff, .5);
    [self.fieldsView addSubview:self.textView];
    
    self.nameTF = [[UITextField alloc] initWithFrame:CGRectMake(180, 120, 120, 25)];
    self.nameTF.backgroundColor = UIColorFromRGBA(0xffffff, .5);
    self.nameTF.placeholder = [Helper languageSelectedStringForKey:@"name"];
    [self.fieldsView addSubview:self.nameTF];
    
    self.cityTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, 120, 25)];
    self.cityTF.backgroundColor = UIColorFromRGBA(0xffffff, .5);
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
    
    PFObject *userPost = [PFObject objectWithClassName:@"AnimalPost"];
    userPost[@"text"] = self.textView.text;
    if(self.animal.nameEn!=nil){
        userPost[@"animalNameEn"] = self.animal.nameEn;
    }
    NSString * userNameAndCity = [NSString stringWithFormat:@"%@, %@",self.nameTF.text,self.cityTF.text];
    userPost[@"user"] = userNameAndCity;
    userPost[@"animal_id"] = self.animal.objectId;
    userPost[@"visible"] = @YES;
    
    [userPost saveEventually];
    
    [self.textView resignFirstResponder];
    [self.cityTF resignFirstResponder];
    [self.nameTF resignFirstResponder];
     [self resignKeyboard];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Post Tanks"]
                                                    message:[Helper languageSelectedStringForKey:@"Post Suscess Massege"] delegate:nil cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"] otherButtonTitles:nil];
    [alert show];

}
-(void)toggleQuestionFromView{
    if (askingQuestion) return;
    [self toggleQuestion];
}
-(void)toggleQuestion{
    
    [UIView animateWithDuration:1 animations:^{
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

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [refreshHUD hide:YES];
    // This method is called every time objects are loaded from Parse via the PFQuery
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
    refreshHUD.labelText = [Helper languageSelectedStringForKey:@"Loading"];
    [refreshHUD show:YES];
    // This method is called before a PFQuery is fired to get more objects
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
    
    [cell setObject:object atIndex:indexPath.row isQuestion:NO];

    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
       
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
	hud = nil;
}
@end


