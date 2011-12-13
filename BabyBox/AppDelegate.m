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
#import "BoxLoginBuilder.h"
#import "BoxModelUtilityFunctions.h"
//#import "BoxCommonUISetup.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize webWindow, userName, usage, usageText, signInButton, createAccountButton, web;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (void) awakeFromNib {
    
    BoxUser *user = [BoxUser savedUser];
    
    if(user == nil)
    {
        //do nothing
    }
    else
    {
        [userName setStringValue:[user userName]];
        [signInButton setTitle:@"Sign Out"];
        [createAccountButton setHidden:YES];
        
        //Move later
        [BoxUser updateUserInfo:[BoxUser savedUser]];
        
        [self updateUsage:[BoxUser savedUser]9hsGV2L5
         ];
    }
    
}

#pragma mark - Sign in
-(IBAction)signIn:(id)sender
{
    
    if([((NSButton *)sender).title isEqualToString:@"Sign In"])
    {
        self.webWindow = [[WebWindow alloc] init];
        [self.webWindow setDelegate:self];
        [self.webWindow loadWindow];
        [[self.webWindow window] makeKeyAndOrderFront:self];
        //[[self.webWindow loadingDialog] startAnimation:self];
        BoxLoginBuilder *lb = [[BoxLoginBuilder alloc] initWithWebview:self.webWindow.webView delegate:self];
        [lb startLoginProcess];
    }
    else
    {
        //sign out
        [BoxUser clearSavedUser];
        [userName setStringValue:@""];
        [signInButton setTitle:@"Sign In"];
        [createAccountButton setHidden:NO];
        [usageText setHidden:YES];
        [usage setHidden:YES];
    }
}

-(IBAction)createAccount:(id)sender
{
    
}

#pragma mark -
#pragma mark BoxLoginBuilder delegate methods

- (void)loginCompletedWithUser:(BoxUser *)user {
	
	//[BoxCommonUISetup popupAlertWithTitle:@"Login successful" andText:[NSString stringWithFormat:@"You've logged in successfully as %@", user.userName] andDelegate:nil];
    NSLog(@"Heyyy");
	[user save];
    NSLog(@"%@", user);
    [webWindow close];
    [signInButton setTitle:@"Sign Out"];
    [createAccountButton setHidden:YES];
    [userName setStringValue:[user userName]];
    [self updateUsage:user];
	//[_flipViewController.navigationController popViewControllerAnimated:YES];
    
}

- (void)loginFailedWithError:(BoxLoginBuilderResponseType)response {
	
	//[_flipViewController endSpinnerOverlay];
	//[_loginView setHidden:NO];
	
	switch (response) {
		case BoxLoginBuilderResponseTypeFailed:
			//[BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your internet connection and try again" andDelegate:nil];
            NSLog(@"Meow");
			break;
			/*
             case BoxLoginLogoutErrorTypeConnectionError:
             [BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your internet connection and try again" andDelegate:nil];
             break;
             case BoxLoginLogoutErrorTypePasswordOrLoginError:
             [BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your username and password and try again" andDelegate:nil];
             break;
             case BoxLoginLogoutErrorTypeDeveloperAccountError:
             [BoxCommonUISetup popupAlertWithTitle:@"Unable to login" andText:@"Please check your box.net developer account credentials. Either the application key is invalid or it does not have permission to call the direct-login method. Please contact developers@box.net" andDelegate:nil];
             break;*/
		default:
            NSLog(@"baaaaad");
			break;
	}
    
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
        //Open sign in webpage
        [webWindow.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.box.net/api/1.0/auth/%@", ticket]]]];
        //[[webWindow loadingDialog] stopAnimation:self];
    }
    else if([status isEqualToString:@"get_auth_token_ok"])
    {
        NSString *authToken = [[NSString alloc] initWithString:[[[dic objectForKey:@"response"]objectForKey:@"auth_token"] objectForKey:@"text"]];
        NSString *username = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"login"] objectForKey:@"text"]];
        NSString *email = [[NSString alloc] initWithString:[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"email"] objectForKey:@"text"]];
        NSNumber *accessID = [NSNumber numberWithInt:[[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"access_id"] objectForKey:@"text"] intValue]];
        NSNumber *userID = [NSNumber numberWithInt:[[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"user_id"] objectForKey:@"text"] intValue]];
        NSNumber *quota = [NSNumber numberWithInt:[[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"space_amount"] objectForKey:@"text"]intValue]];
        NSNumber *storageUsed = [NSNumber numberWithInt:[[[[[dic objectForKey:@"response"]objectForKey:@"user"] objectForKey:@"space_used"] objectForKey:@"text"] intValue]];

                
       /* [self.user setAuthToken:authToken];
        [self.user setUserName:username];
        [self.user setEmail:email];
        [self.user setAccessId:accessID];
        [self.user setUserId:userID];
        [self.user setStorageQuota:quota];
        [self.user setStorageUsed:storageUsed];
        //[self.user setMaxUploadSize:[NSNumber numberWithDouble:[maxUploadSize doubleValue]]];
        
        /*[[NSUserDefaults standardUserDefaults] setValue:self.user.userID forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.login forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.email forKey:@"email"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.spaceUsed forKey:@"spaceUsed"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.spaceAmount forKey:@"spaceAmount"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.accessID forKey:@"accessID"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.ticket forKey:@"ticket"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.maxUploadSize forKey:@"maxUploadSize"];
        [[NSUserDefaults standardUserDefaults] setValue:self.user.authToken forKey:@"authToken"];*/
        
        //[self.userName setStringValue:[user userName]];        
        
//        NSString *measure = @"GB";
//        long base;
//        if ([user.spaceUsed longValue] <= 1024) {
//            base = 1;
//            measure = @"B";
//        } else if ([user.spaceUsed longValue] > 1024 &&  [user.spaceUsed longValue] <= 1024*1024) {
//            base = 1024;
//            measure = @"KB";
//        } else if ([user.spaceUsed longValue] > 1024*1024 &&  [user.spaceUsed longValue] <= 1024*1024*1024) {
//            base = 1024*1024;
//            measure = @"MB";
//        } else {
//            base = 1024*1024*1024;
//            measure = @"GB";
//        }
//        [usage setMaxValue:[[user spaceAmount] doubleValue]];
//        [usage setDoubleValue:[[user spaceUsed] doubleValue]];
//        NSLog(@"%ld", [user.spaceAmount longValue] / (1048576*1024));
//        usageText.stringValue = [NSString stringWithFormat:@"%ld %@ of %ld GB", [user.spaceUsed longValue] / base, measure, [user.spaceAmount longValue] / (1048576*1024)];*/
        
        [signInButton setTitle:@"Sign Out"];
    
        [createAccountButton setHidden:YES];
        [self createBoxFolder];
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
    /*NSString *urlRequest = [[NSString alloc] initWithFormat:@"%@%@&ticket=%@",apiURL, authAction, self.user.ticket];*/
    /*NSLog(@"%@", urlRequest);
    HTTPRequest *request = [[HTTPRequest alloc] init];
    [request setDelegate:self];
    [request startRequest:urlRequest animated:YES];
    [request release];*/
}

-(void)createBoxFolder
{
    NSString *path = [[NSString alloc] initWithString:@"~/Box/"];
    path = [path stringByExpandingTildeInPath];
    BOOL isDir;
    
    NSLog(@"%@", path);
                      
    NSFileManager *fileManager= [NSFileManager defaultManager]; 
        
    if([fileManager fileExistsAtPath:path isDirectory:&isDir])
    {
        NSLog(@"The folder exists!");
    }
    else
    {
       NSAlert *alert = [NSAlert alertWithMessageText:@"Do You Want Folder?" defaultButton:@"Jess" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@"Hey Bro"];
       // NSInteger *done = [alert runModal];
        [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
        /*if ([alert runModal] == NSAlertDefaultReturn) {
            if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL])
                
                NSLog(@"Error: Create folder failed %@", path);
        } else {
            NSLog(@"You no want box");
        }*/
               
    }
      
//  if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:NULL])
//  NSLog(@"Error: Create folder failed %@", directory);
}

-(void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertDefaultReturn) {
        NSString *path = [[NSString alloc] initWithString:@"~/Box/"];
        path = [path stringByExpandingTildeInPath];
        //BOOL isDir;
        
        NSLog(@"%@", path);
        
        NSFileManager *fileManager= [NSFileManager defaultManager]; 
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL])
            
            NSLog(@"Error: Create folder failed %@", path);
    } else {
        NSLog(@"You no want box");
    }
}
    
#pragma mark - Storage Usage Functions

-(void) updateUsage:(BoxUser *)user
{
    NSString *spaceUsed = [BoxModelUtilityFunctions getFileFolderSizeString:[user storageUsed]];
    NSString *spaceQuota = [BoxModelUtilityFunctions getFileFolderSizeString:[user storageQuota]];
    
    [usageText setStringValue:[NSString stringWithFormat:@"%@ of %@", spaceUsed, spaceQuota]];
    [usage setMaxValue:[[user storageQuota] doubleValue]];
    [usage setDoubleValue:[[user storageUsed] doubleValue]];

} 

@end
