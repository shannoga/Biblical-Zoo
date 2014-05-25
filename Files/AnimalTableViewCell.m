//
//  AnimalTableViewCell.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/16/12.
//
//

#import "AnimalTableViewCell.h"

@implementation AnimalTableViewCell

@synthesize nameLabel;
@synthesize iconImageView;
@synthesize animal;
@synthesize auodioGuideIndicator;
@synthesize manyAnimalsIndicator;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.nameLabel.textColor = [UIColor blackColor];
        
        UIFont *font;
        if([Helper appLang]==kHebrew){
            font =  [UIFont fontWithName:@"ArialHebrew-Bold" size:20];
        }else{
            font =  [UIFont fontWithName:@"Futura" size:20];
        }
        self.nameLabel.font = font;
        self.nameLabel.backgroundColor = [UIColor clearColor];
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.auodioGuideIndicator = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.manyAnimalsIndicator= [[UIImageView alloc] initWithFrame:CGRectZero];
        
        [self addSubview:self.manyAnimalsIndicator];
        [self addSubview:self.auodioGuideIndicator];
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
        
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = UIColorFromRGB(0xBDB38C);
        [self setSelectedBackgroundView:bgView];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

-(void)layoutSubviews{
    
    CGRect newCellSubViewsFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGRect newCellViewFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    self.contentView.frame = self.contentView.bounds = self.backgroundView.frame = self.accessoryView.frame = newCellSubViewsFrame;
    self.frame = newCellViewFrame;
    
    [super layoutSubviews];
    
   // UIImage *icon = [exhibit icon];
   // self.iconImageView.image = icon;
    
    if([Helper appLang]==kHebrew){
        self.nameLabel.text =self.animal.name;
        [self.nameLabel setFrame:CGRectMake(10,0,250,CGRectGetHeight(self.bounds))];
        [self.iconImageView setFrame:CGRectMake(270,10,40,40)];
        [self.auodioGuideIndicator setFrame:CGRectMake(30,20,20,20)];
        [self.manyAnimalsIndicator setFrame:CGRectMake(5,20,20,20)];
        self.nameLabel.textAlignment = NSTextAlignmentRight;
    }else{
        self.nameLabel.text = self.animal.nameEn;
        [self.nameLabel setFrame:CGRectMake(65,0,250,CGRectGetHeight(self.bounds))];
        [self.iconImageView setFrame:CGRectMake(5,10,40,40)];
        [self.auodioGuideIndicator setFrame:CGRectMake(265,20,20,20)];
        [self.manyAnimalsIndicator setFrame:CGRectMake(290,20,20,20)];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    if([self.animal.audioGuide boolValue]){
        [self.auodioGuideIndicator setImage:[UIImage imageNamed:@"323-Headphones"]];
    }else{
        [self.auodioGuideIndicator setImage:nil];
    }
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setAnAnimal:(Animal *)anAnimal{
    if (self.animal==anAnimal) {
        return;
    }
    self.animal = anAnimal;
    [self setNeedsDisplay];
}

@end
