//
//  MapAnnotationView.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 1/4/13.
//
//

#import <MapKit/MapKit.h>
#import "Exhibit.h"
@interface MapAnnotationView : MKAnnotationView

@property double scale;
@property (nonatomic,strong) Exhibit *exhibit;
- (id) initWithAnnotation: (id <MKAnnotation>) annotation reuseIdentifier: (NSString *) reuseIdentifier;
@end
