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
#import "AnimalAddPostView.h"

@implementation AnimalPostView
@synthesize viewPosts;
@synthesize animal;
@synthesize postViewer;
@synthesize addPostView;
@synthesize posts;
@synthesize prev;
@synthesize next;
@synthesize loadPostsBtn;
@synthesize explinationView;
@synthesize beTheFirstLabel;

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {

         self.backgroundColor = UIColorFromRGB(0xf8eddf);
        currentPostNumber = 0;

        
        self.animal = anAnimal;
        
        
        buttonsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        buttonsBackgroundView.backgroundColor = UIColorFromRGB(0x3B2F24);
        [self addSubview:buttonsBackgroundView];

        
        UIButton *addPostBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addPostBtn addTarget:self 
                   action:@selector(addPost)
         forControlEvents:UIControlEventTouchDown];
        UIImage *btnImage = [UIImage imageNamed:@"pencil"];
        [addPostBtn setImage:btnImage forState:UIControlStateNormal];
        addPostBtn.frame = CGRectMake(100, 10, [btnImage size].width, [btnImage size].height);
        [buttonsBackgroundView addSubview:addPostBtn];
        
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshButton addTarget:self
                       action:@selector(getPostsFromButton)
             forControlEvents:UIControlEventTouchDown];
        btnImage = [UIImage imageNamed:@"155-Revert"];
        [refreshButton setImage:btnImage forState:UIControlStateNormal];
        refreshButton.frame = CGRectMake(190, 10, [btnImage size].width, [btnImage size].height);
        [buttonsBackgroundView addSubview:refreshButton];
        
         next = [UIButton buttonWithType:UIButtonTypeCustom];
        [next addTarget:self 
                   action:@selector(nextPost)
         forControlEvents:UIControlEventTouchDown];
         btnImage = [UIImage imageNamed:@"arr-right"];
         [next setImage:btnImage forState:UIControlStateNormal];
        next.frame = CGRectMake(300-[btnImage size].width, 10, [btnImage size].width, [btnImage size].height);
        [buttonsBackgroundView addSubview:next];
        
        prev = [UIButton buttonWithType:UIButtonTypeCustom];
        [prev addTarget:self 
                   action:@selector(prevPost)
         forControlEvents:UIControlEventTouchDown];
        btnImage = [UIImage imageNamed:@"arr-left"];
        [prev setImage:btnImage forState:UIControlStateNormal];
        prev.frame = CGRectMake(20, 10, [btnImage size].width, [btnImage size].height);
        [buttonsBackgroundView addSubview:prev];
        
  
        self.explinationView = [[UIView alloc] initWithFrame:CGRectMake(10, 64, 300, 170)];
        self.explinationView.backgroundColor = [UIColor clearColor];
        
        
        UITextView *postExplainLabel = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 280, 150)];
        postExplainLabel.textAlignment = UITextAlignmentCenter;
        postExplainLabel.backgroundColor = [UIColor clearColor];
        postExplainLabel.textColor = UIColorFromRGB(0x281502);
        postExplainLabel.editable = NO;
        if(![Helper isRightToLeft]) {
            postExplainLabel.font = [UIFont fontWithName:@"ArialHebrew" size:14];
        }else{
            postExplainLabel.font = [UIFont fontWithName:@"Futura" size:14];
        }
        postExplainLabel.text =@"Load other users facts jokes and other interesting posts about this animal, tap the load button to load other user posts, tap the pencil to add your own. We will post the most funny interesting posts !";
        [self.explinationView addSubview:postExplainLabel];
        
        [self addSubview:self.explinationView];
     
            
        
        postViewer = [[AnimalUserPostsViewer alloc] initWithFrame:CGRectMake(0, 54, 320, 300)];
        postViewer.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePostEditingNotification:)
                                                     name:@"PostEditingStarted"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receivePostEditingNotification:)
                                                     name:@"PostEditingEnded"
                                                   object:nil];
      
    }
    return self;
}


-(void)getPostsFromButton{
    [self getPosts:YES];
}
-(void)getPosts:(BOOL)fromButton{
    
    if(!fromButton && [posts count]!=0)return;
    refreshHUD = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:refreshHUD];
    refreshHUD.delegate = self;
    [refreshHUD show:YES];
    refreshHUD.labelText = @"Loading Posts";
    
    PFQuery *query = [PFQuery queryWithClassName:@"AnimalPost"];
    [query whereKey:@"visible" equalTo:@YES];
    [query whereKey:@"animal_id" equalTo:animal.objectId];
    [query orderByDescending:@"updatedAt"];
    query.limit = 100;
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    __block BOOL chachedResults = YES;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (chachedResults) {
                posts = [NSMutableArray arrayWithArray:objects];
                chachedResults = NO;
            }else{
                if([objects count]>0){
                    posts = [NSMutableArray arrayWithArray:objects];
                }
                if ([posts count]>0) {
                    [self.postViewer switchToPost:(PFObject*)posts[currentPostNumber]];
                    [self addSubview:postViewer];
                    [self.explinationView removeFromSuperview];
                }else{
                    if([posts count]==0){
                        [postViewer removeFromSuperview];
                        [self addSubview:self.explinationView];
                        if(fromButton){
                        UIAlertView *alert = [[UIAlertView alloc]
                                              initWithTitle:NSLocalizedString(@"No Posts For Animal",nil)
                                              message:NSLocalizedString(@"Be the first to add an interesting fact, joke, song. any thing that might interest other visitors.",nil)
                                              delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"okay",nil)
                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    }
                }
            }
           
            
        } else {
            
            if([posts count]==0){
                [postViewer removeFromSuperview];
                [self addSubview:self.explinationView];
            }
            if (fromButton) {
          
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:NSLocalizedString(@"No Internet Connection",nil)
                                  message:NSLocalizedString(@"If you don't have intenrt services you can find an Internet acsses in the enternce to the zoo",nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"okay",nil)
                                  otherButtonTitles:nil];
            [alert show];
            }
        }
         [refreshHUD hide:YES];
    }];
}

-(void)addPost{
    self.addPostView =[[AnimalAddPostView alloc] initWithFrame:CGRectMake(0, 0, 320, 600) withAnimal:self.animal];
    addPostView.backgroundColor = UIColorFromRGB(0xf8eddf);
    addPostView.hidden =YES;
    [self addSubview:addPostView];
    [self.addPostView.postView becomeFirstResponder];
}

- (void) receivePostEditingNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"PostEditingStarted"]){
        self.postViewer.hidden = YES;
        self.addPostView.hidden = NO;
    }else if([[notification name] isEqualToString:@"PostEditingEnded"]) {
        self.postViewer.hidden = NO;
        self.addPostView.hidden = YES;
        [[self addPostView] removeFromSuperview];
        self.addPostView=nil;
    }
}


-(void)nextPost{
    if ([posts count]==0) return;
    currentPostNumber++;
    if(currentPostNumber < [posts count]){
    [self.postViewer switchToPost:(PFObject*)posts[currentPostNumber]];
    
    }else{
         [self.postViewer switchToPost:(PFObject*)posts[0]];
        currentPostNumber=0;
    }
}

-(void)prevPost{
    if ([posts count]==0) return;
    currentPostNumber--;
    if(currentPostNumber >= 0){
       [self.postViewer switchToPost:(PFObject*)posts[currentPostNumber]];
    }else{
        NSUInteger postsCount = [posts count];
        [self.postViewer switchToPost:(PFObject*)posts[postsCount-1]];
        currentPostNumber=postsCount-1;
    }
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [hud removeFromSuperview];
	hud = nil;
}


@end
