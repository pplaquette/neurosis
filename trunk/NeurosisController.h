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
	LessonController			*lessonContoller;

	NSMutableArray				*contents;
	
	PBGSeparatorCell			*separatorCell;
	
	NSImage						*cameraIconImage;
	NSImage						*photoIconImage;
}

- (void)setContents:(NSArray*)newContents;
- (NSMutableArray*)contents;

- (void)addNode:(PBGTreeNode *)newNode;

- (void)addElement:(PBGTreeNode *)treeAddition;
- (void)addFolder:(PBGTreeNode *)treeAddition;

- (BOOL)isSpecialGroup:(PBGTreeNode *)groupNode;

- (int)containsExistingLessonOf:(NSString *)thing;
@end
