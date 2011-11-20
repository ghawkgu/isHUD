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
@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextField *isName;
@property (unsafe_unretained) IBOutlet NSMenu *statusMenu;
@property (unsafe_unretained) IBOutlet NSView *panelView;
@property (unsafe_unretained) IBOutlet NSImageView *isImage;
@property (strong) NSStatusItem *myStatusMenu;
@property (strong) ISHPreferencesWindowController *preferencesController;

- (IBAction)quit:(id)sender;
- (IBAction)toggleLoginItem:(id)sender;
- (IBAction)openPreferences:(id)sender;

- (IBAction)onHotKey:(id)sender;
- (IBAction)cancelHotKey:(id)sender;
- (IBAction)showHud:(id)sender;
@end
