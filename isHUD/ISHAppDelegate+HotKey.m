//
//  ISHAppDelegate+HotKey.m
//  isHUD
//
//  Created by ghawkgu on 11/18/11.
//  Copyright (c) 2011 ghawkgu. All rights reserved.
//
#import <Carbon/Carbon.h>
#import "ISHAppDelegate.h"


pascal OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData);

// This routine is called when the command-return hotkey is pressed.  It means it's time to change modes for the blue selection box overlay window.
pascal OSStatus MyHotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent,void *userData)
{
    // We can assume our hotkey was pressed
    GHKLOG(@"Hot key pressed!");
    // Get the reference to our window and call -switchDirection to reverse the trackingWin's direction.
    ISHAppDelegate *delegate = (__bridge ISHAppDelegate *)userData;
    [delegate onHotKey:nil];
    
    return noErr;
    
}

@implementation ISHAppDelegate (Hotkey)
// These hot key
const UInt32 kMyHotKeyIdentifier='ihud';
const UInt32 kMyHotKey = kVK_Escape;
const UInt32 kMyHotKeyModifier = optionKey;

EventHotKeyRef gMyHotKeyRef;
EventHotKeyID gMyHotKeyID;
EventHandlerUPP gAppHotKeyFunction;

#pragma mark - Register shortcut key
-(void) registerHotKey {
    EventTypeSpec eventType;
    
    gAppHotKeyFunction = NewEventHandlerUPP(MyHotKeyHandler);
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;
    InstallApplicationEventHandler(gAppHotKeyFunction,1,&eventType,self,NULL);
    gMyHotKeyID.signature=kMyHotKeyIdentifier;
    gMyHotKeyID.id=1;
    
    RegisterEventHotKey(kMyHotKey, kMyHotKeyModifier, gMyHotKeyID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}

-(void) unregisterHotKey {
    UnregisterEventHotKey(gMyHotKeyRef);
}
@end
