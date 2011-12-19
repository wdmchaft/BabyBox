//
//  ProgressView.h
//  BabyBox
//
//  Created by George Shank on 12/19/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressView : NSView
{
    NSProgressIndicator *progressBar;
    NSTextField *fileName;
}

@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressBar;
@property (nonatomic, retain) IBOutlet NSTextField *fileName;
@end
