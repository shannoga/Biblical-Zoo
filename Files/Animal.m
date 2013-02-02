//
//  Animal.m
//  ParseStarterProject
//
//  Created by shani hajbi on 13/06/12.
//  Copyright (c) 2012 shannpga@me.com. All rights reserved.
//

#import "Animal.h"
#import "Exhibit.h"

@implementation Animal

@dynamic exhibitId;
@dynamic binomialName;
@dynamic bioClass;
@dynamic conservationStatus;
@dynamic createdAt;
@dynamic diet;
@dynamic family;
@dynamic generalDescription;
@dynamic habitat;
@dynamic name;
@dynamic objectId;
@dynamic socialStructure;
@dynamic updatedAt;
@dynamic verse;
@dynamic youTubeUrl;
@dynamic zooDescription;
@dynamic zooItems;
@dynamic local;
@dynamic exhibit;
@dynamic audioGuide;
@dynamic nameEn;
@dynamic visible;
@dynamic generalExhibitDescription;


+(BOOL)updateFromParseAnimalObject:(PFObject*)animal inContext:(NSManagedObjectContext*)context{
    
    
    Animal *animalEntity = (Animal*) [Animal findAnimalByObjectId:animal.objectId];
    NSDate *localUpdateDate = animalEntity.updatedAt;
    NSDate *remoteUpdateDate = animal.updatedAt;
    NSArray *availableKeys = [[animalEntity.entity attributesByName] allKeys];
    
 

    if ([localUpdateDate compare:remoteUpdateDate] == NSOrderedAscending){
        for (NSString *key in [animal allKeys]) {
            
            if ([key isEqualToString:@"generalExhibitDescription"]) {
                NSLog(@"animal generalExhibitDescription = %@",[animal[@"generalExhibitDescription"] boolValue]?@"YES":@"NO");
            }
             if ([availableKeys containsObject:key]) {
                 [animalEntity setValue:animal[key] forKey:key];
             }
            if (![Helper isRightToLeft]) {
                animalEntity.nameEn = animal[@"name"];
            }
            animalEntity.createdAt = animal.createdAt;
            animalEntity.updatedAt = animal.updatedAt;
           
            
            Exhibit *exhibitForNewAnimal = [Exhibit findExhibitWithId:animal[@"exhibitId"]];
            if (exhibitForNewAnimal) {
                animalEntity.exhibit = exhibitForNewAnimal;
            }
            
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


+(BOOL)createFromParseAnimalObject:(PFObject*)animal forLocal:(NSString*)local inContext:(NSManagedObjectContext*)context{
    
    Animal * animalNewEntity =[Animal createInContext:[NSManagedObjectContext defaultContext]];
       NSArray *availableKeys = [[animalNewEntity.entity attributesByName] allKeys];
    for (NSString *key in [animal allKeys]) {
        if ([availableKeys containsObject:key]) {
        [animalNewEntity setValue:animal[key] forKey:key];
        }
        animalNewEntity.createdAt = animal.createdAt;
        animalNewEntity.updatedAt = animal.updatedAt;
        animalNewEntity.objectId = animal.objectId;
        if (local == @"en") {
         animalNewEntity.nameEn = animal[@"name"];
        }
  
        animalNewEntity.local = [Helper currentLang];
        Exhibit *exhibitForNewAnimal = [Exhibit findExhibitWithId:animal[@"exhibitId"]];
        if (exhibitForNewAnimal) {
            animalNewEntity.exhibit = exhibitForNewAnimal;
        }
        
    }
    NSLog(@"animalNewEntity = %@",[animalNewEntity description]);
    
    [[NSManagedObjectContext defaultContext]save];
     [[NSManagedObjectContext defaultContext]saveNestedContexts];
    
    return YES;
}

+(NSArray*)findAnimalsWithExhibitId:(NSString*)exhibitIdToFind{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"exhibitId == %@",exhibitIdToFind];
    NSArray *animals = [Animal findAllWithPredicate:predicate];
    return animals;
}
+(Animal*)findAnimalByObjectId:(NSString*)animalId{
    Animal *foundAnimal = [Animal findFirstByAttribute:@"objectId" withValue:animalId];
    return foundAnimal;
}

-(NSArray*)images{
    NSInteger counter = 1;
    NSMutableArray *imagesArray = [NSMutableArray array];
    NSString *animalName = [[NSString stringWithFormat:@"%@",[self.nameEn stringByReplacingOccurrencesOfString:@" " withString:@"_"]] lowercaseString];
    while ([UIImage imageNamed:[NSString stringWithFormat:@"%@_%i.jpg",animalName,counter]]!=nil) {
        [imagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%i.jpg",animalName,counter]]];
       
        counter++;
    }
    return imagesArray;
}

-(UIImage*)distributaionMap{
    #warning fix to return the map
    return [UIImage imageNamed:@""];
}

@end
