//
//  NeurosisController.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 01/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "CameraController.h"
#import "LessonController.h"

#import "PBGNeuralNetwork.h"

#import "PBGTreeNode.h"
#import "PBGSeparatorCell.h"

@interface NeurosisController : NSObject {
	
	IBOutlet NSSplitView		*splitView;
	IBOutlet NSView				*mainView;
	IBOutlet NSView				*cameraView;
	IBOutlet NSView				*lessonView;
	
	IBOutlet NSView				*currentView;
	
	
	IBOutlet NSOutlineView		*sourceListView;
	
	IBOutlet NSTreeController	*treeController;
	
	CameraController			*cameraController;
	LessonController			*lessonController;

	NSMutableArray				*contents;
	
	PBGNeuralNetwork			*neuralNetwork;
	float						resolution;
	
	PBGSeparatorCell			*separatorCell;
	
	NSImage						*cameraIconImage;
	NSImage						*photoIconImage;
}

- (void)setContents:(NSArray*)newContents;
- (NSMutableArray*)contents;

- (void)addNode:(PBGTreeNode *)newNode atIndex:(NSNumber *)givenIndex;

- (BOOL)isSpecialGroup:(PBGTreeNode *)groupNode;

- (void)selectCamera;

- (int)containsExistingLessonOf:(NSString *)thing;
@end
