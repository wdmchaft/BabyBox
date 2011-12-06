//
//  HTTPRequest.h
//  
//
//  Created by Klint Holmes on 3/9/11.
//  Copyright 2011 Klint Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
   HTTPRequestGetAuth,
   HTTPRequestGetUserInfo
} RequestType;

@protocol HTTPRequestDelegate <NSObject>
@optional
- (void)connectionSuccessful:(BOOL)success request:(id)request;
@end

@interface HTTPRequest : NSObject {
    id <HTTPRequestDelegate> delegate;
	NSMutableData *buffer;
	RequestType type;
}

@property (retain) id delegate;
@property (readwrite) RequestType type;
@property (nonatomic, retain) NSMutableData *buffer;

- (void)startRequest:(NSString *)urlString animated:(BOOL)animated;
- (void)connectionSuccessful:(BOOL)success;

@end