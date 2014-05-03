//
//  EventsController.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 5/2/14.
//
//

#import <Foundation/Foundation.h>
typedef void (^requestCompletioHandler)(BOOL success);

@interface EventsController : NSObject

+ (id)sharedController;
- (void)fetchEventsWithCompletionHandler:(requestCompletioHandler)handler;
@end
