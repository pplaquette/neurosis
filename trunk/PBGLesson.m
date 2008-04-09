//
//  PBGLesson.m
//  Neurosis
//
//  Created by Patrick B. Gibson on 05/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGLesson.h"


@implementation PBGLesson

- (id)initWithImagePath:(NSString *)ip meaning:(NSString *)m
{
	self = [super init];
	if (self != nil) {
		imagePath = [ip retain];
		meaning = [m retain];
	}
	return self;
}

- (NSString *)meaning
{
	return meaning;	
}

- (NSString *)imagePath
{
	return imagePath;
}

- (void)dealloc
{
	[imagePath release];
	[meaning release];
	[super dealloc];
}

@end
