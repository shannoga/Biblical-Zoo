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

+(Langs)appLang;

+(UIColor*)conservationStatusColor:(Animal*)animal;

+(BOOL)isDeviceAniPad;
+(BOOL)isEnglish;
+(BOOL)isRightToLeft;
+(BOOL)isLion;
+(BOOL)bugsenseOn;
+(BOOL)isRetina;
+(BOOL)isLangRTL;
+(NSString*) languageSelectedStringForKey:(NSString*) key;
+(float)degreesToRadians:(float)degrees;


+(NSBundle*)getBundleForLang:(NSString*)lang;
+(NSBundle*)currentBundle;
+(NSBundle*)localizationBundle;
+(NSString *)obfuscate:(NSString *)string withKey:(NSString *)key;
+(NSString*)deviceLang;
+(NSString*)audioGuideFilesPath;
+(NSString*)tempFilesPath;
+(NSString*)currentLang;
+(NSString*)visitoresChannelName;

+(void)setCurrentExhibit:(Exhibit*)exhibit;
+(void)saveContext;

@end

