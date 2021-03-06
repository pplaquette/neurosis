//
//  CameraController.m
//  Neurosis
//
//  Created by Patrick B. Gibson on 05/03/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CameraController.h"
#import "PBGDefines.h"

@implementation CameraController

- (void)awakeFromNib
{ 
	lastFrame = [[CIImage alloc] init];
	
	resolution = 10.0;
	
	hElements = (double) 640 / resolution;
	vElements = (double) 480 / resolution;
	
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter addObserver:self 
						   selector:@selector(updateResolution:) 
							   name:kResolutionChangedNotification 
							 object:nil];
	
	NSLog(@"Creating iprocessor with dimensions: %f x %f", hElements, vElements);
	
	iprocessor = [[PBGANNImageProcessor alloc] initWithHorizontalElements:hElements verticalElements:vElements];
	[self setValue:[NSNumber numberWithFloat:1.2] forKey:@"contrast"];
	
	//Create the capture session
    mCaptureSession = [[QTCaptureSession alloc] init];
	
	//Connect inputs and outputs to the session
    BOOL success = NO;
    NSError *error;
	
	// Find a video device
	QTCaptureDevice *device = [QTCaptureDevice defaultInputDeviceWithMediaType:QTMediaTypeVideo];
    if (device) {
        success = [device open:&error];
        if (!success) {
            // Handle error
			NSLog(@"Error 1");
        }
		// Add the video device to the session as device input
        mCaptureDeviceInput = [[QTCaptureDeviceInput alloc] initWithDevice:device];
        success = [mCaptureSession addInput:mCaptureDeviceInput error:&error];
        if (!success) {
            // Handle error
			NSLog(@"Error 2");
        }
		
		// Create the movie file output and add it to the session
		mRawVideoOutput = [[QTCaptureDecompressedVideoOutput alloc] init];
		[mRawVideoOutput setDelegate:self];
		success = [mCaptureSession addOutput:mRawVideoOutput error:&error];
		if (!success) {
			// Handle error
			NSLog(@"Error 3");
		}
		
		// Set the controller be the movie file output delegate.
		[mRawVideoOutput setDelegate:self];
		
		// Associate the capture view in the UI with the session
		[mCaptureView setCaptureSession:mCaptureSession];
		[mCaptureView setDelegate:self];
    }
	// Start the capture session running
	[mCaptureSession startRunning];
	
}

- (double)hElements
{
	return hElements;
}

- (double)vElements
{
	return vElements;
}

- (NSString *)recognizedString;
{
	return recognizedString;
}

- (void)setRecognizedString:(NSString *)s
{
	[recognizedString release];
	recognizedString = [s retain];
}

- (void)updateResolution:(NSNotification *)note
{
	NSLog(@"Updating resolution");
	resolution = [[[note object] valueForKey:kResolutionIdentifier] doubleValue];
		
	hElements = 640 / resolution;
	vElements = 480 / resolution;
	
	NSLog(@"Creating iprocessor with dimensions: %f x %f", hElements, vElements);
	
	if (iprocessor) { [iprocessor release]; }
	iprocessor = [[PBGANNImageProcessor alloc] initWithHorizontalElements:hElements verticalElements:vElements];
}

- (void)windowWillClose:(NSNotification *)notification 
{ 
	[[mCaptureDeviceInput device] close];
} 

- (void)captureOutput:(QTCaptureOutput *)captureOutput didOutputVideoFrame:(CVImageBufferRef)videoFrame withSampleBuffer:(QTSampleBuffer *)sampleBuffer fromConnection:(QTCaptureConnection *)connection
{
    // Store the latest frame
    // This must be done in a @synchronized block because this delegate method is not called on the main thread
    CVImageBufferRef imageBufferToRelease;
	
    CVBufferRetain(videoFrame);
	
    @synchronized (self) {
        imageBufferToRelease = mCurrentImageBuffer;
        mCurrentImageBuffer = videoFrame;
    }
    CVBufferRelease(imageBufferToRelease);
}

- (CIImage *)view:(QTCaptureView *)view willDisplayImage:(CIImage *)i
{
	[lastFrame release];
	lastFrame = [[PBGANNImageProcessor applyBrightness:brightness contrast:contrast pixellation:resolution toCIImage:i] retain];
	return lastFrame;
}


- (CIImage *)grabFrame
{
	return lastFrame;
}

- (IBAction)recognize:(id)sender
{
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:kRecognizeImageNotification object:nil];
}

- (IBAction)takePicture:(id)sender
{
	NSLog(@"Taking Picture.");

	CVImageBufferRef imageBuffer;
	@synchronized (self) {
		imageBuffer = CVBufferRetain(mCurrentImageBuffer);
	}
	
	CIImage *capturedImage = [CIImage imageWithCVImageBuffer:imageBuffer];
	capturedImage = [PBGANNImageProcessor applyBrightness:brightness contrast:contrast pixellation:resolution toCIImage:capturedImage];

	NSArray *imageAsArray = [PBGANNImageProcessor arrayRepresentationOfImage:capturedImage withPixellationFactor:resolution];
	
	NSCIImageRep *imageRep = [NSCIImageRep imageRepWithCIImage:capturedImage];
	NSImage *image = [[NSImage alloc] initWithSize:[imageRep size]];
	[image addRepresentation:imageRep];
	
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Create our app support folder if it doesn't exist
	NSString *folder = @"~/Library/Application Support/Neurosis/";
	folder = [folder stringByExpandingTildeInPath];
	if ([fileManager fileExistsAtPath:folder] == NO) {
		[fileManager createDirectoryAtPath:folder attributes:nil];
	}
    
	// Give our image a default title
	NSString *fileName = [imageOfString stringValue];
	if ([fileName isEqualToString:@""]) {
		fileName = @"Default";
	}
	
	// Append a counter if that image already exists
	int counter = 1;
	NSString *originalFileName = fileName;
	while([fileManager fileExistsAtPath:[[folder stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"tif"]]) {
		fileName = [originalFileName stringByAppendingFormat:@"-%d", counter, nil];
		counter++;
	}
	
	
	NSString *fullFilePath = [[folder stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"tif"];
	// Save our file
	NSLog(@"Writing to %@", fullFilePath);
	[[image TIFFRepresentation] writeToFile:fullFilePath atomically:YES];
	
	// Create a dictionary with the info we need
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
	[dict setObject:originalFileName forKey:kMeaningIdentifier];
	[dict setObject:fullFilePath forKey:kFilePathIdentifier];
	[dict setObject:imageAsArray forKey:kImageAsArrayIdentifier];
	
	// Make our notification here.
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	[notificationCenter postNotificationName:kPictureTakenNotification object:dict];
	
	[dict release]; // Maybe crash-y?
	CVBufferRelease(imageBuffer);
	[image release];
}



- (void)dealloc
{
	[lastFrame release];
    [mCaptureSession release];
    [mCaptureDeviceInput release];
    [mRawVideoOutput release];
	[iprocessor release];
    [super dealloc];
}


@end
