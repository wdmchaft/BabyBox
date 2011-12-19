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
#import "BoxFolder.h"
#import "BoxFolderXMLBuilder.h"
#import "BoxDownloadOperation.h"
#import "ProgressView.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize webWindow, userName, usage, usageText, signInButton, createAccountButton, web, user, workingPath, downloadQueue, progressViewHolder;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application

}

- (void) awakeFromNib {
    self.downloadQueue = [[NSOperationQueue alloc] init];
    [self.downloadQueue setMaxConcurrentOperationCount:3];
    self.user = [BoxUser savedUser];//[[BoxUser alloc] init];
    self.workingPath = [[NSString alloc] initWithString:@"~/Box/"];
    self.workingPath = [self.workingPath stringByExpandingTildeInPath];
    
    if(![self.user loggedIn]) {
        //do nothing
    } else {
        [userName setStringValue:[user userName]];
        [signInButton setTitle:@"Sign Out"];
        [createAccountButton setHidden:YES];
        
        //Move later
        [BoxUser updateUserInfo:[user authToken] updateDelegate:self];
        //[self getFolderList];
        
    }
    
}

-(void)operation:(BoxOperation *)opp willBeginForPath:(NSString *)path{
    NSLog(@"Your mom just ate a plate of pancakes");
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
    [self createBoxFolder];
    
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

/*-(void)connectionSuccessful:(BOOL)success request:(id)request
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
        [[NSUserDefaults standardUserDefaults] setValue:self.user.authToken forKey:@"authToken"];
        
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
//        usageText.stringValue = [NSString stringWithFormat:@"%ld %@ of %ld GB", [user.spaceUsed longValue] / base, measure, [user.spaceAmount longValue] / (1048576*1024)];
        
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
}*/

#pragma mark - Downloading/Syncing of files from cloud

-(void)getFolderList {
    BoxUser * userModel = [BoxUser savedUser];

	NSString * ticket = userModel.authToken;
	// Step 2a
	NSNumber * folderIdToDownload = [NSNumber numberWithInt:0];
	// Step 2b
	BoxFolderDownloadResponseType responseType = 0;
	BoxFolder * folderModel = [BoxFolderXMLBuilder folderForId:folderIdToDownload token:ticket responsePointer:&responseType basePathOrNil:nil];
	// Step 2c
	if(responseType == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
		//Step 2d
		NSLog(@"%@", [folderModel objectToString]);
	}
    NSLog(@"%d", [folderModel numberOfObjectsInFolder]);
    
//    BoxDownloadOperation *op =  [BoxDownloadOperation operationForFileID:[[[folderModel getModelAtIndex:0] objectId] intValue] toPath:[NSString stringWithFormat:@"/Users/georgeshank/Desktop/%@", [[folderModel getModelAtIndex:0] objectName]] authToken:ticket delegate:self];
//    //NSLog(@"%@", [op ]);
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:op];
        
    
}


-(void)downloadContentsOfFolderId:(NSNumber *)folderId{
	NSString * ticket = self.user.authToken;
	// Step 2a

	BoxFolderDownloadResponseType responseType = 0;
	BoxFolder * folderModel = [BoxFolderXMLBuilder folderForId:folderId token:ticket responsePointer:&responseType basePathOrNil:nil];
	// Step 2c
	if(responseType == boxFolderDownloadResponseTypeFolderSuccessfullyRetrieved) {
		//Step 2d
		NSLog(@"%@", [folderModel objectToString]);
	}
    NSLog(@"%d", [folderModel numberOfObjectsInFolder]);
  
    
    for(BoxObject *object in [folderModel objectsInFolder])
    {
        if([object respondsToSelector:@selector(numberOfObjectsInFolder)])
        {
            //It's a folder. Download its contents
            NSString *previousPath = [[NSString alloc] initWithString:self.workingPath];
            self.workingPath = [NSString stringWithFormat:@"%@/%@", previousPath, [object objectName]];
            NSLog(@"%@", self.workingPath);
            NSFileManager *fileManager= [NSFileManager defaultManager]; 
            if(![fileManager createDirectoryAtPath:self.workingPath withIntermediateDirectories:YES attributes:nil error:NULL])
                NSLog(@"Error: Create folder failed %@", self.workingPath);
            else
            {
                //download contents of Box folder locally
                [self downloadContentsOfFolderId:[object objectId]];
            }
            //[workingPath release];
            self.workingPath = previousPath;
        }
        else
        {
//            BoxDownloadOperation *op =  [BoxDownloadOperation operationForFileID:[[object objectId] intValue] toPath:[NSString stringWithFormat:@"%@/%@", self.workingPath, [object objectName]] authToken:ticket delegate:self];
//            //NSLog(@"%@", [op ]);
//            [downloadQueue addOperation:op];
            
            ProgressView *tmp = [[ProgressView alloc] init];
            
            
            [progressViewHolder addSubview:tmp];

        }

    }
}

//- (void)operation:(BoxOperation *)op didProgressForPath:(NSString *)path ratio:(NSNumber *)ratio
//{
//    //Do nothing
//}
//- (void)operation:(BoxOperation *)op didProgressForPath:(NSString *)path completionRatio:(NSNumber *)ratio
//{
//    NSLog(@"Ya'll want some progress? %@: %@", path, ratio);
//}

//-(void)operation:(BoxOperation *)op didCompleteForPath:(NSString *)path response:(BoxOperationResponse)response {
//    //NSLog(@"%@", response);
//    //NSLog(@"%@", [op response]);
//    NSLog(@"%d", response);
//    NSLog(@"%@", [op summary]);
//    NSLog(@"Your mom finnished that pancakes bra");
//}


#pragma mark - Finishing Authentication
-(void) closeWebWindow
{
    [webWindow close];
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
       NSAlert *alert = [NSAlert alertWithMessageText:@"You do not currently have a Box folder. Would you like to create one?" defaultButton:@"Yes" alternateButton:@"No" otherButton:nil informativeTextWithFormat:@"To sync files from your Box account to your computer, you will need a local Box folder."];
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
        //BOOL isDir;
        
        NSLog(@"%@", self.workingPath);
        
        NSFileManager *fileManager= [NSFileManager defaultManager]; 
        if(![fileManager createDirectoryAtPath:self.workingPath withIntermediateDirectories:YES attributes:nil error:NULL])
            NSLog(@"Error: Create folder failed %@", self.workingPath);
        else
        {
            //download contents of Box folder locally
            [self downloadContentsOfFolderId:[NSNumber numberWithInt:0]];    
        }
    } else {
        NSLog(@"You no want box");
    }
}
    
#pragma mark - Storage Usage Functions

-(void) updateUsage:(BoxUser *)user
{
    [self setUser:user];
    
    NSString *spaceUsed = [BoxModelUtilityFunctions getFileFolderSizeString:[user storageUsed]];
    NSString *spaceQuota = [BoxModelUtilityFunctions getFileFolderSizeString:[user storageQuota]];
    
    [usageText setStringValue:[NSString stringWithFormat:@"%@ of %@", spaceUsed, spaceQuota]];
    [usage setMaxValue:[[user storageQuota] doubleValue]];
    [usage setDoubleValue:[[user storageUsed] doubleValue]];
} 

@end
