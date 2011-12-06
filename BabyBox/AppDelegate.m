//
//  AppDelegate.m
//  BabyBox
//
//  Created by Klint Holmes on 12/1/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import "AppDelegate.h"
#import "HTTPRequest.h"
#import "XMLReader.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize webWindow, user, userName, usage, usageText;
- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) awakeFromNib {
    user = [[BoxUser alloc] init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"]) {
        [user setWithDefaults];
        [self fetchUserInfo];
    }
}

#pragma mark - Sign in
-(IBAction)signIn:(id)sender
{
    self.user = [[BoxUser alloc] init];
    
    self.webWindow = [[WebWindow alloc] init];
    [self.webWindow setDelegate:self];
    [self.webWindow loadWindow];
    [[self.webWindow window] makeKeyAndOrderFront:self];
    [[self.webWindow loadingDialog] startAnimation:self];
    //Sign user into Box.net
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:[NSString stringWithFormat:@"%@%@",apiURL, ticketAction] animated:YES];
    [request release];    
}

#pragma mark - HTTPRequest Delegate Methods

-(void)connectionSuccessful:(BOOL)success request:(id)request
{
    HTTPRequest *result = (HTTPRequest *)request;
    NSError *error;
    NSDictionary *dic = [XMLReader dictionaryForXMLData:result.buffer error:&error];
    NSLog(@"%@", dic);
    
    NSString *status = [[NSString alloc] initWithString:[[[dic objectForKey:@"response"] objectForKey:@"status"] objectForKey:@"text"]];
    
    
    
    //If the ticket came back good
    if([status isEqualToString:@"get_ticket_ok"])
    {
        NSString *ticket = [[NSString alloc] initWithString:[[[dic objectForKey:@"response"] objectForKey:@"ticket"] objectForKey:@"text"]];
        
        [self.user setTicket:ticket];
        //Open sign in webpage
        [webWindow.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.box.net/api/1.0/auth/%@", ticket]]]];
        //[[webWindow loadingDialog] stopAnimation:self];
    }
    else if([status isEqualToString:@"get_auth_token_ok"])
    {
        NSString *authToken = [[NSString alloc] initWithString:[[[dic objectForKey:@"response"]objectForKey:@"auth_token"] objectForKey:@"text"]];
        NSString *login = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"login"] objectForKey:@"text"]];
        NSString *email = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"email"] objectForKey:@"text"]];
        NSString *accessID = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"access_id"] objectForKey:@"text"]];
        NSString *userID = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"user_id"] objectForKey:@"text"]];
        NSString *spaceAmount = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"space_amount"] objectForKey:@"text"]];
        NSString *spaceUsed = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"space_used"] objectForKey:@"text"]];
        NSString *maxUploadSize = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"max_upload_size"] objectForKey:@"text"]];
                
        [self.user setAuthToken:authToken];
        [self.user setLogin:login];
        [self.user setEmail:email];
        [self.user setAccessID:accessID];
        [self.user setUserID:userID];
        [self.user setSpaceAmount:[NSNumber numberWithDouble:[spaceAmount doubleValue]]];
        [self.user setSpaceUsed:[NSNumber numberWithDouble:[spaceUsed doubleValue]]];
        [self.user setMaxUploadSize:[NSNumber numberWithDouble:[maxUploadSize doubleValue]]];
        
        [[NSUserDefaults standardUserDefaults] setValue:self.user.userID forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.login forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.email forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.spaceUsed forKey:@"spaceUsed"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.spaceAmount forKey:@"spaceAmount"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.accessID forKey:@"accessID"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.ticket forKey:@"ticket"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.maxUploadSize forKey:@"maxUploadSize"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.authToken forKey:@"authToken"];
        
        [self.userName setStringValue:[user login]];        
        NSString *measure = @"GB";
        long base;
        if ([user.spaceUsed longValue] <= 1024) {
            base = 1;
            measure = @"B";
        } else if ([user.spaceUsed longValue] > 1024 &&  [user.spaceUsed longValue] <= 1024*1024) {
            base = 1024;
            measure = @"KB";
        } else if ([user.spaceUsed longValue] > 1024*1024 &&  [user.spaceUsed longValue] <= 1024*1024*1024) {
            base = 1024*1024;
            measure = @"MB";
        } else {
            base = 1024*1024*1024;
            measure = @"GB";
        }
        [usage setMaxValue:[[user spaceAmount] doubleValue]];
        [usage setDoubleValue:[[user spaceUsed] doubleValue]];
        NSLog(@"%ld", [user.spaceAmount longValue] / (1048576*1024));
        usageText.stringValue = [NSString stringWithFormat:@"%ld %@ of %ld GB", [user.spaceUsed longValue] / base, measure, [user.spaceAmount longValue] / (1048576*1024)];
    }
    else
    {
        NSLog(@"That ticket was baaaaad!");
    }
//    [result release];
//    [resultString release];
}

#pragma mark - Finishing Authentication
-(void) closeWebWindow
{
    [webWindow close];
    [self fetchUserInfo];
}

-(void) fetchUserInfo
{
    NSString *urlRequest = [[NSString alloc] initWithFormat:@"%@%@&ticket=%@",apiURL, authAction, self.user.ticket];
    NSLog(@"%@", urlRequest);
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:urlRequest animated:YES];
    [request release];
}

@end
