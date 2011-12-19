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
#import "BoxLoginBuilder.h"

#define apiURL @"http://www.box.net/api/1.0/rest?"
#define ticketAction @"action=get_ticket&api_key=7r4sye4yr5abf36m4km9i80vo9fdm2f4"
#define authAction @"action=get_auth_token&api_key=7r4sye4yr5abf36m4km9i80vo9fdm2f4"

#define redirectURL @"http://www.klintholmes.com"

@interface AppDelegate : NSObject <NSApplicationDelegate, WebWindowDelegate, BoxLoginBuilderDelegate> {
    WebWindow *webWindow;
    WebView *web;
    NSTextField *usageText;
    NSProgressIndicator *usage;
    NSTextField *userName;
    
    NSButton *signInButton;
    NSButton *createAccountButton;
    
    BoxUser *user;
    NSString *workingPath;
}

@property (nonatomic, retain) IBOutlet WebView *web;
@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) WebWindow *webWindow;
@property (nonatomic, retain) IBOutlet NSTextField *userName;
@property (nonatomic, retain) IBOutlet NSTextField *usageText;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *usage;

@property (nonatomic, retain) IBOutlet NSButton *signInButton;
@property (nonatomic, retain) IBOutlet NSButton *createAccountButton;

@property (nonatomic, retain) BoxUser *user;
@property (nonatomic, retain) NSString *workingPath;

-(IBAction)signIn:(id)sender;
-(IBAction)createAccount:(id)sender;
-(void)closeWebWindow;
-(void)createBoxFolder;
-(void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
-(void)updateUsage:(BoxUser *)user;
-(void)initialDownload;
-(void)downloadContentsOfFolderId:(NSNumber *)folderId;
@end
