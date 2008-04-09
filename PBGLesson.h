//
//  PBGLesson.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 05/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBGLesson : NSObject {
	
	NSString		*imagePath;
	NSArray			*imageAsArray;
	
	NSString		*meaning;
	
}

- (id)initWithImagePath:(NSString *)ip meaning:(NSString *)m;

@end
