//
//  NSAttributedString+Hyperlink.h
//  isHUD
//
//  Created by ghawkgu on 11/21/11.
//  Copyright (c) 2011 ghawkgu.
//

#import <Foundation/Foundation.h>

// How to make a clickable url link. 
// http://developer.apple.com/library/mac/#qa/qa1487/_index.html

@interface NSAttributedString (Hyperlink)
+ (id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
@end
