//
//  ISHAppDelegate.h
//  isHUD
//
//  Created by ghawkgu on 11/15/11.
//  Copyright (c) 2011 ghawkgu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define HUD_FADE_IN_DURATION    (0.2)
#define HUD_FADE_OUT_DURATION   (0.2)
#define HUD_DISPLAY_DURATION    (2.0)
#define HUD_ALPHA_VALUE         (0.6)
#define HUD_CORNER_RADIUS       (18.0)

#define HUD_HORIZONTAL_MARGIN   (30)
#define HUD_HEIGHT              (100)

#define MENUITEM_TAG_TOGGLE_LOGIN_ITEM 1
#define STATUS_MENU_ICON @"icon-18x18.png"

@interface ISHAppDelegate : NSObject <NSApplicationDelegate> {
@private
    BOOL fadingOut;
}
@property (unsafe_unretained) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextField *isName;
@property (unsafe_unretained) IBOutlet NSMenu *statusMenu;
@property (unsafe_unretained) IBOutlet NSView *panelView;
@property (unsafe_unretained) IBOutlet NSImageView *isImage;
@property (strong) NSStatusItem * myStatusMenu;

- (IBAction)quit:(id)sender;
- (IBAction)toggleLoginItem:(id)sender;
@end
