//
//  ExhibitAnimalsViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "ExhibitAnimalsViewController.h"
#import "AnimalViewController.h"
#import "AnimalTableViewCell.h"

@interface ExhibitAnimalsViewController ()

@end

@implementation ExhibitAnimalsViewController
@synthesize exhibit;
@synthesize animals;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = [Helper languageSelectedStringForKey:@"Exhibit animals"];
   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array  = [NSMutableArray arrayWithArray:[[[self exhibit] animals] allObjects]];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@"local == %@", [Helper appLang] == kEnglish?@"en":@"he"];
       
    self.animals = [[array filteredArrayUsingPredicate:query] mutableCopy];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.backgroundColor = UIColorFromRGB(0x8C9544);
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    headerView.backgroundColor = UIColorFromRGB(0x3A2E23);
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    if([Helper appLang]==kHebrew){
        [iconView setFrame:CGRectMake(260, 10, 40, 40)];
    }
    [iconView setImage:[exhibit icon]];
    [headerView addSubview:iconView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 255, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
   
    if([Helper appLang]==kHebrew){
        [label setFrame:CGRectMake(0, 10, 250, 40)];
         label.font= [UIFont fontWithName:@"ArialHebrew-Bold" size:18];
        label.textAlignment = UITextAlignmentRight;
         label.text = exhibit.name;
    }else{
        label.font= [UIFont fontWithName:@"Futura" size:20];
         label.text = exhibit.nameEn; 
    }
    
    [headerView addSubview:label];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent =NO;
    self.tableView.backgroundColor = UIColorFromRGB(0x7F7960);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = UIColorFromRGBA(0xffffff, .2);
    self.tableView.rowHeight = 60;

    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.animals count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    Animal* animal = (Animal*)(self.animals)[indexPath.row];
    AnimalTableViewCell *lcell = (AnimalTableViewCell*)cell;
    [lcell setAnAnimal:animal];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AnimalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Animal *animal = (self.animals)[indexPath.row];
    
    if(animal){
    AnimalViewController *animalViewController = [[AnimalViewController alloc] init];
        if(!IS_IPHONE_5){
           // self.navigationController.navigationBar.tintColor = nil;
           // self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        }
    animalViewController.animal = animal;
    [self.navigationController pushViewController:animalViewController animated:YES];
    }else{
    
    NSLog(@"no animals in the exhibit");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:[Helper languageSelectedStringForKey:@"oops Error"]
                          message:[Helper languageSelectedStringForKey:@"There is a problem with this exhibit we will fix it as soon as possible"]
                          delegate:nil
                          cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                          otherButtonTitles:nil];
    [alert show];
}
    
}

@end
