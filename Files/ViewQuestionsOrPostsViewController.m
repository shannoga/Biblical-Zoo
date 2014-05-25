//
//  ViewQuestionsOrPostsViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/16/14.
//
//

#import "ViewQuestionsOrPostsViewController.h"
#import "AnimalQuestionsCell.h"
#import "QuestionAnswerPopupViewController.h"
#import "UIViewController+CWPopup.h"

#define FONT_SIZE 15.0f
#define CELL_MIN_HEIGHT 40.0f
#define CELL_CONTENT_WIDTH 280.0f
#define CELL_CONTENT_MARGIN 30.0f

@interface ViewQuestionsOrPostsViewController () <MBProgressHUDDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) MBProgressHUD *refreshHUD;
@property (nonatomic) BOOL isPresentingAnswer;
@end

@implementation ViewQuestionsOrPostsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if(self.postType == ViewerPostTypeQuestion)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPopup)];
        tapRecognizer.numberOfTapsRequired = 1;
        tapRecognizer.delegate = self;
        [self.tableView addGestureRecognizer:tapRecognizer];
        self.useBlurForPopup = YES;
        self.isPresentingAnswer = NO;
        
    }
    
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
    if(self.postType == ViewerPostTypeQuestion)
    {
        key = [Helper appLang]==kHebrew? @"question":@"question_en";
    }else{
        key = [Helper appLang]==kHebrew? @"text":@"text";
    }
    
    NSString *text = object[key];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    if (text) {
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH , 20000.0f);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:@{ NSFontAttributeName:font}];
        
        CGSize size;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            
            NSRange range = NSMakeRange(0, [attrString length]);
            
            NSDictionary *attributes = [attrString attributesAtIndex:0 effectiveRange:&range];
            CGSize boundingBox = [text boundingRectWithSize:constraint options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
            
            size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
        }
        else{
            size = [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        return size.height + (CELL_CONTENT_MARGIN * 2);
    }
    return 44;
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
    }else{
        key = [Helper appLang]==kHebrew? @"text":@"text";
        uesrKey = @"user";
    }
    cell.iconView.image = self.animal.exhibit.icon;
    cell.labelView.text = object[key];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setCalendar:[NSCalendar currentCalendar]];
    cell.dateLabel.text = [dateFormatter stringFromDate:object.createdAt];
    cell.detailLableView.text = object[uesrKey];
    return cell;
}


- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    [query orderByDescending:@"createdAt"];

    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    if(self.animal!=nil){
        
        [query whereKey:self.postType == ViewerPostTypeQuestion ? @"animal_en_name" : @"animalNameEn" equalTo:self.animal.nameEn];
    }
    
    //NSString *key = [Helper appLang]==kHebrew? @"visible":@"visible_en";
    //[query whereKey:key equalTo:@YES];
    
    return query;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.postType == ViewerPostTypeQuestion)
    {
        self.useBlurForPopup = YES;
        self.tableView.scrollEnabled = NO;
        QuestionAnswerPopupViewController *answerPopupViewController = [[QuestionAnswerPopupViewController alloc] initWithNibName:@"QuestionAnswerPopupViewController" bundle:nil];
        answerPopupViewController.popupViewOffset = self.tableView.contentOffset;
        answerPopupViewController.questionObject = [self.objects objectAtIndex:indexPath.row];
        [self presentPopupViewController:answerPopupViewController animated:YES completion:^{
            self.isPresentingAnswer = YES;
        }];
    }
    
}

- (void)dismissPopup {
    if (self.popupViewController != nil) {
        [self dismissPopupViewControllerAnimated:YES completion:^{
            self.tableView.scrollEnabled = YES;
            self.isPresentingAnswer = NO;

        }];
    }
}


#pragma mark - gesture recognizer delegate functions

// so that tapping popup view doesnt dismiss it
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [touch.view isDescendantOfView:self.tableView] && self.isPresentingAnswer;
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
