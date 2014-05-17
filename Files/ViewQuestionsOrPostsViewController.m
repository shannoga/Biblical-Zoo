//
//  ViewQuestionsOrPostsViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/16/14.
//
//

#import "ViewQuestionsOrPostsViewController.h"
#import "AnimalQuestionsCell.h"

#define FONT_SIZE 17.0f
#define CELL_MIN_HEIGHT 40.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 20.0f

@interface ViewQuestionsOrPostsViewController () <MBProgressHUDDelegate>
@property (nonatomic, strong) MBProgressHUD *refreshHUD;
@end

@implementation ViewQuestionsOrPostsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.refreshHUD hide:YES];
//    [self toggleExplinationView];
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    self.refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.refreshHUD];
    self.refreshHUD.labelText = [Helper languageSelectedStringForKey:@"Loading"];
    [self.refreshHUD show:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==[self.objects count])return 0;
    PFObject *object = [self.objects objectAtIndex:[indexPath row]];
    NSString *key = [Helper appLang]==kHebrew?@"question":@"question_en";
    NSString *text = object[key];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH , 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, CELL_MIN_HEIGHT);
    
    return height + (CELL_CONTENT_MARGIN * 2);
    
}

- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    AnimalQuestionsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"AnimalQuestionsCell"];
    
    NSString *key = nil;
    NSString *uesrKey = nil;
    if(self.postType == ViewerPostTypeQuestion)
    {
        key = [Helper appLang]==kHebrew? @"question":@"question_en";
        uesrKey = @"user_name";
        cell.iconView.image = [UIImage imageNamed:@"question"];
    }else{
        key = [Helper appLang]==kHebrew? @"text":@"text";
        uesrKey = @"user";
        cell.iconView.image = [UIImage imageNamed:@"postCellIcon"];
    }
    cell.labelView.text = object[key];
    cell.detailLableView.text = object[uesrKey];
    return cell;
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByDescending:@"createdAt"];
    if(self.animal!=nil){
        [query whereKey:@"animal_en_name" equalTo:self.animal.nameEn];
    }
    
    //NSString *key = [Helper appLang]==kHebrew? @"visible":@"visible_en";
    //[query whereKey:key equalTo:@YES];
    
    return query;
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
	hud = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
