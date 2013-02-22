//
//  SignForFriendView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 12/18/12.
//
//

#import "SignForFriendView.h"
#import "UIImage+Helper.h"

@implementation SignForFriendView
@synthesize signDic;

- (id)initWithFrame:(CGRect)frame WithSignDic:(NSDictionary*)dictionary;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.signDic = [NSDictionary dictionaryWithDictionary:dictionary];
        self.backgroundColor = UIColorFromRGB(0x3D3227);
    }
    return self;
}
-(UIImage*)renderFinalImage{
    UIImage *image = [UIImage imageWithView:self];
    NSLog(@"image size %@",NSStringFromCGSize([image size]));
    // Save the captured image to photo album
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    return image;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
   //white rect
    CGRect rectangle = CGRectMake(0,0,rect.size.width,rect.size.height*0.26);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rectangle);
    
    //yellow rect
    rectangle = CGRectMake(0,rect.size.height*0.26,rect.size.width,rect.size.height*0.34);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context,UIColorFromRGB(0xFFCA00).CGColor);
    CGContextFillRect(context, rectangle);
    
    //green rect
    rectangle = CGRectMake(0,rect.size.height*0.60,rect.size.width,rect.size.height*0.34);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, UIColorFromRGB(0x007E00).CGColor);
    CGContextFillRect(context, rectangle);
    
    if ([Helper appLang]==kEnglish) {
    
        //zoo symbole
        [[UIImage imageNamed:@"zoo_logo600"] drawAtPoint:CGPointMake(100, 40)];
        
        [UIColorFromRGB(0x3B2F24) set];
        //name
        UIFont *nameFont = [UIFont fontWithName:@"Futura" size:130];
        NSString *name = signDic[@"name"];
        [name drawAtPoint:CGPointMake(520, 30) withFont:nameFont];
        
        //binomail name
        [[UIColor darkGrayColor] set];
        UIFont *binomialNameFont = [UIFont fontWithName:@"Futura" size:100];
        NSString *binomialName = signDic[@"binomialName"];
        [binomialName drawAtPoint:CGPointMake(500, 220) withFont:binomialNameFont];
        
        
        UIFont *titleFont = [UIFont fontWithName:@"Futura" size:50];
        UIFont *textFont = [UIFont fontWithName:@"Futura" size:44];
        //habitat
        //habitat title
        [[UIColor blackColor] set];
        [@"Habitat" drawAtPoint:CGPointMake(100, 400) withFont:titleFont];
        //habitat title
        [@"Diet" drawAtPoint:CGPointMake(850, 400) withFont:titleFont];
        //habitat title
        [@"Social structure" drawAtPoint:CGPointMake(1600, 400) withFont:titleFont];
        
        // [[UIColor whiteColor] set];
        [signDic[@"habitat"] drawInRect:CGRectMake(100, 500, 600, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        [signDic[@"diet"]    drawInRect:CGRectMake(850, 500, 600, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        [signDic[@"social"]  drawInRect:CGRectMake(1600, 500, 600, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        
        [[UIColor whiteColor] set];
        [@"Description" drawAtPoint:CGPointMake(100, 900) withFont:titleFont];
        [signDic[@"description"]  drawInRect:CGRectMake(100, 1000, 2000, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        
        [@"Created in the Jerusalem Biblical Zoo App" drawAtPoint:CGPointMake(100, 1370) withFont:textFont];
    }else{
        //Right To Left Sign
        //zoo symbole
        [[UIImage imageNamed:@"zoo_logo600"] drawAtPoint:CGPointMake(1800, 40)];
        
        [UIColorFromRGB(0x3B2F24) set];
        //name
        UIFont *nameFont = [UIFont fontWithName:@"Futura" size:130];
        NSString *name = signDic[@"name"];
        [name drawInRect:CGRectMake(520, 30, 1200, 100) withFont:nameFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        //binomail name
        [[UIColor darkGrayColor] set];
        UIFont *binomialNameFont = [UIFont fontWithName:@"Futura" size:100];
        NSString *binomialName = signDic[@"binomialName"];
        [binomialName drawInRect:CGRectMake(520, 220, 1200, 100) withFont:binomialNameFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];

        
        
        UIFont *titleFont = [UIFont fontWithName:@"Futura" size:50];
        UIFont *textFont = [UIFont fontWithName:@"Futura" size:44];
        //habitat
        //habitat title
        [[UIColor blackColor] set];
        [[Helper languageSelectedStringForKey:@"habitat"] drawInRect:CGRectMake(150, 400, 600, 100) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        //habitat title
        [[Helper languageSelectedStringForKey:@"diet"] drawInRect:CGRectMake(800, 400, 600, 100) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        //habitat title
        [[Helper languageSelectedStringForKey:@"social structure"] drawInRect:CGRectMake(1500, 400, 600, 100) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        // [[UIColor whiteColor] set];
        [signDic[@"habitat"] drawInRect:CGRectMake(150, 500, 600, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        [signDic[@"diet"]    drawInRect:CGRectMake(800, 500, 600, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        [signDic[@"social"]  drawInRect:CGRectMake(1500, 500, 600, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        [[UIColor whiteColor] set];
        [[Helper languageSelectedStringForKey:@"description"] drawInRect:CGRectMake(100, 900, 2000, 100) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];

        [signDic[@"description"]  drawInRect:CGRectMake(100, 1000, 2000, 300) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        [@"נוצר באפליקציית גן החיות התנכ''י בירושלים." drawAtPoint:CGPointMake(1400, 1370) withFont:textFont];

    }

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:[Helper languageSelectedStringForKey:@"Error"]
                                           message:[Helper languageSelectedStringForKey:@"Unable to save image to Photo Album."]
                                          delegate:self cancelButtonTitle:[Helper languageSelectedStringForKey:@"Dismiss"]
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:nil];
    [alert show];
}




@end
