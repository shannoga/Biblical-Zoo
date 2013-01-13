//
//  AnimalUserPostsViewer.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 04/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimalUserPostsViewer : UIView

@property (nonatomic,strong) UITextView *postLabel;
@property (nonatomic,strong) NSMutableString *postString;


-(void)switchToPost:(PFObject*)postText;
@end
