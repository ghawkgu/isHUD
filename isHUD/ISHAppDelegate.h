//
//  ISHAppDelegate.h
//  isHUD
//
//  Created by ghawkgu on 11/15/11.
//  Copyright (c) 2011 ghawkgu.
//

#import <Cocoa/Cocoa.h>
#import "ISHPreferencesWindowController.h"

@interface ISHAppDelegate : NSObject <NSApplicationDelegate> {
@private
    BOOL fadingOut;
    NSUInteger hotkeySelectInputSource;
}
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *isName;
@property (assign) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSView *panelView;
@property (assign) IBOutlet NSImageView *isImage;
@property (retain) NSStatusItem *myStatusMenu;
@property (retain) ISHPreferencesWindowController *preferencesController;

- (IBAction)quit:(id)sender;
- (IBAction)toggleLoginItem:(id)sender;
- (IBAction)openPreferences:(id)sender;

- (IBAction)onHotKey:(id)sender;
- (IBAction)cancelHotKey:(id)sender;
- (IBAction)showHud:(id)sender;
@end
