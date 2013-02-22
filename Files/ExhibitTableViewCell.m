//
//  ExhibitTableViewCell.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 18/07/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "ExhibitTableViewCell.h"
#import "UIImage+Helper.h"

@implementation ExhibitTableViewCell
@synthesize nameLabel;
@synthesize iconImageView;
@synthesize exhibit;
@synthesize auodioGuideIndicator;
@synthesize manyAnimalsIndicator;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.textColor = [UIColor blackColor];
        
        
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
         self.auodioGuideIndicator = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.manyAnimalsIndicator= [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.manyAnimalsIndicator];
        [self addSubview:self.auodioGuideIndicator];
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = UIColorFromRGB(0xf8eddf);
        [self setSelectedBackgroundView:bgView];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

-(void)layoutSubviews{
     [super layoutSubviews];
    CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
    self.frame = newCellViewFrame;
    
   
    
    UIFont *font;
    if([Helper appLang]==kHebrew){
        font =  [UIFont fontWithName:@"ArialHebrew-Bold" size:20];
    }else{
        font =  [UIFont fontWithName:@"Futura" size:20];
    }
    self.nameLabel.font = font;
    
    UIImage *icon = [[exhibit icon] normalize];
    self.iconImageView.image = icon;
    
    if([Helper appLang]==kHebrew){
        self.nameLabel.text =self.exhibit.name;
        [self.nameLabel setFrame:CGRectMake(10,0,250,CGRectGetHeight(self.bounds))];
        [self.iconImageView setFrame:CGRectMake(275,15,30,30)];
        [self.auodioGuideIndicator setFrame:CGRectMake(30,20,20,20)];
        [self.manyAnimalsIndicator setFrame:CGRectMake(5,20,20,20)];
        self.nameLabel.textAlignment = UITextAlignmentRight;
    }else{
        self.nameLabel.text = self.exhibit.nameEn;
        [self.nameLabel setFrame:CGRectMake(65,0,250,CGRectGetHeight(self.bounds))];
        [self.iconImageView setFrame:CGRectMake(10,15,30,30)];
        [self.auodioGuideIndicator setFrame:CGRectMake(265,20,20,20)];
        [self.manyAnimalsIndicator setFrame:CGRectMake(290,20,20,20)];
        self.nameLabel.textAlignment = UITextAlignmentLeft;
    }
    
    if([exhibit.audioGuide boolValue]){
        [self.auodioGuideIndicator setImage:[UIImage imageNamed:@"323-Headphones"]];
    }else{
       [self.auodioGuideIndicator setImage:nil];
    }
    
    if([exhibit.manyAnimals boolValue]){
        [self.manyAnimalsIndicator setImage:[UIImage imageNamed:@"098-ShareThis"]];
    }else{
        [self.manyAnimalsIndicator setImage:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAnExhibit:(Exhibit*)anExhibit{
    if (self.exhibit==anExhibit) {
        return;
    }
    self.exhibit = anExhibit;
    [self setNeedsDisplay];
}

@end
