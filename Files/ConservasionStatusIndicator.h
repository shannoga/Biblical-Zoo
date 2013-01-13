//
//  ConservasionStatusIndicator.h
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 12/26/10.
//  Copyright 2010 shani hajbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class Animal;

@interface ConservasionStatusIndicator : UIView {
	BOOL isDetails;
    Animal *animal;
}

@property (nonatomic, strong) Animal *animal;
- (void)showDetails;
@end
