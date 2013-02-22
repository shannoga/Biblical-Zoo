//
//  MapAnnotationView.m
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/4/13.
//
//

#import "MapAnnotationView.h"

@implementation MapAnnotationView
@synthesize exhibit,scale;

- (id) initWithAnnotation: (id <MKAnnotation>) annotation reuseIdentifier: (NSString *) reuseIdentifier
{
    self = [super initWithAnnotation: annotation reuseIdentifier: reuseIdentifier];
    if (self != nil)
    {
        self.frame = CGRectMake(0, 0, 30, 30);
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIImage * backgroundImage = [self.exhibit icon];
    CGRect annotationRectangle = CGRectMake(30/2-60*scale/2, 30/2-60*scale/2, 60*scale, 60*scale);
    [backgroundImage drawInRect: annotationRectangle];
}


@end
