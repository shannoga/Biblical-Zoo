//
//  Exhibit.m
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

//NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:@"es"];

#import "Exhibit.h"
#import "Animal.h"
#import "UIImage+Helper.h"


@implementation Exhibit

@dynamic animals;
@dynamic mapIcon;
@dynamic manyAnimals;
@dynamic free;

+(NSArray*)allObjects{
    NSManagedObjectContext *moc = [NSManagedObjectContext defaultContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:[self description] inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setIncludesPendingChanges:YES];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        return nil;
    }
    return array;
}

-(NSArray*)localAnimals{
  
    NSArray *allAnimals = [[self animals] allObjects];
    
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"local == %@",[Helper appLang]==kHebrew?@"he":@"en"];
    allAnimals = [allAnimals filteredArrayUsingPredicate:predicate];

    return allAnimals;
}



+(BOOL)updateFromParseExhibitObject:(PFObject*)exhibit inContext:(NSManagedObjectContext*)context{
    
  
    Exhibit *exhibitEntity = (Exhibit*) [Exhibit findExhibitWithId:exhibit.objectId];
    NSDate *localUpdateDate = exhibitEntity.updatedAt;
    NSDate *remoteUpdateDate = exhibit.updatedAt;
    NSArray *availableKeys = [[exhibitEntity.entity attributesByName] allKeys];

    if ([localUpdateDate compare:remoteUpdateDate] == NSOrderedAscending){
        
        
        for (NSString *key in [exhibit allKeys]) {
              if ([availableKeys containsObject:key] && ![key isEqualToString:@"mapIcon"]) {
                  [exhibitEntity setValue:exhibit[key] forKey:key];
              }else if([key isEqualToString:@"mapIcon"]){
                      
                 PFFile *iconData = exhibit[@"mapIcon"];
                      if(![iconData isKindOfClass:[NSNull class]]){
                          NSData *icon = [iconData getData];
                          UIImage *icomImage = [[UIImage alloc] initWithData:icon];
                          exhibitEntity.mapIcon = [icomImage normalize];
                      }
                }
      
                  exhibitEntity.updatedAt = exhibit.updatedAt;
                  //remove all animals from relatioship
                  exhibitEntity.animals=nil;
                  NSArray *animalsInExhibit = [Animal findAnimalsWithExhibitId:exhibit.objectId];
                  
                  NSSet *animalsInExhibitAsSet = [NSSet setWithArray:animalsInExhibit];
                  [exhibitEntity addAnimals:animalsInExhibitAsSet];
        }
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return NO;
            abort();
        }
    }
    
    return YES;
}




+(BOOL)createFromParseExhibitObject:(PFObject*)exhibit  inContext:(NSManagedObjectContext*)context{
    
    
    NSManagedObjectModel *managedObjectModel = [[context persistentStoreCoordinator] managedObjectModel];
    NSEntityDescription *entity = [managedObjectModel entitiesByName][@"Exhibit"];
    Exhibit *exhibitNewEntity = (Exhibit*) [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    NSArray *availableKeys = [[exhibitNewEntity.entity attributesByName] allKeys];
  
    
    for (NSString *key in [exhibit allKeys]) {
        if ([availableKeys containsObject:key] && ![key isEqualToString:@"mapIcon"]) {
            [exhibitNewEntity setValue:exhibit[key] forKey:key];
        }else if([key isEqualToString:@"mapIcon"]){
            PFFile *iconData = exhibit[@"mapIcon"];
            if(![iconData isKindOfClass:[NSNull class]]){
                NSData *icon = [iconData getData];
                UIImage *icomImage = [[UIImage alloc] initWithData:icon];
                exhibitNewEntity.mapIcon = [icomImage normalize];
            }
        }
        
        exhibitNewEntity.createdAt = exhibit.createdAt;
        exhibitNewEntity.updatedAt = exhibit.updatedAt;
        exhibitNewEntity.objectId = exhibit.objectId;
        
        NSArray *animalsInExhibit = [Animal findAnimalsWithExhibitId:exhibit.objectId];
      
        NSSet *animalsInExhibitAsSet = [NSSet setWithArray:animalsInExhibit];
        [exhibitNewEntity addAnimals:animalsInExhibitAsSet];
        
    }
    //NSLog(@"exhibitNewEntity = %@",[exhibitNewEntity description]);
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return NO;
        abort();
    }
    
    return YES;
}

+(Exhibit*)findExhibitWithId:(NSString*)exhibitId{
    NSManagedObjectContext *moc = [NSManagedObjectContext defaultContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:[self description] inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    [request setIncludesPendingChanges:YES];
    
    NSPredicate *predicare = [NSPredicate predicateWithFormat:@"objectId == %@",exhibitId];
    [request setPredicate:predicare];
    
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        return nil;
    }
    return [array lastObject];
}

-(UIImage*)icon{
    return self.mapIcon;
}


- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self.latitude doubleValue];
    theCoordinate.longitude = [self.longitude doubleValue];
    return theCoordinate; 
}


-(NSArray*)colors{
    
    NSArray * cellColors;
    
    if ([self.manyAnimals boolValue]) {
   
            cellColors = @[(id)[UIColorFromRGB(0x3A2E23) CGColor],
                                        (id)[UIColorFromRGB(0x42352a) CGColor]];
    }else{
            cellColors = @[(id)[UIColorFromRGB(0x91bbc0) CGColor],
                          (id)[UIColorFromRGB(0x98c1c6) CGColor]];
    }
    /*
        case kEventTypeKids:
            cellColors = [NSArray arrayWithObjects:
                          (id)[UIColorFromRGB(0x6db472) CGColor],//kids
                          (id)[UIColorFromRGB(0x6db472) CGColor],nil];
            break;
        case kEventTypeMusic:
            cellColors = [NSArray arrayWithObjects:
                          (id)[UIColorFromRGB(0xFF733B) CGColor],
                          (id)[UIColorFromRGB(0xFF733B) CGColor],nil];
            break;
        case kEventTypeShow:
            cellColors = [NSArray arrayWithObjects:
                          (id)(id)[UIColorFromRGB(0xFFCC41) CGColor],
                          (id)[UIColorFromRGB(0xFFCC41) CGColor],nil];
            break;
        case kEventTypeWorkShop:
            cellColors = [NSArray arrayWithObjects:
                          (id)[UIColorFromRGB(0xA86EAD) CGColor],
                          (id)[UIColorFromRGB(0xA86EAD) CGColor],nil];
            break;
            
    }
    */
    
    return cellColors;
}


@end

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return uiImage;
}

@end


