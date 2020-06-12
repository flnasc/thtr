/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FIRSignUpNewUserRequest.h"

NS_ASSUME_NONNULL_BEGIN

/** @var kSignupNewUserEndpoint
    @brief The "SingupNewUserEndpoint" endpoint.
 */
static NSString *const kSignupNewUserEndpoint = @"signupNewUser";

/** @var kEmailKey
    @brief The key for the "email" value in the request.
 */
static NSString *const kEmailKey = @"email";

/** @var kUsernameKey
   @brief The key for the "kUsername" value in the request.
*/
static NSString *const kUsernameKey = @"username";

/** @var kFirstnameKey
   @brief The key for the "kFirstname" value in the request.
*/
static NSString *const kFirstnameKey = @"firstname";

/** @var kLastnameKey
   @brief The key for the "kLastname" value in the request.
*/
static NSString *const kLastnameKey = @"lastname";

/** @var kAgeKey
   @brief The key for the "kAgeKey" value in the request.
*/
static NSString *const kAgeKey = @"age";

/** @var kCityKey
   @brief The key for the "kCityKey" value in the request.
*/
static NSString *const kCityKey = @"city";

/** @var kPhonenumberKey
   @brief The key for the "kPhonenumberKey" value in the request.
*/
static NSString *const kPhonenumberKey = @"phonenumber";

/** @var kPasswordKey
   @brief The key for the "password" value in the request.
*/
static NSString *const kPasswordKey = @"password";

/** @var kDisplayNameKey
    @brief The key for the "kDisplayName" value in the request.
 */
static NSString *const kDisplayNameKey = @"displayName";

/** @var kReturnSecureTokenKey
    @brief The key for the "returnSecureToken" value in the request.
 */
static NSString *const kReturnSecureTokenKey = @"returnSecureToken";

@implementation FIRSignUpNewUserRequest

- (nullable instancetype)initWithEmail:(nullable NSString *)email
                              username:(nullable NSString *)username
                              password:(nullable NSString *)password
                           displayName:(nullable NSString *)displayName
                  requestConfiguration:(FIRAuthRequestConfiguration *)requestConfiguration {
  self = [super initWithEndpoint:kSignupNewUserEndpoint requestConfiguration:requestConfiguration];
  if (self) {
    _email = [email copy];
    _username = [username copy];
    _password = [password copy];
    _displayName = [displayName copy];
    _returnSecureToken = YES;
  }
  return self;
}

- (nullable instancetype)initWithRequestConfiguration:
    (FIRAuthRequestConfiguration *)requestConfiguration {
    self = [self initWithEmail:nil
                      username:nil
                      password:nil
                   displayName:nil
          requestConfiguration:requestConfiguration];
    return self;
}

- (nullable id)unencodedHTTPRequestBodyWithError:(NSError *_Nullable *_Nullable)error {
  NSMutableDictionary *postBody = [NSMutableDictionary dictionary];
  if (_email) {
    postBody[kEmailKey] = _email;
  }
  if(_username){
    postBody[kUsernameKey] = _username;
  }
  if (_password) {
    postBody[kPasswordKey] = _password;
  }
  if (_displayName) {
    postBody[kDisplayNameKey] = _displayName;
  }
  if (_returnSecureToken) {
    postBody[kReturnSecureTokenKey] = @YES;
  }
  return postBody;
}

@end

NS_ASSUME_NONNULL_END
