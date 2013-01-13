//
//  AnimalsImagesScrollView.m
//  ParseStarterProject
//
//  Created by shani hajbi on 6/22/12.
//
//

#import "AnimalsImagesScrollView.h"
#import "OMPageControl.h"
#import "Animal.h"
@implementation AnimalsImagesScrollView
@dynamic animal;
@synthesize scrollView;

- (id)initWithFrame:(CGRect)frame withAnimal:(Animal*)anAnimal
{
    self = [super initWithFrame:frame];
    if (self) {
        pageControlUsed=NO;
        /*****************************************/
        /* sets the images*/
        /*****************************************/
        ////load the images of the animal to the scroll view
        NSLog(@"animal =%@",anAnimal.nameEn);
        NSArray *images = [NSArray arrayWithArray:[anAnimal images]];
        NSLog(@"images = %@",images);
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.contentSize =CGSizeMake(320*[images count], 190);
        self.scrollView.scrollEnabled=YES;
        self.scrollView.scrollsToTop=NO;
        self.scrollView.pagingEnabled=YES;
        self.scrollView.delegate =self;
        [self.scrollView becomeFirstResponder];
        self.scrollView.showsVerticalScrollIndicator = self.scrollView.showsHorizontalScrollIndicator = NO;
        UIImageView *imageView;
        for (NSUInteger i=0; i<[images count]; i++) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*320,0, 320, 190)];
            [imageView setImage:images[i]];
            [self.scrollView addSubview:imageView];
        }
        [self addSubview:scrollView];
        
        
        /*****************************************/
        /* sets the pageControll*/
        /*****************************************/
        /*
        UIImage * img = [UIImage imageNamed:@"animals2.png"];
        //add page controll
        pageControl=[[OMPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.scrollView.bounds)-[img size].height,CGRectGetWidth(self.scrollView.bounds), [img size].height)];
        pageControl.numberOfPages=[images count];
        pageControl.imageNormal = img;
        pageControl.imageCurrent = [UIImage imageNamed:@"animals.png"];
        [self.view addSubview:pageControl];
         */
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 170, 320, 20)];
        pageControl.numberOfPages= [images count];
        [self addSubview:pageControl];
        
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlUsed = NO;
}



@end
