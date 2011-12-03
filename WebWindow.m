//
//  WebWindow.m
//  BabyBox
//
//  Created by George Shank on 12/1/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import "WebWindow.h"


@implementation WebWindow
@synthesize webView, loadingDialog, delegate;

- ( id )init
{
    if( ( self = [ super initWithWindowNibName: @"WebWindow" ] ) )
    {}
    
    return self;
    
}


-(void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame
{
    NSString *url = [sender mainFrameURL];
    NSRange range = [url rangeOfString:@"?"];
    NSString *subString = [url substringToIndex:NSMaxRange(range)];
    if([subString isEqualToString:@"http://www.google.com/?"])
        [delegate closeWebWindow];
    NSLog(@"%@", [sender mainFrameURL]);
}

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [loadingDialog stopAnimation:self];
}
@end
