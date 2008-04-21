//
//  CameraController.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 05/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PBGANNImageProcessor.h"
#import "PBGArrayView.h"

@interface CameraController : NSViewController {
	IBOutlet QTCaptureView				*mCaptureView;
	IBOutlet NSTextField				*imageOfString;
	
	QTCaptureDeviceInput				*mCaptureDeviceInput; 
	QTCaptureSession					*mCaptureSession;
	QTCaptureDecompressedVideoOutput	*mRawVideoOutput;
	CVImageBufferRef                     mCurrentImageBuffer;
	
	float								contrast;
	float								brightness;
	double								resolution;
	double								hElements;
	double								vElements;
	
	PBGANNImageProcessor				*iprocessor;
}

- (IBAction)takePicture:(id)sender;

-(double)hElements;
-(double)vElements;

@end
