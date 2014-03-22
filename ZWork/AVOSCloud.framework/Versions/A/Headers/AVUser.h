// AVUser.h
// Copyright 2013 AVOS, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "AVConstants.h"
#import "AVObject.h"


@class AVQuery;

/*!
A AVOS Cloud Framework User Object that is a local representation of a user persisted to the AVOS Cloud. This class
 is a subclass of a AVObject, and retains the same functionality of a AVObject, but also extends it with various
 user specific methods, like authentication, signing up, and validation uniqueness.
 
 Many APIs responsible for linking a AVUser with Facebook or Twitter have been deprecated in favor of dedicated
 utilities for each social network. See AVFacebookUtils and AVTwitterUtils for more information.
 */


@interface AVUser : AVObject

/** @name Accessing the Current User */

/*!
 Gets the currently logged in user from disk and returns an instance of it.
 @return a AVUser that is the currently logged in user. If there is none, returns nil.
 */
+ (instancetype)currentUser;

/// The session token for the AVUser. This is set by the server upon successful authentication.
@property (nonatomic, retain) NSString *sessionToken;

/// Whether the AVUser was just created from a request. This is only set after a Facebook or Twitter login.
@property (readonly, assign) BOOL isNew;

/*!
 Whether the user is an authenticated object for the device. An authenticated AVUser is one that is obtained via
 a signUp or logIn method. An authenticated object is required in order to save (with altered values) or delete it.
 @return whether the user is authenticated.
 */
- (BOOL)isAuthenticated;

/** @name Creating a New User */

/*!
 Creates a new AVUser object.
 @return a new AVUser object.
 */
+ (instancetype)user;

/*!
 Enables automatic creation of anonymous users.  After calling this method, [AVUser currentUser] will always have a value.
 The user will only be created on the server once the user has been saved, or once an object with a relation to that user or
 an ACL that refers to the user has been saved.
 
 Note: saveEventually will not work if an item being saved has a relation to an automatic user that has never been saved.
 */
+ (void)enableAutomaticUser;

/// The username for the AVUser.
@property (nonatomic, retain) NSString *username;

/** 
 The password for the AVUser. This will not be filled in from the server with
 the password. It is only meant to be set.
 */
@property (nonatomic, retain) NSString *password;

/// The email for the AVUser.
@property (nonatomic, retain) NSString *email;


/**
 *  请求重发验证邮件
 *  如果用户邮箱没有得到验证或者用户修改了邮箱, 通过本方法重新发送验证邮件.
 *  
 *  @warning 为防止滥用,同一个邮件地址，1分钟内只能发1次!
 *
 *  @param email 邮件地址
 *  @param block 回调结果
 */
+(void)requestEmailVerify:(NSString*)email withBlock:(AVBooleanResultBlock)block;

/*!
 Signs up the user. Make sure that password and username are set. This will also enforce that the username isn't already taken. 
 @return true if the sign up was successful.
 */
- (BOOL)signUp;

/*!
 Signs up the user. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 @param error Error object to set on error. 
 @return whether the sign up was successful.
 */
- (BOOL)signUp:(NSError **)error;

/*!
 Signs up the user asynchronously. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 */
- (void)signUpInBackground;

/*!
 Signs up the user asynchronously. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error) 
 */
- (void)signUpInBackgroundWithBlock:(AVBooleanResultBlock)block;

/*!
 Signs up the user asynchronously. Make sure that password and username are set. This will also enforce that the username isn't already taken.
 @param target Target object for the selector.
 @param selector The selector that will be called when the asynchrounous request is complete. It should have the following signature: `(void)callbackWithResult:(NSNumber *)result error:(NSError **)error`. error will be nil on success and set if there was an error. `[result boolValue]` will tell you whether the call succeeded or not.
 */
- (void)signUpInBackgroundWithTarget:(id)target selector:(SEL)selector;

/** @name Logging in */

/*!
 Makes a request to login a user with specified credentials. Returns an instance
 of the successfully logged in AVUser. This will also cache the user locally so 
 that calls to userFromCurrentUser will use the latest logged in user.
 @param username The username of the user.
 @param password The password of the user.
 @return an instance of the AVUser on success. If login failed for either wrong password or wrong username, returns nil.
 */
+ (instancetype)logInWithUsername:(NSString *)username
                     password:(NSString *)password;

/*!
 Makes a request to login a user with specified credentials. Returns an
 instance of the successfully logged in AVUser. This will also cache the user 
 locally so that calls to userFromCurrentUser will use the latest logged in user.
 @param username The username of the user.
 @param password The password of the user.
 @param error The error object to set on error.
 @return an instance of the AVUser on success. If login failed for either wrong password or wrong username, returns nil.
 */
+ (instancetype)logInWithUsername:(NSString *)username
                     password:(NSString *)password
                        error:(NSError **)error;

/*!
 Makes an asynchronous request to login a user with specified credentials.
 Returns an instance of the successfully logged in AVUser. This will also cache 
 the user locally so that calls to userFromCurrentUser will use the latest logged in user.
 @param username The username of the user.
 @param password The password of the user.
 */
+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password;

/*!
 Makes an asynchronous request to login a user with specified credentials.
 Returns an instance of the successfully logged in AVUser. This will also cache 
 the user locally so that calls to userFromCurrentUser will use the latest logged in user. 
 The selector for the callback should look like: myCallback:(AVUser *)user error:(NSError **)error
 @param username The username of the user.
 @param password The password of the user.
 @param target Target object for the selector.
 @param selector The selector that will be called when the asynchrounous request is complete.
 */
+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                               target:(id)target
                             selector:(SEL)selector;

/*!
 Makes an asynchronous request to log in a user with specified credentials.
 Returns an instance of the successfully logged in AVUser. This will also cache 
 the user locally so that calls to userFromCurrentUser will use the latest logged in user. 
 @param username The username of the user.
 @param password The password of the user.
 @param block The block to execute. The block should have the following argument signature: (AVUser *user, NSError *error) 
 */
+ (void)logInWithUsernameInBackground:(NSString *)username
                             password:(NSString *)password
                                block:(AVUserResultBlock)block;

/** @name Logging Out */

/*!
 Logs out the currently logged in user on disk.
 */
+ (void)logOut;

/** @name Requesting a Password Reset */

/*!
 Send a password reset request for a specified email. If a user account exists with that email,
 an email will be sent to that address with instructions on how to reset their password.
 @param email Email of the account to send a reset password request.
 @return true if the reset email request is successful. False if no account was found for the email address.
 */
+ (BOOL)requestPasswordResetForEmail:(NSString *)email;

/*!
 Send a password reset request for a specified email and sets an error object. If a user
 account exists with that email, an email will be sent to that address with instructions 
 on how to reset their password.
 @param email Email of the account to send a reset password request.
 @param error Error object to set on error.
 @return true if the reset email request is successful. False if no account was found for the email address.
 */
+ (BOOL)requestPasswordResetForEmail:(NSString *)email
                               error:(NSError **)error;

/*!
 Send a password reset request asynchronously for a specified email and sets an
 error object. If a user account exists with that email, an email will be sent to 
 that address with instructions on how to reset their password.
 @param email Email of the account to send a reset password request.
 */
+ (void)requestPasswordResetForEmailInBackground:(NSString *)email;

/*!
 Send a password reset request asynchronously for a specified email and sets an error object.
 If a user account exists with that email, an email will be sent to that address with instructions
 on how to reset their password.
 @param email Email of the account to send a reset password request.
 @param target Target object for the selector.
 @param selector The selector that will be called when the asynchronous request is complete. It should have the following signature: (void)callbackWithResult:(NSNumber *)result error:(NSError **)error. error will be nil on success and set if there was an error. [result boolValue] will tell you whether the call succeeded or not.
 */
+ (void)requestPasswordResetForEmailInBackground:(NSString *)email
                                          target:(id)target
                                        selector:(SEL)selector;

/*!
 Send a password reset request asynchronously for a specified email.
 If a user account exists with that email, an email will be sent to that address with instructions
 on how to reset their password.
 @param email Email of the account to send a reset password request.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error) 
 */
+ (void)requestPasswordResetForEmailInBackground:(NSString *)email
                                           block:(AVBooleanResultBlock)block;

/** @name Querying for Users */

/*!
 Creates a query for AVUser objects.
 */
+ (AVQuery *)query;


@end
