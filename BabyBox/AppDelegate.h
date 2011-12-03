//
//  AppDelegate.h
//  BabyBox
//
//  Created by Klint Holmes on 12/1/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "WebWindow.h"
#import "BoxUser.h"

#define apiURL @"http://www.box.net/api/1.0/rest?"
#define ticketAction @"action=get_ticket&api_key=7r4sye4yr5abf36m4km9i80vo9fdm2f4"
#define authAction @"action=get_auth_token&api_key=7r4sye4yr5abf36m4km9i80vo9fdm2f4"

#define redirectURL @"http://www.klintholmes.com"

@interface AppDelegate : NSObject <NSApplicationDelegate, WebWindowDelegate> {
    WebWindow *webWindow;
    BoxUser *user;
    NSTextField *usageText;
    NSProgressIndicator *usage;
    NSTextField *userName;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) WebWindow *webWindow;
@property (nonatomic, retain) BoxUser *user;
@property (nonatomic, retain) IBOutlet NSTextField *userName;
@property (nonatomic, retain) IBOutlet NSTextField *usageText;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *usage;

-(IBAction)signIn:(id)sender;
-(void)closeWebWindow;
-(void)fetchUserInfo;
@end
