//
//  ISHAppDelegate+HotKey.m
//  isHUD
//
//  Created by ghawkgu on 11/18/11.
//  Copyright (c) 2011 ghawkgu. All rights reserved.
//

#import "ISHAppDelegate.h"
#import "ISHKeyCode.h"

typedef void (^GlobalEventHandler)(NSEvent*);
typedef NSEvent* (^LocalEventHandler)(NSEvent*);

@implementation ISHAppDelegate (Hotkey)

-(void) fnPressed:(NSEvent*)event {
    static NSTimeInterval lastPressedTimestamp = NSTimeIntervalSince1970;
    NSTimeInterval fnPressedTimestamp = [event timestamp];
    if (fnPressedTimestamp - lastPressedTimestamp <= HOT_KEY_DOUBLE_STRIKE_INTERVAL) {
        [self showHud:nil];
    }
    lastPressedTimestamp = fnPressedTimestamp;
}

-(void)handleKeyEvent:(NSEvent *)event {
    GHKLOG(@"NSEvent! %lx %f", [event modifierFlags], [event timestamp] );
    NSUInteger modifierFlags = [event modifierFlags];
    if ((modifierFlags & COMMAND_L)== COMMAND_L) {
        GHKLOG(@"Command L");
    } else if ((modifierFlags & COMMAND_R) == COMMAND_R) {
        GHKLOG(@"Command R");
    } else if ((modifierFlags & FN) == FN) {
        GHKLOG(@"FN");
        [self fnPressed:event];
    }
}


#pragma mark - Register shortcut key
id globalMonitor_;
id localMonitor_;
-(void) registerHotKey {
    
    GlobalEventHandler handler = ^(NSEvent *e){
        [self handleKeyEvent:e];
    };

    LocalEventHandler localHandler = ^(NSEvent* e){
        [self handleKeyEvent:e];
        return e;
    };

    globalMonitor_ = [NSEvent addGlobalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:handler];
    localMonitor_ = [NSEvent addLocalMonitorForEventsMatchingMask:NSFlagsChangedMask handler:localHandler];
    [globalMonitor_ retain];
    [localMonitor_ retain];
}

-(void) unregisterHotKey {
    [NSEvent removeMonitor:globalMonitor_];
    [NSEvent removeMonitor:localMonitor_];

    [globalMonitor_ release];
    [localMonitor_ release];
    globalMonitor_ = nil;
    localMonitor_ = nil;
}
@end
