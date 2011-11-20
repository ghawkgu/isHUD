//
//  ISHAppDelegate+.h
//  isHUD
//
//  Created by ghawkgu on 11/20/11.
//  Copyright (c) 2011 ghawkgu.
//

#import "ISHAppDelegate.h"
#import <Carbon/Carbon.h>

@interface ISHAppDelegate ()
@property (retain) NSTimer *timerToFadeOut;
@property (retain) NSTimer *timerForHotKeyDelay;

- (void) fadeInHud;
- (void) fadeOutHud;
- (void) didFadeIn;
- (void) didFadeOut;
@end

#pragma mark - Helpers
@interface ISHAppDelegate (Helper)
-(void) dumpInputResource:(TISInputSourceRef)inputResource;
@end

#pragma mark - Login item helpers
@interface ISHAppDelegate (LoginItem)
- (BOOL) isLoginItem;
- (void) addAppAsLoginItem;
- (void) deleteAppFromLoginItem;
@end

#pragma mark - HotKey
@interface ISHAppDelegate (HotKey)
- (void)registerHotKey;
- (void)unregisterHotKey;
@end

#pragma mark - Preferences
@interface ISHAppDelegate (Preferences)
-(void) registerDefaultPreferences;
-(void) loadPreferences;
@end
