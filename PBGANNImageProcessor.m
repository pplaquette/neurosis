//
//  PBGANNImageProcessor.m
//  CaptureTest
//
//  Created by Patrick B. Gibson on 15/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGANNImageProcessor.h"


@implementation PBGANNImageProcessor

+ (CIImage *)applyBrightness:(float)brightness andContrast:(float)contrast toCIImage:(CIImage *)i
{
	CIFilter *effectFilter = [CIFilter filterWithName:@"CIPixellate"];
	[effectFilter setDefaults];
	[effectFilter setValue:i forKey:@"inputImage"];
	[effectFilter setValue:[NSNumber numberWithFloat:10.0] forKey:@"inputScale"];
	
	CIFilter *colorAdjust = [CIFilter filterWithName:@"CIColorControls"];
	[colorAdjust setDefaults];
	[colorAdjust setValue:[effectFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
	[colorAdjust setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputContrast"];
	[colorAdjust setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
	[colorAdjust setValue:[NSNumber numberWithFloat:0.0] forKey:@"inputSaturation"];
	
	return [colorAdjust valueForKey:@"outputImage"];
}


- (id)initWithHorizontalElements:(int)h verticalElements:(int)v
{
	self = [super init];
	if (self != nil) {
		horizontalElements = h;
		verticalElements = v;
		contrastLevel = 3.0;
		imagePartsArray = [[NSMutableArray alloc] initWithCapacity:(horizontalElements * verticalElements)];
		valuesArray = [[NSMutableArray alloc] initWithCapacity:(horizontalElements * verticalElements)];
	}
	return self;
}

- (void)setImage:(CIImage *)newImage
{
	[image release];
	[newImage retain];
	image = newImage;
	[self updateImage];
}


- (NSMutableArray *)floatArrayFromImage
{	
	//Empty out our array
	[valuesArray removeAllObjects];
	
	CIFilter *colorAverage = [CIFilter filterWithName:@"CIAreaAverage"];
	[colorAverage setDefaults];
	CGRect imageRect = [image extent];
	[colorAverage setValue:image forKey:@"inputImage"];
	
	float elementWidth = imageRect.size.width / horizontalElements;
	float elementHeight = imageRect.size.height / verticalElements;
	float currentX = 0;
	float currentY = 0;
	int remainingElements, remainingRows;
	
	for (remainingRows = verticalElements; remainingRows > 0; remainingRows--) {
		for (remainingElements = horizontalElements; remainingElements > 0; remainingElements--) {
			
			// Create a rect which encompasses our new element
			CIVector *extent = [CIVector vectorWithX:currentX Y:currentY Z:elementWidth W:elementHeight]; 
			
			// Apply the colorAverageFilter
			[colorAverage setValue:extent forKey:@"inputExtent"];
			CIImage *colorImage = [colorAverage valueForKey:@"outputImage"];
			
			NSBitmapImageRep *pixel = [[NSBitmapImageRep alloc] initWithCIImage:colorImage];
			NSColor *averageColor = [pixel colorAtX:0 y:0];
			
			float components[4];
			[averageColor getComponents:components];
			
			// They're all going to be the same
			//NSLog(@"Adding %f / %f / %f / %f", components[0], components[1], components[2], components[3]);
			
			// Add the new image part to our array.
			[valuesArray addObject:[[NSNumber alloc] initWithFloat:components[0]]];
			[pixel release];
			
			// Increment our X and Y
			currentX += elementWidth;
			if (currentX >= imageRect.size.width){
				currentX = 0;
				currentY += elementHeight;
			}
			
		} // End inner loop
	} // End outter loop
	
	return valuesArray;	
}

/*
- (NSArray *)oldOrrayFromImage
{
	NSSize imageSize = [mOriginalImage size];
	
	float elementWidth = imageSize.width / mHorizontalElements;
	float elementHeight = imageSize.height / mVerticalElements;
	
	float currentX = 0;
	float currentY = 0;
	int remainingElements, remainingRows;
	
	for (remainingRows = mVerticalElements; remainingRows > 0; remainingRows--) {
		for (remainingElements = mHorizontalElements; remainingElements > 0; remainingElements--) {
			
			// Create a rect which encompasses our new element
			NSRect elementRect = NSMakeRect(currentX, currentY, elementWidth, elementHeight);
			
			// Create a new image part from our image
			NSPoint point = { -elementRect.origin.x, -elementRect.origin.y };
			NSImage *elementImage = [[NSImage alloc] initWithSize:elementRect.size];
			[elementImage lockFocus];
			[mOriginalImage compositeToPoint:point operation:NSCompositeCopy];
			[elementImage unlockFocus];
			
			// Add the new image part to our array.
			[mImagePartsArray addObject:elementImage];
			[elementImage release]; // I think.
			
			// Increment our X and Y
			currentX += elementWidth;
			if (currentX >= imageSize.width){
				currentX = 0;
				currentY += elementHeight;
			}
			
		} // End inner loop
	} // End outter loop
	
	return [mImagePartsArray copy];
}
*/

- (void)dealloc
{
	[image release];
	[imagePartsArray release];
	[valuesArray release];
	[super dealloc];
}

@end
