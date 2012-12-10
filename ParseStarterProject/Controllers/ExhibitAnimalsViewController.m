//
//  ExhibitAnimalsViewController.m
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "ExhibitAnimalsViewController.h"
#import "Animal.h"
#import "Exhibit.h"
#import "AnimalViewController.h"

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
        self.title = NSLocalizedString(@"Exhibit animals",nil); 
   
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *array  = [NSMutableArray arrayWithArray:[[[self exhibit] animals] allObjects]];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@"local == %@", [Helper currentLang]];
       
    self.animals = [[array filteredArrayUsingPredicate:query] mutableCopy];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.backgroundColor = UIColorFromRGB(0x95bdc2);
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    headerView.backgroundColor = UIColorFromRGB(0x3A2E23);
    self.tableView.tableHeaderView = headerView;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    if([Helper isRightToLeft]){
        [iconView setFrame:CGRectMake(170, 10, 40, 40)];
    }
    [iconView setImage:[exhibit icon]];
    [headerView addSubview:iconView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 255, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
   
    if([Helper isRightToLeft]){
        [label setFrame:CGRectMake(0, 10, 250, 40)];
         label.font= [UIFont fontWithName:@"ArialBold" size:18];
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
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x3A2E23);
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent =NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if([Helper isRightToLeft]){
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
        }else{
           cell.textLabel.font = [UIFont fontWithName:@"Futura" size:20]; 
        }
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    Animal* animal = (Animal*)(self.animals)[indexPath.row];
    cell.textLabel.text = animal.name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Animal *animal = (self.animals)[indexPath.row];
    
    if(animal){
    AnimalViewController *animalViewController = [[AnimalViewController alloc] init];
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    animalViewController.animal = animal;
    [self.navigationController pushViewController:animalViewController animated:YES];
    }else{
    
    NSLog(@"no animals in the exhibit");
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"oops Error",nil)
                          message:NSLocalizedString(@"There is a problem with this exhibit we will fix it as soon as possible",nil)
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"okay",nil)
                          otherButtonTitles:nil];
    [alert show];
}
    
}

@end
