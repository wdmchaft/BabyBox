//
//  WebWindow.h
//  BabyBox
//
//  Created by George Shank on 12/1/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@protocol WebWindowDelegate
@required
-(void)closeWebWindow;
@end
@interface WebWindow : NSWindowController{
    WebView *webView;
    NSProgressIndicator *loadingDialog;
    
    id <WebWindowDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet WebView *webView;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *loadingDialog;
@property (retain) id <WebWindowDelegate> delegate;

-(void)stopLoadingDialog;
-(void)startLoadingDialog;
@end
