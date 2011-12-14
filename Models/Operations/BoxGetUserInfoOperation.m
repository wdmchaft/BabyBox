
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

#import "BoxGetUserInfoOperation.h"
#import "BoxUser.h"
#import "AppDelegate.h"

@implementation BoxGetUserInfoOperation

@synthesize user = _user;
@synthesize token = _token;

+ (BoxGetUserInfoOperation *)operationWithAuthToken:(NSString *)authToken
										 delegate:(id<BoxOperationDelegate>)delegate
{
	return [[[BoxGetUserInfoOperation alloc] initWithAuthToken:authToken delegate:delegate] autorelease];
}

- (id)initWithAuthToken:(NSString *)authToken
			delegate:(id<BoxOperationDelegate>)delegate
{
	if ((self = [super initForType:BoxOperationSimpleHTTPRequest delegate:delegate])) {
		self.user = nil;
		self.token = authToken;
        self.delegate = delegate;
	}
    
	return self;
}

- (void)dealloc {
	self.user = nil;
	self.token = nil;
    
	[super dealloc];
}

- (NSURL *)url {
	return [NSURL URLWithString:[BoxRESTApiFactory getUserInfo:self.token]];
}

- (NSArray *)resultKeysOfInterest {
	return [NSArray arrayWithObjects:@"status", @"user", nil];
}

- (NSString *)successCode {
	return @"get_account_info_ok";
}

- (void)processResult:(NSDictionary *)result {
	if ([[result objectForKey:@"status"] isEqual:[self successCode]]) {
		NSDictionary *userInfo = [result objectForKey:@"user"];
		self.user = [BoxUser userWithAttributes:userInfo];
        [(AppDelegate *)self.delegate updateUsage:self.user];
    }
    
	[super processResult:result];
}

//- (NSURL *)authenticationURL {
//	if (!self.ticket) {
//		return nil;
//	}
//    
//	return [NSURL URLWithString:[BoxRESTApiFactory authenticationUrlStringForTicket:self.ticket]];
//}

@end
