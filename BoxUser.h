//
//  BoxUser.h
//  BabyBox
//
//  Created by George Shank on 12/2/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxUser : NSObject
{
    NSString *authToken;
    NSString *login;
    NSString *email;
    NSString *userID;
    NSString *accessID;
    NSNumber *spaceAmount;
    NSNumber *spaceUsed;
    NSNumber *spaceLeft;
    NSNumber *maxUploadSize;
    
    NSString *ticket;
}

@property (nonatomic, retain) NSString *authToken;
@property (nonatomic, retain) NSString *login;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *accessID;
@property (nonatomic, retain) NSNumber *spaceAmount;
@property (nonatomic, retain) NSNumber *spaceUsed;
@property (nonatomic, retain) NSNumber *spaceLeft;
@property (nonatomic, retain) NSNumber *maxUploadSize;

@property (nonatomic, retain) NSString *ticket;

-(void)setWithDefaults;
-(void)calculateSpaceLeft;

@end
