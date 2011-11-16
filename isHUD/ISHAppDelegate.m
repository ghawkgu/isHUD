//
//  ISHAppDelegate.m
//  isHUD
//
//  Created by ghawkgu on 11/15/11.
//  Copyright (c) 2011 ghawkgu. All rights reserved.
//

#import "ISHAppDelegate.h"
#import <Carbon/Carbon.h>

@interface ISHAppDelegate ()
@property (retain) NSTimer *timerToFadeOut;
- (void) fadeInHud;
- (void) fadeOutHud;
- (void) didFadeIn;
- (void) didFadeOut;
@end

#pragma mark - Login item helpers
@interface ISHAppDelegate (LoginItem)
- (BOOL) isLoginItem;
- (void) addAppAsLoginItem;
- (void) deleteAppFromLoginItem;
@end

@implementation ISHAppDelegate (LoginItem)
// I copied the codes from the following blog. And a little modification.
// http://cocoatutorial.grapewave.com/2010/02/creating-andor-removing-a-login-item/

-(LSSharedFileListItemRef) findLoginItem:(LSSharedFileListRef)loginItems {
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    
    // This will retrieve the path for the application
	// For example, /Applications/test.app
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
    
    LSSharedFileListItemRef retVal = NULL;
    
    if (loginItems) {
		UInt32 seedValue;
		//Retrieve the list of Login Items and cast them to
		// a NSArray so that it will be easier to iterate.
		NSArray  *loginItemsArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
		int i = 0;
		for(; i< [loginItemsArray count]; i++){
			LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)[loginItemsArray
                                                                        objectAtIndex:i];
			//Resolve the item with URL
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
				NSString * urlPath = [(__bridge NSURL*)url path];
				if ([urlPath compare:appPath] == NSOrderedSame){
					retVal = itemRef;
                    break;
				}
			}
		}
		//[loginItemsArray release];
	}
    
    return retVal;
}

-(BOOL) isLoginItem {
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
    return [self findLoginItem:loginItems] ? YES : NO;
}

-(void) addAppAsLoginItem{
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	// This will retrieve the path for the application
	// For example, /Applications/test.app
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath]; 
    
	// Create a reference to the shared file list.
    // We are adding it to the current user only.
    // If we want to add it all users, use
    // kLSSharedFileListGlobalLoginItems instead of
    //kLSSharedFileListSessionLoginItems
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
	if (loginItems) {
		//Insert an item to the list.
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                                                                     kLSSharedFileListItemLast, NULL, NULL,
                                                                     url, NULL, NULL);
		if (item){
			CFRelease(item);
        }
	}	
    
	CFRelease(loginItems);
}

-(void) deleteAppFromLoginItem{
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
                                                            kLSSharedFileListSessionLoginItems, NULL);
    
    LSSharedFileListItemRef itemRef = [self findLoginItem:loginItems];
    
    if (itemRef) {
        LSSharedFileListItemRemove(loginItems,itemRef);
    }
}
@end

#pragma mark -
@implementation ISHAppDelegate

@synthesize window = _window;
@synthesize isName = _isName;
@synthesize statusMenu = _statusMenu;
@synthesize panelView = _panelView;
@synthesize isImage = _isImage;
@synthesize timerToFadeOut = _timerToFadeOut;
@synthesize myStatusMenu = _myStatusMenu;

// We don't need this 'cause now we have ARC.
//- (void)dealloc
//{
//    [super dealloc];
//}

#pragma mark - Window fadding in/out animation
- (void)fadeInHud {
    if (self.timerToFadeOut) {
        [self.timerToFadeOut invalidate];
        self.timerToFadeOut = nil;
    }
    
    if (fadingOut) {
        [[self.window animator] stopAnimation];
        fadingOut = NO;
    }
    
    [self.window orderFrontRegardless];
    [NSAnimationContext beginGrouping];
    NSAnimationContext *context = [NSAnimationContext currentContext];
    [context setDuration:HUD_FADE_IN_DURATION];

    [context setCompletionHandler:^{ [self didFadeIn]; }];
    
    [[self.window animator] setAlphaValue:1.0];
    [NSAnimationContext endGrouping];
}

- (void) didFadeIn {
    self.timerToFadeOut = [NSTimer scheduledTimerWithTimeInterval:HUD_DISPLAY_DURATION target:self selector:@selector(fadeOutHud) userInfo:nil repeats:NO];
}

- (void)fadeOutHud {
    fadingOut = YES;
    [NSAnimationContext beginGrouping];
    NSAnimationContext *context = [NSAnimationContext currentContext];
    [context setDuration:HUD_FADE_OUT_DURATION];
    
    [context setCompletionHandler:^{ [self didFadeOut]; }];

    [[self.window animator] setAlphaValue:0.0];
    [NSAnimationContext endGrouping];
}

- (void)didFadeOut {
    fadingOut = NO;
    [self.window orderOut:nil];
}

#pragma mark - Main application
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    GHKLOG(@"Initialized!");
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(inputSourceChanged:)
                                                            name:(NSString *)kTISNotifySelectedKeyboardInputSourceChanged object:nil];
}

-(void) initUIComponents {
    [self.window setOpaque:NO];
    [self.window setAlphaValue:0.0];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setLevel:NSModalPanelWindowLevel];
    [self.window setHidesOnDeactivate:NO];
    // Make the window behavior like the menu bar.
    [self.window setCollectionBehavior: NSWindowCollectionBehaviorCanJoinAllSpaces];
        
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.0, 0.0, 0.0, HUD_ALPHA_VALUE)]; //RGB plus Alpha Channel
    [viewLayer setCornerRadius:18];
    [self.panelView setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    [self.panelView setLayer:viewLayer];
}


-(void) updateLoginItemMenuState:(NSInteger)state {
    NSMenuItem *item = [self.statusMenu itemWithTag:MENUITEM_TAG_TOGGLE_LOGIN_ITEM];
    [item setState:state];
}

-(void)awakeFromNib{
    [self initUIComponents];
    
    // Initialize the menu.
    self.myStatusMenu = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.myStatusMenu setMenu:self.statusMenu];
    //[statusItem setTitle:@"isHUD"];
    [self.myStatusMenu setImage:[NSImage imageNamed:STATUS_MENU_ICON]];
    [self.myStatusMenu setHighlightMode:YES];
    
    if ([self isLoginItem]) {
        [self updateLoginItemMenuState:NSOnState];
    } else {
        [self updateLoginItemMenuState:NSOffState];
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

- (void)inputSourceChanged:(NSNotification *) notification {
    GHKLOG(@"Input method changed, %@", notification);

    TISInputSourceRef inputSource = TISCopyCurrentKeyboardInputSource();
    NSString *name = (__bridge NSString *)TISGetInputSourceProperty(inputSource, kTISPropertyLocalizedName);
    GHKLOG(@"The im name is: %@", name);
    
    static NSString *previousIsName = nil;
    
    //Display the input source name only if it has changed.
    if (![previousIsName isEqualToString:name]) {
        previousIsName = name;
        [self.isName setTitleWithMnemonic:name];
        NSURL *iconUrl = (__bridge NSURL *)TISGetInputSourceProperty(inputSource, kTISPropertyIconImageURL);
        GHKLOG(@"Icon url:%@", iconUrl);
        self.isImage.image = [[NSImage alloc] initWithContentsOfURL:iconUrl];
        
        [self fadeInHud];
    }

}

#pragma mark - Menu item event handler
- (IBAction)quit:(id)sender {
    GHKLOG(@"Bye!");
    [NSApp terminate:nil];
}

- (IBAction)toggleLoginItem:(id)sender {
    if ([self isLoginItem]) {
        [self deleteAppFromLoginItem];
        [self updateLoginItemMenuState:NSOffState];
    } else {
        [self addAppAsLoginItem];
        [self updateLoginItemMenuState:NSOnState];
    }

}

@end
