//
//  HTTPRequest.m
//  
//
//  Created by Klint Holmes on 3/9/11.
//  Copyright 2011 KlintHolmes. All rights reserved.
//

#import "HTTPRequest.h"

//Maybe need to add a results array of objects.
//This would require a parser

@implementation HTTPRequest
@synthesize delegate;
@synthesize buffer;
@synthesize type;

- (id)init {
	if (self == [super init]) {
		self.buffer = [[NSMutableData alloc] init];
		self.type = HTTPRequestGetAuth;
	}
	return self;
}

- (void)startRequest:(NSString *)urlString animated:(BOOL)animated {
    NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:25];
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[connection start];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = animated;
}

- (void)startRequest:(NSString *)urlString {
	NSURL *url = [NSURL URLWithString:urlString];
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:25];
	NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[connection start];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[buffer setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[buffer appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	[self connectionSuccessful:YES];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    //if (!self.type == HTTPRequestAdImage) {
        

	/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error:" 
                                                    message:@"Unable to estabish a connection" 
                                                   delegate:self 
                                          cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];*/
	[self connectionSuccessful:NO];
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //}
}

//Notifies delegate that connection is ending sends self for further parsing of data
- (void)connectionSuccessful:(BOOL)success {
    if (success) {
        if([[self delegate] respondsToSelector:@selector(connectionSuccessful:request:)]) {
            [[self delegate] connectionSuccessful:success request:self];
        }
    }
}

@end