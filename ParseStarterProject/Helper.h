//
//  Helper.h
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 3/24/11.
//  Copyright 2011 shani hajbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JerusalemBiblicalZooAppDelegate.h"
#import "Animal.h"

@interface Helper : NSObject 

+(JerusalemBiblicalZooAppDelegate*)appDelegate;
+(NSManagedObjectContext*)appContext;
+(void)saveContext;
    
+(UIColor*)conservationStatusColor:(Animal*)animal;
+(NSString *)obfuscate:(NSString *)string withKey:(NSString *)key;
+ (BOOL)isDeviceAniPad;
+(NSString*)currentLang;
+(BOOL)isEnglish;
+(BOOL)isRightToLeft;
+ (float)degreesToRadians:(float)degrees;
+(NSString*)settingsLang;
+(NSBundle*)getBundleForLang:(NSString*)lang;
+(NSBundle*)currentBundle;
+(NSString*)deviceLang;
+(NSString*)audioGuideFilesPath;
+(NSString*)tempFilesPath;
@end

