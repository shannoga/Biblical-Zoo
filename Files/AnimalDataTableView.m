//
//  AnimalDataTableView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import "AnimalDataTableView.h"
#import "AnimalDataTableViewCell.h"
#import "Animal.h"
#import "Helper.h"
#import "AnimalsImagesScrollView.h"

@implementation AnimalDataTableView
@synthesize animal;

- (id)initWithStyle:(UITableViewStyle)style withAnimal:(Animal*)anAnimal
{
    self = [super init];
    if (self) {
        self.animal = anAnimal;
       
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    /*****************************************/
    /* sets the data to the data table view */
    /*****************************************/
    tableViewdata = [[NSMutableArray alloc] init];
    
    if ([animal.name length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Name"],animal.name]];
    }
    
    if ([animal.verse length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"In the Bible"],animal.verse]];
    }
    if ([animal.bioClass length]>0) {
        
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Class"],[Helper languageSelectedStringForKey:animal.bioClass]]];
    }
    if ([animal.family length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Family"],animal.family]];
    }
    if ([animal.binomialName length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Sientific Name"],animal.binomialName]];
    }
    if ([animal.conservationStatus length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Conservation Status"],[Helper languageSelectedStringForKey:animal.conservationStatus]]];
    }
    if ([animal.habitat length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Habitat"],animal.habitat]];
    }
    if ([animal.diet length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Diet"],animal.diet]];
    }
    if ([animal.socialStructure length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"Social Structure"],animal.socialStructure]];
    }
    if ([animal.zooItems length]>0) {
        [tableViewdata addObject:@[[Helper languageSelectedStringForKey:@"In the zoo"],animal.zooItems]];
    }
    
    
    //add atable view for the animal descrption
  
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf8eddf);
    self.tableView.rowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    AnimalsImagesScrollView *imagesScrollView;
    
    if(IS_IPHONE_5){
        imagesScrollView = [[AnimalsImagesScrollView alloc] initWithFrame:CGRectMake(0, 28, 320, 190) withAnimal:self.animal];
    }else{
        imagesScrollView = [[AnimalsImagesScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, 190) withAnimal:self.animal];
    }
    self.tableView.tableHeaderView = imagesScrollView;
    
    
    //self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0)
}

- (void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 30, 320,400);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark - Table view data source

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = tableViewdata[indexPath.row][0];
    if (indexPath.row==1 && [animal.verse length]>0) {
        
        NSString *str = animal.verse;
        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Futura" size:18] constrainedToSize:CGSizeMake(300, 999) lineBreakMode:UILineBreakModeWordWrap];
        NSLog(@"%f",size.height);
        return size.height + 40;
        
       // return 120;
    }else if ([animal.diet length]>0 && [key isEqualToString:[Helper languageSelectedStringForKey:@"Diet"]]){
        
        NSString *str = animal.diet;
        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Futura" size:18] constrainedToSize:CGSizeMake(300, 999) lineBreakMode:UILineBreakModeWordWrap];
        NSLog(@"%f",size.height);
        return size.height + 40;
    }else if ([animal.socialStructure length]>0 && [key isEqualToString:[Helper languageSelectedStringForKey:@"Social Structure"]]){
        
        NSString *str = animal.socialStructure;
        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Futura" size:18] constrainedToSize:CGSizeMake(300, 999) lineBreakMode:UILineBreakModeWordWrap];
        NSLog(@"%f",size.height);
        return size.height + 40;
    }else if ([animal.habitat length]>0 && [key isEqualToString:[Helper languageSelectedStringForKey:@"Habitat"]]){
        
        NSString *str = animal.habitat;
        CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Futura" size:18] constrainedToSize:CGSizeMake(300, 999) lineBreakMode:UILineBreakModeWordWrap];
        NSLog(@"%f",size.height);
        return size.height + 40;
    }
    return 70;
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell
	
    NSArray *data =tableViewdata[indexPath.row];
    AnimalDataTableViewCell *lcell = (AnimalDataTableViewCell*)cell;
    [lcell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [lcell setAnimal:data conservationAbviration:animal.conservationStatus atIndex:indexPath.row];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AnimalDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AnimalDataTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AnimalDataTableViewCell"];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    
    return cell;
}

@end
