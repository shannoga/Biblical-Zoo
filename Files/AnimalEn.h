//
//  AnimalEn.h
//  JerusalemBiblicalZoo
//
//  Created by shani hajbi on 6/7/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LocalAnimal.h"

@class Animal;

@interface AnimalEn : LocalAnimal

@property (nonatomic, retain) Animal *animal;

@end
