//
//  PBGArrayView.h
//  CaptureTest
//
//  Created by Patrick B. Gibson on 21/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBGArrayView : NSView {
	NSMutableArray	*mValuesArray;
	float			mElementsWide;
	float			mElementsTall;
}

-(void)setValuesArray:(NSMutableArray *)array withElementsWide:(int)w elementsTall:(float)h;

@end
