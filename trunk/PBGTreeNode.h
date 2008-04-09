//
//  PGTreeNode.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 03/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGLesson.h"
#import "PBGDefines.h"


@interface PBGTreeNode : NSObject {
	
	NSString			*nodeTitle;
	NSImage				*nodeIcon;
	PBGTreeNodeType		nodeType; // Folder, Special, lesson, etc
	
	PBGLesson			*lesson;
	
	NSMutableArray		*children;

	BOOL				isLeaf;
}

- (id)initWithNodeType:(PBGTreeNodeType)type nodeTitle:(NSString *)title andNodeIcon:(NSImage *)icon;

- (void)setNodeTitle:(NSString *)newNodeTitle;
- (NSString *)nodeTitle;

- (void)setNodeIcon:(NSImage *)icon;
- (NSImage *)nodeIcon;

- (void)setNodeType:(PBGTreeNodeType)newNodeType;
- (PBGTreeNodeType)nodeType;

- (void)setLesson:(PBGLesson *)newLesson;
- (PBGLesson *)lesson;

- (void)setChildren:(NSArray *)newChildren;
- (NSMutableArray *)children;
- (void)addChild:(PBGTreeNode *)n;
- (PBGTreeNode *)childAtIndex:(int)i;

- (NSComparisonResult)compare:(PBGTreeNode *)aNode;

- (BOOL)isLeaf;
@end
