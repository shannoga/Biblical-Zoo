//
//  SignForFriendView_HalfSize.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 2/3/13.
//
//

#import "SignForFriendView_HalfSize.h"
#import "UIImage+Helper.h"
@implementation SignForFriendView_HalfSize

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
    
    if (![Helper isRightToLeft]) {
        
        //zoo symbole
        [[UIImage imageNamed:@"zoo_logo300"] drawAtPoint:CGPointMake(100/2, 40/2)];
        
        [UIColorFromRGB(0x3B2F24) set];
        //name
        UIFont *nameFont = [UIFont fontWithName:@"Futura" size:130/2];
        NSString *name = signDic[@"name"];
        [name drawAtPoint:CGPointMake(520/2, 30/2) withFont:nameFont];
        
        //binomail name
        [[UIColor darkGrayColor] set];
        UIFont *binomialNameFont = [UIFont fontWithName:@"Futura" size:100/2];
        NSString *binomialName = signDic[@"binomialName"];
        [binomialName drawAtPoint:CGPointMake(500/2, 220/2) withFont:binomialNameFont];
        
        
        UIFont *titleFont = [UIFont fontWithName:@"Futura" size:50/2];
        UIFont *textFont = [UIFont fontWithName:@"Futura" size:44/2];
        //habitat
        //habitat title
        [[UIColor blackColor] set];
        [@"Habitat" drawAtPoint:CGPointMake(100/2, 400/2) withFont:titleFont];
        //habitat title
        [@"Diet" drawAtPoint:CGPointMake(850/2, 400/2) withFont:titleFont];
        //habitat title
        [@"Social structure" drawAtPoint:CGPointMake(1600/2, 400/2) withFont:titleFont];
        
        // [[UIColor whiteColor] set];
        [signDic[@"habitat"] drawInRect:CGRectMake(100/2, 500/2, 600/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        [signDic[@"diet"]    drawInRect:CGRectMake(850/2, 500/2, 600/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        [signDic[@"social"]  drawInRect:CGRectMake(1600/2, 500/2, 600/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        
        [[UIColor whiteColor] set];
        [@"Description" drawAtPoint:CGPointMake(100/2, 900/2) withFont:titleFont];
        [signDic[@"description"]  drawInRect:CGRectMake(100/2, 1000/2, 2000/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft];
        
        [@"Created in the Jerusalem Biblical Zoo App" drawAtPoint:CGPointMake(100/2, 1370/2) withFont:textFont];
    }else{
        //Right To Left Sign
        //zoo symbole
        [[UIImage imageNamed:@"zoo_logo300"] drawAtPoint:CGPointMake(1800/2, 40/2)];
        
        [UIColorFromRGB(0x3B2F24) set];
        //name
        UIFont *nameFont = [UIFont fontWithName:@"Futura" size:130/2];
        NSString *name = signDic[@"name"];
        [name drawInRect:CGRectMake(520/2, 30/2, 1200/2, 100/2) withFont:nameFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        //binomail name
        [[UIColor darkGrayColor] set];
        UIFont *binomialNameFont = [UIFont fontWithName:@"Futura" size:100/2];
        NSString *binomialName = signDic[@"binomialName"];
        [binomialName drawInRect:CGRectMake(520/2, 220/2, 1200/2, 100/2) withFont:binomialNameFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        
        
        UIFont *titleFont = [UIFont fontWithName:@"Futura" size:50/2];
        UIFont *textFont = [UIFont fontWithName:@"Futura" size:44/2];
        //habitat
        //habitat title
        [[UIColor blackColor] set];
        [NSLocalizedString(@"habitat",nil) drawInRect:CGRectMake(150/2, 400/2, 600/2, 100/2) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        //habitat title
        [NSLocalizedString(@"diet",nil) drawInRect:CGRectMake(800/2, 400/2, 600/2, 100/2) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        //habitat title
        [NSLocalizedString(@"social structure",nil) drawInRect:CGRectMake(1500/2, 400/2, 600/2, 100/2) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        // [[UIColor whiteColor] set];
        [signDic[@"habitat"] drawInRect:CGRectMake(150/2, 500/2, 600/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        [signDic[@"diet"]    drawInRect:CGRectMake(800/2, 500/2, 600/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        [signDic[@"social"]  drawInRect:CGRectMake(1500/2, 500/2, 600/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        [[UIColor whiteColor] set];
        [NSLocalizedString(@"description",nil) drawInRect:CGRectMake(100/2, 900/2, 2000/2, 100/2) withFont:titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        [signDic[@"description"]  drawInRect:CGRectMake(100/2, 1000/2, 2000/2, 300/2) withFont:textFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        
        [@"נוצר באפליקציית גן החיות התנכ''י בירושלים." drawAtPoint:CGPointMake(1400/2, 1370/2) withFont:textFont];
        
    }
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",nil)
                                           message:NSLocalizedString(@"Unable to save image to Photo Album." ,nil)
                                          delegate:self cancelButtonTitle:NSLocalizedString(@"Dismiss",nil)
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                           message:@"Image saved to Photo Album."
                                          delegate:self cancelButtonTitle:@"Dismiss"
                                 otherButtonTitles:nil];
    [alert show];
}


@end

