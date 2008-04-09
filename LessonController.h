//
//  LessonController.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 05/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface LessonController : NSViewController {
	
	IBOutlet NSImageView		*imageView;
	IBOutlet NSTextField		*lessonOfTextField;
	
	NSImage						*image;
	NSArray						*interpretedImageData;

}

@end
