//
//  PBGLesson.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 05/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBGLesson : NSObject {
	
	NSImage		*image;
	NSArray		*imageAsArray;
	
	NSString	*meaning;
	
}

@property NSImage *image;
@property NSArray *imageAsArray;
@property NSString *meaning;

@end
