//
//  PBGArrayView.m
//  CaptureTest
//
//  Created by Patrick B. Gibson on 21/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGArrayView.h"


@implementation PBGArrayView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		mValuesArray = [[NSMutableArray alloc] initWithCapacity:100];
		
		int i = 0;
		for(i = 0; i<100; i++){
			[mValuesArray addObject:[NSNumber numberWithFloat:0.5]];
		}
		
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
	NSRect thisRect = [self bounds];
	
	// Clear the view to white
	[[NSColor whiteColor] set];
	NSRectFill(thisRect);
	
	float elementWidth = thisRect.size.width / mElementsWide;
	float elementHeight = thisRect.size.height / mElementsTall;
	float currentX = 0;
	float currentY = 0;
	
	float fValue;
	
	// Loop through our array, drawing each rect
	for (NSNumber *value in mValuesArray) {
		fValue = [value floatValue];
		//NSLog(@"Drawing %@", value);
		NSRect currentRect = NSMakeRect(currentX, currentY, elementWidth, elementHeight);
		[[NSColor colorWithCalibratedRed:fValue green:fValue blue:fValue alpha:1.0] set];
		NSRectFill(currentRect);
		
		// Increment our X and Y
		currentX += elementWidth;
		if (currentX >= thisRect.size.width){
			currentX = 0;
			currentY += elementHeight;
		}
	}
	
}

-(void)setValuesArray:(NSMutableArray *)array withElementsWide:(int)w elementsTall:(float)h
{
	mElementsWide = w;
	mElementsTall = h;
		
	[array retain];
	[mValuesArray release];
	mValuesArray = array;
}

@end
