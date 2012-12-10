/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "PF_FBSession.h"

// Methods here are meant to be used only by internal subclasses of PF_FBSession
// and not by any other classes, external or internal.
@interface PF_FBSession (Protected)

- (BOOL)transitionToState:(PF_FBSessionState)state
           andUpdateToken:(NSString*)token
        andExpirationDate:(NSDate*)date
              shouldCache:(BOOL)shouldCache
                loginType:(PF_FBSessionLoginType)loginType;
- (void)transitionAndCallHandlerWithState:(PF_FBSessionState)status
                                    error:(NSError*)error
                                    token:(NSString*)token
                           expirationDate:(NSDate*)date
                              shouldCache:(BOOL)shouldCache
                                loginType:(PF_FBSessionLoginType)loginType;
- (void)authorizeWithPermissions:(NSArray*)permissions
                        behavior:(PF_FBSessionLoginBehavior)behavior
                 defaultAudience:(PF_FBSessionDefaultAudience)audience
                   isReauthorize:(BOOL)isReauthorize;

+ (NSError*)errorLoginFailedWithReason:(NSString*)errorReason
                             errorCode:(NSString*)errorCode
                            innerError:(NSError*)innerError;

@end
