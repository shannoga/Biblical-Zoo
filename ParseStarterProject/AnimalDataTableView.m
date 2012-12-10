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
@implementation AnimalDataTableView
@synthesize animal;

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animal = anAnimal;
        /*****************************************/
        /* sets the data to the data table view */
        /*****************************************/
        tableViewdata = [[NSMutableArray alloc] init];
        
        if ([animal.verse length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"In the Bible",nil),animal.verse]];
        }
        if ([animal.bioClass length]>0) {
            
            [tableViewdata addObject:@[NSLocalizedString(@"Class",nil),NSLocalizedString(animal.bioClass,nil)]];
        }
        if ([animal.family length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"Family",nil),animal.family]];
        }
        if ([animal.binomialName length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"Sientific Name",nil),animal.binomialName]];
        }
        if ([animal.conservationStatus length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"Conservation Status",nil),NSLocalizedString(animal.conservationStatus,nil)]];
        }
        if ([animal.habitat length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"Habitat",nil),animal.habitat]];
        }
        if ([animal.diet length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"Diet",nil),animal.diet]];
        }
        if ([animal.socialStructure length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"Social Structure",nil),animal.socialStructure]];
        } 
        if ([animal.zooItems length]>0) {
            [tableViewdata addObject:@[NSLocalizedString(@"In the zoo",nil),animal.zooItems]];
        }
        
       
        //NSLog(@"data = %@",[tableViewdata descrption]);
        //add atable view for the animal descrption
        UITableView *dataTableView = [[UITableView alloc] initWithFrame:CGRectInset( self.bounds, 10, 10) style:UITableViewStylePlain];
        dataTableView.delegate=self;
        dataTableView.dataSource = self;
        dataTableView.backgroundColor = UIColorFromRGB(0xf8eddf);
        dataTableView.rowHeight = 60;
        dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:dataTableView];
     
    }
    return self;
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
