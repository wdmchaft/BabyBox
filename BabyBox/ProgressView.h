//
//  ProgressView.h
//  BabyBox
//
//  Created by Klint Holmes on 12/19/11.
//  Copyright (c) 2011 Klint Holmes. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProgressView : NSViewController {
    IBOutlet NSProgressIndicator *progress;
}

@property (nonatomic, retain) NSProgressIndicator *progress;

@end
