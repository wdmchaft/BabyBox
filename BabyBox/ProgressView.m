//
//  ProgressView.m
//  BabyBox
//
//  Created by George Shank on 12/19/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import "ProgressView.h"
#import "BoxOperation.h"

@implementation ProgressView
@synthesize progressBar, fileName;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)operation:(BoxOperation *)op didProgressForPath:(NSString *)path ratio:(NSNumber *)ratio
{
    //Do nothing
}
- (void)operation:(BoxOperation *)op didProgressForPath:(NSString *)path completionRatio:(NSNumber *)ratio
{
    NSLog(@"Ya'll want some progress? %@: %@", path, ratio);
}

-(void)operation:(BoxOperation *)op didCompleteForPath:(NSString *)path response:(BoxOperationResponse)response {
    //NSLog(@"%@", response);
    //NSLog(@"%@", [op response]);
    NSLog(@"%d", response);
    NSLog(@"%@", [op summary]);
    NSLog(@"Your mom finnished that pancakes bra");
}

@end
