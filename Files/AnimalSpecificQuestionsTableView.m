//
//  AnimalSpecificQuestionsTableView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/20/13.
//
//

#import "AnimalSpecificQuestionsTableView.h"
#import "AnimalQuestionsCell.h"
#import "AnimalQuestionAnswerViewController.h"
#import "AnimalViewController.h"

@implementation AnimalSpecificQuestionsTableView
@synthesize animal;
@synthesize tableViewdata;
@synthesize parentController;

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal withParentController:(AnimalViewController*)animalController
{
    self = [super initWithFrame:frame];
    if (self) {
        refreshHUD  =  [[MBProgressHUD alloc]initWithView:self];
        refreshHUD.delegate = self;
        [refreshHUD show:YES];
        
        self.parentController = animalController;
        //add atable view for the animal descrption
        UITableView *dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 240) style:UITableViewStylePlain];
        dataTableView.delegate=self;
        dataTableView.dataSource = self;
        dataTableView.backgroundColor = UIColorFromRGB(0xf8eddf);
        dataTableView.rowHeight = 100;
        dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [dataTableView setCanCancelContentTouches:YES];
        [self addSubview:dataTableView];
        
        self.animal = anAnimal;
        self.tableViewdata = [NSArray array];
        PFQuery *query = [PFQuery queryWithClassName:@"AnimalQuestions"];
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [query whereKey:@"animal_en_name" equalTo:anAnimal.nameEn];
        NSString * key = [Helper isRightToLeft]?@"visible":@"visible_en";
        [query whereKey:key equalTo:@YES];
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                self.tableViewdata  = objects;
                if ([self.tableViewdata count]==0) {
                    [self indicateNoQuestionsForTableView:dataTableView forNoQuestions:YES];
                }else{
                    [self indicateNoQuestionsForTableView:dataTableView forNoQuestions:NO];
                }
                [dataTableView reloadData];
                [refreshHUD hide:YES];
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        
    
    }
    return self;
}

-(void)indicateNoQuestionsForTableView:(UITableView*)table forNoQuestions:(BOOL)noQuestions{
    CGRect labelRect;
    CGRect iconRect;
    CGRect secondRect;
    UIFont * font;
    UIFont *secondFont;
    UITextAlignment textAlign;
    CGFloat height = noQuestions? 100:50;
    if ([Helper isRightToLeft]) {
        labelRect = CGRectMake(0, 0, 320, 50);
        secondRect = CGRectMake(20, 45, 280, 40);
        iconRect = CGRectMake(265, 10, 30, 30);
        font = [UIFont fontWithName:@"ArialHebrew-Bold" size:20];
        secondFont = [UIFont fontWithName:@"ArialHebrew" size:14];
        textAlign = UITextAlignmentCenter;
    }else{
        labelRect = CGRectMake(0, 0, 320, 50);
         secondRect = CGRectMake(20, 45, 280, 40);
        iconRect = CGRectMake(25, 10, 30, 30);
        font = [UIFont fontWithName:@"Futura" size:20];
        secondFont = [UIFont fontWithName:@"Futura" size:14];
        textAlign = UITextAlignmentCenter;
    }
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIButton * headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.frame = CGRectMake(0, 0, 320, 60);
    
    UIImageView *headerButtonIconView = [[UIImageView alloc] initWithFrame:iconRect];
    
    UILabel * headerButtonLabel = [[UILabel alloc] initWithFrame:labelRect];
    headerButtonLabel.backgroundColor = [UIColor clearColor];
    headerButtonLabel.textColor = [UIColor whiteColor];
    headerButtonLabel.font= font;
    
    headerButtonLabel.textAlignment = textAlign;
    UILabel * headerButtonLabel2;
    if (noQuestions) {
        
        headerButtonLabel2 = [[UILabel alloc] initWithFrame:secondRect];
        headerButtonLabel2.backgroundColor = [UIColor clearColor];
        headerButtonLabel2.textColor = [UIColor whiteColor];
        headerButtonLabel2.lineBreakMode = NSLineBreakByWordWrapping;
        headerButtonLabel2.font= secondFont;
        headerButtonLabel2.numberOfLines=2;
        headerButtonLabel2.textAlignment = UITextAlignmentCenter;
        [headerButton addSubview:headerButtonLabel2];

    }
    [headerButton addSubview:headerButtonLabel];
    [headerButton addSubview:headerButtonIconView];
    [headerView addSubview:headerButton];
    
    headerView.backgroundColor = UIColorFromRGB(0xC95000);
    [headerButton addTarget:self action:@selector(goToQuestions) forControlEvents:UIControlEventTouchUpInside];
    [headerButtonIconView setImage:[UIImage imageNamed:@"248-QuestionCircleAlt_2.png"]];
    headerButtonLabel.text = NSLocalizedString(@"Ask a question",nil);
    headerButtonLabel2.text = NSLocalizedString(@"No questions alert body",nil);
    table.tableHeaderView = headerView;
}

-(void)goToQuestions{
    self.parentController.navigationController.tabBarController.selectedIndex =4;
}
#pragma mark -
#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableViewdata count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    AnimalQuestionsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[AnimalQuestionsCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:CellIdentifier];
    }
    PFObject *object = [self.tableViewdata objectAtIndex:indexPath.row];
    [cell setQuestion:object atIndex:indexPath.row];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        PFObject *questionObject = (self.tableViewdata)[indexPath.row];
        AnimalQuestionAnswerViewController * answerController = [[AnimalQuestionAnswerViewController alloc] initWithNibName:@"AnimalQuestionAnswerViewController" bundle:nil];
        answerController.questionObject = questionObject;
    [self.parentController.navigationController setNavigationBarHidden:NO animated:NO];
    self.parentController.navigationController.navigationBar.translucent =NO;
    [self.parentController.navigationController pushViewController:answerController animated:YES];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}

@end
