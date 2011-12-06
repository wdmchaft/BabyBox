//
//  BoxUser.m
//  BabyBox
//
//  Created by George Shank on 12/2/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import "BoxUser.h"

@implementation BoxUser
@synthesize userID, login, email, spaceLeft, spaceUsed, spaceAmount, accessID, ticket, maxUploadSize, authToken;

-(void)setWithDefaults {
    self.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    self.login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    self.email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
    self.spaceUsed = [[NSUserDefaults standardUserDefaults] objectForKey:@"spaceUsed"];
    self.spaceAmount =[[NSUserDefaults standardUserDefaults] objectForKey:@"spaceAmount"];
    self.accessID = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessID"];
    self.ticket = [[NSUserDefaults standardUserDefaults] objectForKey:@"ticket"];
    self.maxUploadSize = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxUploadSize"];
    self.authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
}

-(void)calculateSpaceLeft
{
    //Calculate space left
}
@end
