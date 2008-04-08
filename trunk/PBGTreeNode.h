//
//  PGTreeNode.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 03/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBGTreeNode : NSObject {
	
	NSString		*nodeTitle;
	NSMutableArray	*children;
	BOOL			isLeaf;
	NSImage			*nodeIcon;
	NSString		*urlString;
	
	NSString		*description;
	NSTextStorage	*text;

}

- (id)initLeaf;

- (void)setNodeTitle:(NSString*)newNodeTitle;
- (NSString*)nodeTitle;

- (void)setChildren:(NSArray*)newChildren;
- (NSMutableArray*)children;

- (void)setLeaf:(BOOL)flag;
- (BOOL)isLeaf;

- (void)setNodeIcon:(NSImage*)icon;
- (NSImage*)nodeIcon;

- (void)setURL:(NSString*)name;
- (NSString*)urlString;

- (BOOL)isDraggable;

- (NSComparisonResult)compare:(PBGTreeNode*)aNode;

- (NSArray*)mutableKeys;

- (NSDictionary*)dictionaryRepresentation;
- (id)initWithDictionary:(NSDictionary*)dictionary;

- (id)parentFromArray:(NSArray*)array;
- (void)removeObjectFromChildren:(id)obj;
- (NSArray*)descendants;
- (NSArray*)allChildLeafs;
- (NSArray*)groupChildren;
- (BOOL)isDescendantOfOrOneOfNodes:(NSArray*)nodes;
- (BOOL)isDescendantOfNodes:(NSArray*)nodes;
- (NSIndexPath*)indexPathInArray:(NSArray*)array;

- (void)setDescription:(NSString*)newDescription;
- (NSString*)description;
- (void)setText:(id)newText;
- (NSTextStorage*)text;


@end
