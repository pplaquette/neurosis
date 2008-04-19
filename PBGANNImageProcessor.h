//
//  PBGANNImageProcessor.h
//  CaptureTest
//
//  Created by Patrick B. Gibson on 15/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface PBGANNImageProcessor : NSObject {
	CIImage			*image;
	NSMutableArray	*imagePartsArray;
	NSMutableArray	*valuesArray;
	int				verticalElements;
	int				horizontalElements;
	float			contrastLevel;
}

+ (CIImage *)applyBrightness:(float)brightness contrast:(float)contrast pixellation:(float)pixellation toCIImage:(CIImage *)i;
+ (NSArray *)arrayRepresentationOfImage:(CIImage *)image withPixellationFactor:(int)pixellation;

- (id)initWithHorizontalElements:(int)h verticalElements:(int)v;

- (void)setImage:(CIImage *)newImage;

- (NSMutableArray *)floatArrayFromImage;
@end
