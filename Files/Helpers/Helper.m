//
//  Helper.m
//  Jerusalem Biblical Zoo
//
//  Created by shani hajbi on 3/24/11.
//  Copyright 2011 shani hajbi. All rights reserved.
//

#import "Helper.h"
#import "NSFileManager+DirectoryLocations.h"
#import "Exhibit.h"
@implementation Helper

+(JerusalemBiblicalZooAppDelegate*)appDelegate{
    
    return (JerusalemBiblicalZooAppDelegate*)[[UIApplication sharedApplication] delegate];
}

+(NSManagedObjectContext*)appContext{
    return [NSManagedObjectContext defaultContext];
}


+(void)saveContext{
    [[NSManagedObjectContext defaultContext] save];
}



+(UIColor*)conservationStatusColor:(Animal*)animal{
    __block NSInteger colorIndex;
    NSArray *conservationStatusArray = @[@"LC",
                                        @"NT",
                                        @"VU",
                                        @"EN",
                                        @"CR",
                                        @"EW",
                                        @"EX"];
    [conservationStatusArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:animal.conservationStatus]) {
            colorIndex=idx;
        }
    }];
    
    NSArray *colors = @[UIColorFromRGB(0x0B5453),UIColorFromRGB(0x0B5453),UIColorFromRGB(0xBF8807),UIColorFromRGB(0xC05D36),UIColorFromRGB(0xBE1E27),UIColorFromRGB(0x000000),UIColorFromRGB(0x000000)];
    
    return colors[colorIndex];
}

+(NSBundle*)getBundleForLang:(NSString*)lang{
    // find the path to the bundle based on the locale
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:lang];
    
    // load it!
    NSBundle *langBundle = [[NSBundle alloc] initWithPath:[bundlePath stringByDeletingLastPathComponent]];
    return langBundle;
}

+(NSBundle*)currentBundle{
    NSBundle *langBundle = [Helper getBundleForLang:[Helper currentLang]];
    return langBundle;
}

+(NSBundle*)localizationBundle{
    NSString *path;
    
    if ([self appLang]==kHebrew) {
        path = [[NSBundle mainBundle] pathForResource:@"he" ofType:@"lproj"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
    }
	
	return [NSBundle bundleWithPath:path];
}

+(NSString*) languageSelectedStringForKey:(NSString*) key
{
	NSBundle* languageBundle = [self localizationBundle];
	NSString* str=[languageBundle localizedStringForKey:key value:@"" table:nil];
	return str;
}

+(Langs)appLang{
    NSInteger lang = [[NSUserDefaults standardUserDefaults] integerForKey:@"lang"];
    return lang;
}

+(BOOL)isLangRTL{
    if ([self appLang]==kHebrew) {
        return YES;
    }
    return NO;
}


+(NSString *)obfuscate:(NSString *)string withKey:(NSString *)key
{
    // Create data object from the string
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // Get pointer to data to obfuscate
    char *dataPtr = (char *) [data bytes];
    
    // Get pointer to key data
    char *keyData = (char *) [[key dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    // Points to each char in sequence in the key
    char *keyPtr = keyData;
    int keyIndex = 0;
    
    // For each character in data, xor with current value in key
    for (int x = 0; x < [data length]; x++) 
    {
        // Replace current character in data with 
        // current character xor'd with current key value.
        // Bump each pointer to the next character
        *dataPtr = *dataPtr++ ^ *keyPtr++; 
        
        // If at end of key data, reset count and 
        // set key pointer back to start of key value
        if (++keyIndex == [key length])
            keyIndex = 0, keyPtr = keyData;
    }
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSArray*)fetchForCardsEntity:(NSString*)entityName withPredicate:(NSString*)predicateFormat withSortDiscriptor:(NSString*)sortdDscriptorName{
    NSManagedObjectContext *moc=[Helper appContext];
    NSEntityDescription *entityDescription;
    NSPredicate *predicate;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
    [request setEntity:entityDescription];
    
    predicate = [NSPredicate predicateWithFormat: predicateFormat];
    [request setPredicate:predicate];
    
    if (sortdDscriptorName) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:sortdDscriptorName ascending:YES];
        [request setSortDescriptors:@[sortDescriptor]];
    }
    
    
    NSError *error = nil;
    NSArray * requestArray =[moc executeFetchRequest:request error:&error];
    if (requestArray == nil)
    {
        // Deal with error...
    }
    return requestArray;
    
}

+(void)sortCardsByCardNamber:(NSMutableArray*)cardsArray{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"card_number"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [cardsArray sortUsingDescriptors:sortDescriptors];
}

+(NSString*)getLocalizedString:(NSString*)str{
	return NSLocalizedString(str,@"");
}

+ (NSString *) imageNamedSmart:(NSString *)name
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        NSString *imageName =  [NSString stringWithFormat:@"%@@2x.png",name];
        // NSString *imagefile = [[NSBundle mainBundle]pathForResource:imageName ofType:@"png"];
        return imageName;
        
    }
    return [NSString stringWithFormat:@"%@.png",name];
}


+(NSString*)strip_fromString:(NSString*)string{
    
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    return string;
    
}

+ (BOOL)isDeviceAniPad {
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

+(NSString*)currentLang{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
	return languages[0];
}

+(BOOL)isEnglish{
	
	return [@"en" isEqualToString:[self currentLang]];
}


+(BOOL)isRightToLeft{
	return ([@"he" isEqualToString:[self currentLang]]||[@"ar" isEqualToString:[self currentLang]]);
}

+ (float)degreesToRadians:(float)degrees{
    return degrees / 57.2958;
}

+(NSString*)deviceLang{
    NSString * language = [NSLocale preferredLanguages][0];
    return language;
}



+(NSString*)audioGuideFilesPath{
    NSString *path;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        //exclude the audio guide folder from backup
        path =[[NSFileManager defaultManager] applicationSupportDirectory:NO];
    }else{
        path =[[NSFileManager defaultManager] applicationTempDirectory];
    }
    return path;
}

+(NSString*)tempFilesPath{
    NSString *path =[[NSFileManager defaultManager] applicationTempDirectory];
    return path;

}

+(BOOL)bugsenseOn{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"agreedBugsense"];
}

+(void)setCurrentExhibit:(Exhibit*)exhibit{
    [[[self appDelegate] mapController] setCenterLocationAndShowMapForExhibit:exhibit];
}
+(BOOL)isRetina{
        return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))?1:0;
    
}
+(NSString*)visitoresChannelName{
    NSString *visitorsCahnnel;
    if(![Helper isRightToLeft]){
        visitorsCahnnel = @"Visitors_En";
    }else{
        visitorsCahnnel = @"Visitors_He";
    }
    return visitorsCahnnel;
}


+ (UIColor*)colorForConservationStatus:(ConservationStatus)status
{
    switch (status) {
        case ConLC:
            return UIColorFromRGB(0x06968);
            break;
        case ConNT:
            return UIColorFromRGB(0x06968);
            break;
        case ConVU:
            return UIColorFromRGB(0xD59A00);
            break;
        case ConEN:
            return UIColorFromRGB(0xDC5D02);
            break;
        case ConCR:
            return UIColorFromRGB(0xDF0012);
            break;
        case ConEW:
            return [UIColor blackColor];
            break;
        case ConEX:
            return [UIColor blackColor];
            break;
            
        default:
            break;
    }
    
}

+ (UIColor*)textColorForConservationStatus:(ConservationStatus)status
{
    switch (status) {
        case ConLC:
            return [UIColor whiteColor];
            break;
        case ConNT:
            return UIColorFromRGB(0x87D295);
            break;
        case ConVU:
            return [UIColor whiteColor];
            break;
        case ConEN:
            return [UIColor whiteColor];
            break;
        case ConCR:
            return [UIColor whiteColor];
            break;
        case ConEW:
            return [UIColor whiteColor];
            break;
        case ConEX:
            return UIColorFromRGB(0xDF0012);
            break;
            
        default:
            break;
    }
    
}


    

@end
