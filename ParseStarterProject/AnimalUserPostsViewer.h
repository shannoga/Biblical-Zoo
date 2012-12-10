//
//  AnimalUserPostsViewer.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 04/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimalUserPostsViewer : UIView

@property (nonatomic,retain) UITextView *postLabel;
@property (nonatomic,retain) UILabel *nameLabel;

-(void)switchToPost:(PFObject*)postText;
@end
