//
//  ISHPreferenceWindowController.h
//  isHUD
//
//  Created by ghawkgu on 11/20/11.
//  Copyright (c) 2011 ghawkgu.
//

#import <Cocoa/Cocoa.h>

@interface ISHPreferencesWindowController : NSWindowController
@property (assign) IBOutlet NSButtonCell *radioHotKeyOptionR;
@property (assign) IBOutlet NSButtonCell *radioHotKeyCommandR;
@property (assign) IBOutlet NSTextField *versionNumber;
- (IBAction)changeHotkey:(id)sender;
@end
