//
//  NewsViewController.h
//  ParseStarterProject
//
//  Created by shani hajbi on 12/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface NewsViewController : UIViewController{
    __unsafe_unretained PFObject *newsObject;
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *subTitleLabel;
    UILabel *dateLabel;
    UITextView *textView;
    
}

@property (nonatomic, unsafe_unretained) PFObject *newsObject;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *dateLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *textView;


@end
