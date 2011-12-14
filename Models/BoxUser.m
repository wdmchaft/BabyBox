
//
// Copyright 2011 Box.net, Inc.
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//

#import "BoxUser.h"
#import "BoxGetUserInfoOperation.h"

@interface BoxUser()

- (BOOL)saveDictionary:(NSDictionary *)info;
- (void)loadFromDictionary:(NSDictionary *)info;

@end

@implementation BoxUser

@synthesize authToken = _authToken;

@synthesize userName = _userName;
@synthesize email = _email;

@synthesize accessId = _accessId;
@synthesize userId = _userId;

@synthesize maxUploadSize = _maxUploadSize;
@synthesize storageQuota = _storageQuota;
@synthesize storageUsed = _storageUsed;

//#define BOX_USER_MODEL_ACCOUNT_PLIST @"/Documents/boxNetSavedAccountInfo.plist"
#define BOX_USER_MODEL_ACCOUNT_PLIST @"BoxUser.plist"

#pragma mark Initialization

+ (BoxUser *)userWithAttributes:(NSDictionary *)attributes {
	BoxUser *user;
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //NSLog(@"%@", attributes);
	user = [[BoxUser alloc] init];
	user.userName = [attributes objectForKey:@"login"];
	user.email = [attributes objectForKey:@"email"];
	user.userId = [numberFormatter numberFromString:[attributes objectForKey:@"user_id"]];
	user.accessId = [numberFormatter numberFromString:[attributes objectForKey:@"access_id"]];
	user.authToken = [attributes objectForKey:@"auth_token"];
	user.storageQuota = [numberFormatter numberFromString:[attributes objectForKey:@"space_amount"]];
	user.storageUsed = [numberFormatter numberFromString:[attributes objectForKey:@"space_used"]];
	user.maxUploadSize = [numberFormatter numberFromString:[attributes objectForKey:@"max_upload_size"]];
	return user;//[user autorelease];
}

+(void)updateUserInfo:(NSString *)authToken updateDelegate:(id)delegate {
    BoxGetUserInfoOperation *opt = [[BoxGetUserInfoOperation alloc] initWithAuthToken:authToken delegate:delegate];
    [opt start];
}

#pragma mark -
#pragma mark Saving and Loading from Disk

+ (BoxUser *)savedUser {
	BoxUser *user = [[BoxUser alloc] init];
	BOOL success = [user loadFromDisk];
	
	if (!success) {
		[user release];
		user = nil;
	}

	return user;
}

+ (BOOL)clearSavedUser {
	BoxUser *user = [[BoxUser alloc] init];
	[user clear];
	BOOL success = [user save];
	[user release];

	return success;
}

- (BOOL)save {
    //	return [self saveDictionary:[self attributesDictionary]];
    [[NSUserDefaults standardUserDefaults] setValue:[self.userId stringValue] forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userName forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] setValue:self.email forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] setValue:[self.storageUsed stringValue] forKey:@"storageUsed"];
    [[NSUserDefaults standardUserDefaults] setValue:[self.storageQuota stringValue] forKey:@"storageQuota"];
    [[NSUserDefaults standardUserDefaults] setValue:[self.accessId stringValue] forKey:@"accessId"];
    [[NSUserDefaults standardUserDefaults] setValue:[self.maxUploadSize stringValue] forKey:@"maxUploadSize"];
    [[NSUserDefaults standardUserDefaults] setValue:self.authToken forKey:@"authToken"];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    return YES;
}

- (void)clear {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storageUsed"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storageQuota"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"accessId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"maxUploadSize"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authToken"];
}

- (BOOL)loadFromDisk {
    NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    self.userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    self.email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    self.userId = [numberFormatter numberFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    self.accessId = [numberFormatter numberFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessId"]];
    self.storageQuota = [numberFormatter numberFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"storageQuota"]];
    self.storageUsed = [numberFormatter numberFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"storageUsed"]];
    self.maxUploadSize = [numberFormatter numberFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"maxUploadSize"]];
    return YES;
}

#pragma mark -
#pragma mark User attributes

- (NSDictionary *)attributesDictionary {
	NSArray *keys = [self attributeNames];
	NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:[keys count]];
	
	for (NSString *key in keys) {
		id result = [self performSelector:NSSelectorFromString(key)];
		if (result) {
			[info setObject:result forKey:key];
		}
	}

	return info;
}

- (NSArray *)attributeNames {
	return [NSArray arrayWithObjects:
			@"authToken",
			@"userName",
			@"email",
			@"accessId",
			@"userId",
			@"maxUploadSize",
			@"storageQuota",
			@"storageUsed",
			nil];
}

- (BOOL)loggedIn {
	if(_authToken == nil || 
	   [_authToken compare:@""] == NSOrderedSame || 
	   _userName == nil || 
	   [_userName compare:@""] == NSOrderedSame) {
		return  NO;
	}

	return YES;
}

#pragma mark -
#pragma mark Helper functions

- (BOOL)saveDictionary:(NSDictionary *)info {
	NSString *fileLocation = [NSHomeDirectory() stringByAppendingPathComponent: BOX_USER_MODEL_ACCOUNT_PLIST];
	NSString *pList = [info description];
	NSError * error = nil;
	BOOL success = [pList writeToFile:fileLocation
						   atomically:YES
							 encoding:NSUTF8StringEncoding
								error:&error];

	if (error) {
		NSLog(@"Error: %@ -- %@", 
			  [error localizedDescription], [error localizedFailureReason]);
	}

	return success;
}

- (void)loadFromDictionary:(NSDictionary *)info {
	NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

	self.userName = [info objectForKey:@"userName"];
	self.email = [info objectForKey:@"email"];
	self.userId = [numberFormatter numberFromString:[info objectForKey:@"userId"]];
	self.accessId = [numberFormatter numberFromString:[info objectForKey:@"accessId"]];
	self.authToken = [info objectForKey:@"authToken"];
	self.storageQuota = [numberFormatter numberFromString:[info objectForKey:@"storageQuota"]];
	self.storageUsed = [numberFormatter numberFromString:[info objectForKey:@"storageUsed"]];
	self.maxUploadSize = [numberFormatter numberFromString:[info objectForKey:@"maxUploadSize"]];
}

-(NSString *)description {
    return [NSString stringWithFormat:@"User: %@ Token: %@",self.userName, self.authToken];
}
@end
