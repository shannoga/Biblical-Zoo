//
//  MadadExplinationViewController.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 19/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "MadadExplinationViewController.h"

@interface MadadExplinationViewController ()

@end

@implementation MadadExplinationViewController
@synthesize titleLabel;
@synthesize webView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *html;
    
    if(![Helper isRightToLeft]){
   html = @"<html> <head> <style> body{ width:auto ; height:auto; background-color:transperant; font: .8em Futura; color: #281502; } </style> </head> <body> <h1>Lion Rank</h1> <h3 style='color:#6db472'>Calm</h3> <ul> <li> Only a few hundred guests are expected throughout the day.</li> <li> No line at the cashier.</li> <li> For those who love peace and quiet.</li> <li> No parking problems.</li> </ul> <h3 style='color:#ffd71c'>Flowing</h3> <ul> <li>Hundreds of visitors are expected throughout the zoo.</li> <li>A little patience will be required as the cashier.</li> <li>Parking lots 1 and possibly 2 may be full.</li> </ul> <h3 style='color:#ff8400'>Lively</h3> <ul> <li>Over a thousand people are expected to visit the zoo.</li> <li>Prepare to wait a few minutes as the cashier.</li> <li>Parking lots fill up; you may be directed to parking lot 3.</li> </ul> <h3 style='color:#ff2c1d'>Busy</h3> <ul> <li>Thousands of visitors at the zoo.</li> <li>For those who love the atmosphere, the color and the hustle and bustle.</li> <li>You may have to wait in line for a few minutes at the cashier.</li> <li>Parking lots 1 and 2 are full; you will be directed to parking lot.</li> <li> During 'Hol Hamoed' police block the access roads and direct traffic to Teddy Stadium parking lot.</li> </ul> </body> </html>";
    }else{
    html = @" <html lang='he'> <head> <style> body{ direction: rtl; width:auto ; height:auto; background-color:transperant; font: .8em Arial; color: #281502; } </style> </head> <body> <h1>מדד האריה</h1> <h3 style='color:#6db472'>רגוע</h3> <ul> <li>מאות בודדות בלבד של אורחים צפויים במהלך היום - לאוהבי השקט והשלווה.</li> <li> אין תור בקופות.</li> <li> אין בעיות חניה.</li> </ul> <h3 style='color:#ffd71c'>זורם</h3> <ul> <li>מאות מבקרים צפויים ברחבי הגן. ברחבי בגן מול התצוגות לא תרגישו בהבדל.</li> <li>מעט סבלנות תדרש בתור לקופות.</li> <li>מגרש חניה 1 ואולי גם 2 עשויים להתמלא.</li> </ul> <h3 style='color:#ff8400'>שוקק חיים</h3> <ul> <li>למעלה מאלף איש צפויים להגיע לגן החיות.</li> <li>צפי להמתנה של דקות ספורות בתור לקופות.</li> <li>מגרשי החניה יתמלאו ויש סיכוי שהתנועה תופנה למגרש חניה מס' 3.</li> </ul> <h3 style='color:#ff2c1d'>עמוס</h3> <ul> <li>Thousands of visitors at the zoo.</li> <li>גן החיות מלא באלפי מבקרים אשר יפקדו את כל תצוגות הגן - לאוהבי האוירה, הצבע וההמולה.</li> <li>תור של דקות עלול להווצר בקופות הכניסה.</li> <li>כשמגרשי חניה מס' 1+2 יתמלאו, תופנה התנועה למגרש חניה מס' 3. במקרה של עומסי תנועה כבדים תתכן הפניית התנועה לחניה באיצטדיון טדי הקרוב.</li> </ul> </body> </html>";
    }
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
