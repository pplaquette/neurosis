//
//  PGSeparatorCell.m
//  Neurosis
//
//  Created by Patrick B. Gibson on 03/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGSeparatorCell.h"


@implementation PBGSeparatorCell
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView*)controlView
{
	// draw the separator
	CGFloat lineWidth = cellFrame.size.width;
	CGFloat lineX = 0;
	CGFloat lineY = (cellFrame.size.height - 2) / 2;
	lineY += 0.5;
	
	[[NSColor colorWithDeviceRed:.349 green:.6 blue:.898 alpha:0.6] set];
	NSRectFill(NSMakeRect(cellFrame.origin.x + lineX, cellFrame.origin.y + lineY, lineWidth, 1));
	
	[[NSColor colorWithDeviceRed:1.976 green:2.0 blue:2.0 alpha:1.0] set];
	NSRectFill(NSMakeRect(cellFrame.origin.x + lineX, cellFrame.origin.y + lineY + 1, lineWidth, 1));
}


- (void)selectWithFrame:(NSRect)aRect inView:(NSView*)controlView editor:(NSText*)textObj delegate:(id)anObject start:(int)selStart length:(int)selLength
{
}

- (BOOL)isSelectable
{
	return NO;
}

@end
