//
//  NSFileManager+DirectoryLocations.m
//
//  Created by Matt Gallagher on 06 May 2010
//
//  This software is provided 'as-is', without any express or implied
//  warranty. In no event will the authors be held liable for any damages
//  arising from the use of this software. Permission is granted to anyone to
//  use this software for any purpose, including commercial applications, and to
//  alter it and redistribute it freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//     claim that you wrote the original software. If you use this software
//     in a product, an acknowledgment in the product documentation would be
//     appreciated but is not required.
//  2. Altered source versions must be plainly marked as such, and must not be
//     misrepresented as being the original software.
//  3. This notice may not be removed or altered from any source
//     distribution.
//

#import "NSFileManager+DirectoryLocations.h"
#import <sys/xattr.h>
enum
{
	DirectoryLocationErrorNoPathFound,
	DirectoryLocationErrorFileExistsAtLocation
};
	
NSString * const DirectoryLocationDomain = @"DirectoryLocationDomain";

@implementation NSFileManager (DirectoryLocations)


- (BOOL)addSkipBackupAttributeToItemAtURLForIOSFivePointOne:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    const char* filePath = [[URL path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    
    if(result != 0){
        NSLog(@"Error excluding %@ from backup", [URL lastPathComponent]);
    }else {
        NSLog(@"excluding %@ from backup", [URL lastPathComponent]);
    }
    
    return result == 0;
}


- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: @YES
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }else {
        NSLog(@"excluding %@ from backup", [URL lastPathComponent]);
    }
    return success;
}


//
// findOrCreateDirectory:inDomain:appendPathComponent:error:
//
// Method to tie together the steps of:
//	1) Locate a standard directory by search path and domain mask
//  2) Select the first path in the results
//	3) Append a subdirectory to that path
//	4) Create the directory and intermediate directories if needed
//	5) Handle errors by emitting a proper NSError object
//
// Parameters:
//    searchPathDirectory - the search path passed to NSSearchPathForDirectoriesInDomains
//    domainMask - the domain mask passed to NSSearchPathForDirectoriesInDomains
//    appendComponent - the subdirectory appended
//    errorOut - any error from file operations
//
// returns the path to the directory (if path found and exists), nil otherwise
//
- (NSString *)findOrCreateDirectory:(NSSearchPathDirectory)searchPathDirectory
	inDomain:(NSSearchPathDomainMask)domainMask
	appendPathComponent:(NSString *)appendComponent
    backUp:(BOOL)backUp
	error:(NSError **)errorOut
     
{
	//
	// Search for the path
	//
	NSArray* paths = NSSearchPathForDirectoriesInDomains(
		searchPathDirectory,
		domainMask,
		YES);
	if ([paths count] == 0)
	{
		if (errorOut)
		{
			NSDictionary *userInfo =
				@{NSLocalizedDescriptionKey: NSLocalizedStringFromTable(
						@"No path found for directory in domain.",
						@"Errors",
					nil),
					@"NSSearchPathDirectory": @(searchPathDirectory),
					@"NSSearchPathDomainMask": @(domainMask)};
			*errorOut =
				[NSError 
					errorWithDomain:DirectoryLocationDomain
					code:DirectoryLocationErrorNoPathFound
					userInfo:userInfo];
		}
		return nil;
	}
	
	//
	// Normally only need the first path returned
	//
	NSString *resolvedPath = paths[0];

	//
	// Append the extra path component
	//
	if (appendComponent)
	{
		resolvedPath = [resolvedPath
			stringByAppendingPathComponent:appendComponent];
	}
	
	//
	// Create the path if it doesn't exist
	//
    if (![[NSFileManager defaultManager] fileExistsAtPath:resolvedPath]){
        NSError *error = nil;
        BOOL success = [self
            createDirectoryAtPath:resolvedPath
            withIntermediateDirectories:YES
            attributes:nil
            error:&error];
        if (!success) 
        {
            if (errorOut)
            {
                *errorOut = error;
            }
            return nil;
        }else {
            if(!backUp){
                    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.1")){
                            [self addSkipBackupAttributeToItemAtURL: [NSURL fileURLWithPath:resolvedPath]];
                    }else if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
                        [self addSkipBackupAttributeToItemAtURLForIOSFivePointOne:[NSURL fileURLWithPath:resolvedPath]];
                    }
            }
        }
        
    }
	
	//
	// If we've made it this far, we have a success
	//
	if (errorOut)
	{
		*errorOut = nil;
	}
	return resolvedPath;
}





//
// applicationSupportDirectory
//
// Returns the path to the applicationSupportDirectory (creating it if it doesn't
// exist).
//


- (NSString *)applicationSupportDirectory:(BOOL)backUp
{
	NSString *executableName =
		[[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
	NSError *error;
	NSString *result =
		[self
			findOrCreateDirectory:NSApplicationSupportDirectory
			inDomain:NSUserDomainMask
			appendPathComponent:executableName
             backUp:backUp 
			error:&error];
	if (!result)
	{
		NSLog(@"Unable to find or create application support directory:\n%@", error);
	}
	return result;
}





- (NSString *)applicationTempDirectory
{
	NSString *executableName =
    [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
	NSError *error;
	NSString *result =
    [self
     findOrCreateDirectory:NSDocumentDirectory
     inDomain:NSUserDomainMask
     appendPathComponent:executableName
     backUp:NO 
     error:&error];
	if (!result)
	{
		NSLog(@"Unable to find or create temp directory:\n%@", error);
	}
	return result;
}


@end
