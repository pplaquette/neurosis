//
//  PBGLesson.m
//  Neurosis
//
//  Created by Patrick B. Gibson on 05/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGLesson.h"


@implementation PBGLesson

@synthesize imageAsArray;
@synthesize image;
@synthesize meaning;

- (id)initWithImagePath:(NSString *)ip meaning:(NSString *)m
{
	self = [super init];
	if (self != nil) {
		imagePath = [ip retain];
		meaning = [m retain];
		
		image = [[NSImage alloc] initWithContentsOfFile:imagePath];
	}
	return self;
}

- (void)addArrayRep:(NSArray *)a
{
	imageAsArray = [a retain];
}


- (void)dealloc
{
	if (imageAsArray) { [imageAsArray release]; }
	[image release];
	[imagePath release];
	[meaning release];
	[super dealloc];
}

@end
