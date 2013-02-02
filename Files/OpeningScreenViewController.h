//
//  OpeningScreenViewController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 01/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpeningScreenViewController : UIViewController{

    
}
@property (nonatomic,retain) IBOutlet UIImageView * imageview;
@property (nonatomic,retain) IBOutlet UIButton * madad;
@property (nonatomic,retain) IBOutlet UIButton * enterBtn;
@property (nonatomic,retain) IBOutlet UIButton * directionsBtn;
-(IBAction)showMadad:(id)sender;
-(IBAction)enter:(id)sender;
-(IBAction)showInfo:(id)sender;


@end
