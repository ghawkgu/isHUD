//
//  ISHAppDelegate+HotKey.m
//  isHUD
//
//  Created by ghawkgu on 11/18/11.
//  Copyright (c) 2011 ghawkgu. All rights reserved.
//

#import "ISHAppDelegate.h"
#import <ApplicationServices/ApplicationServices.h>

CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type,  CGEventRef event, void *refcon);
CGEventRef myCGEventCallback(CGEventTapProxy proxy, CGEventType type,  CGEventRef event, void *refcon) {    
    CGEventFlags modifierFlags = CGEventGetFlags(event);
    modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;
    GHKLOG(@"Modifier flag changed! %llX", modifierFlags);
    
    if ((modifierFlags & NSDeviceIndependentModifierFlagsMask) == kCGEventFlagMaskSecondaryFn) {
        GHKLOG(@"Fn pressed.");
        [(ISHAppDelegate *)[NSApp delegate] onHotKey:nil];
    } else if ((modifierFlags & NSDeviceIndependentModifierFlagsMask) != kCGEventFlagMaskSecondaryFn) {
        GHKLOG(@"Fn not pressed.");
        [(ISHAppDelegate *)[NSApp delegate] cancelHotKey:nil];
    }
    
    return event; 
}

@implementation ISHAppDelegate (Hotkey)
NSMachPort *eventTap;

#pragma mark - Register shortcut key
-(void) registerHotKey {
    
    CGEventFilterMask mask = 
        CGEventMaskBit(kCGEventFlagsChanged)
        | CGEventMaskBit(kCGEventKeyDown)
        | CGEventMaskBit(kCGEventKeyUp);
    
    eventTap = (NSMachPort *)CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, mask, myCGEventCallback, NULL);
    
    [[NSRunLoop mainRunLoop] addPort:eventTap forMode:NSRunLoopCommonModes];
    CGEventTapEnable((CFMachPortRef)eventTap, true);
}

-(void) unregisterHotKey {
    CGEventTapEnable((CFMachPortRef)eventTap, false);
    [[NSRunLoop mainRunLoop] removePort:eventTap forMode:NSRunLoopCommonModes];

    CFRelease(eventTap);
}
@end
