//
//  PGTreeNode.m
//  Neurosis
//
//  Created by Patrick B. Gibson on 03/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGTreeNode.h"
#import "NSArray_Extensions.h"

@implementation PBGTreeNode

- (id)initWithNodeType:(PBGTreeNodeType)type nodeTitle:(NSString *)title andNodeIcon:(NSImage *)icon;
{
	if (self = [super init])
	{
		nodeTitle = [title retain];
		nodeType = type;
		if (icon) { nodeIcon = [icon retain]; }
		isLeaf = YES;
		
		[self setChildren:[NSArray array]];
	}
	return self;
}


- (void)setNodeTitle:(NSString *)newNodeTitle
{
	[newNodeTitle retain];
	[nodeTitle release];
	nodeTitle = newNodeTitle;
}

- (NSString *)nodeTitle
{
	return nodeTitle;
}

- (void)setNodeIcon:(NSImage *)icon
{
    if (!nodeIcon || ![nodeIcon isEqual:icon])
	{
		[nodeIcon release];
		nodeIcon = [icon retain];
    }
}

- (NSImage *)nodeIcon
{
    return nodeIcon;
}

- (void)setNodeType:(PBGTreeNodeType)newNodeType
{
	nodeType = newNodeType;
}

- (PBGTreeNodeType)nodeType
{
	return nodeType;
}

- (void)setLesson:(PBGLesson *)newLesson
{
	[newLesson retain];
	[lesson release];
	lesson = newLesson;
}

- (PBGLesson *)lesson
{
	return lesson;
}

- (void)setChildren:(NSArray *)newChildren
{
	if (children != newChildren)
    {
        [children autorelease];
        children = [[NSMutableArray alloc] initWithArray:newChildren];
		if ([children count] > 0)
			isLeaf = NO;
    }
}

- (NSMutableArray *)children
{
	return children;
}

- (NSComparisonResult)compare:(PBGTreeNode *)aNode
{
	return [[[self nodeTitle] lowercaseString] compare:[[aNode nodeTitle] lowercaseString]];
}

- (void)addChild:(PBGTreeNode *)n
{
    [children addObject:n];
	isLeaf = NO;
}

- (PBGTreeNode *)childAtIndex:(int)i
{
    return [children objectAtIndex:i];
}

#pragma mark - Archiving And Copying Support
/*
// -------------------------------------------------------------------------------
//	mutableKeys:
//
//	Override this method to maintain support for archiving and copying.
// -------------------------------------------------------------------------------
- (NSArray*)mutableKeys
{
	return [NSArray arrayWithObjects:
			@"nodeTitle",
			@"children", 
			@"nodeIcon",
			@"nodeType"
			nil];
}


- (id)initWithDictionary:(NSDictionary*)dictionary
{
	self = [self init];
	NSEnumerator *keysToDecode = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while (key = [keysToDecode nextObject])
	{
		if ([key isEqualToString:@"children"])
		{
			if ([[dictionary objectForKey:@"isLeaf"] boolValue])
				[self setChildren:[NSArray arrayWithObject:self]];
			else
			{
				NSArray *dictChildren = [dictionary objectForKey:key];
				NSMutableArray *newChildren = [NSMutableArray array];
				
				for (id node in dictChildren)
				{
					id newNode = [[[self class] alloc] initWithDictionary:node];
					[newChildren addObject:newNode];
					[newNode release];
				}
				[self setChildren:newChildren];
			}
		}
		else
			[self setValue:[dictionary objectForKey:key] forKey:key];
	}
	return self;
}

- (NSDictionary*)dictionaryRepresentation
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	NSEnumerator		*keysToCode = [[self mutableKeys] objectEnumerator];
	NSString			*key;
	
	while (key = [keysToCode nextObject])
	{
		// convert all children to dictionaries
		if ([key isEqualToString:@"children"])
		{
			if (!isLeaf)
			{
				NSMutableArray *dictChildren = [NSMutableArray array];
				for (id node in children)
				{
					[dictChildren addObject:[node dictionaryRepresentation]];
				}
				
				[dictionary setObject:dictChildren forKey:key];
			}
		}
		else if ([self valueForKey:key])
		{
			[dictionary setObject:[self valueForKey:key] forKey:key];
		}
	}
	return dictionary;
}

- (id)initWithCoder:(NSCoder*)coder
{		
	self = [self init];
	NSEnumerator *keysToDecode = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while (key = [keysToDecode nextObject])
		[self setValue:[coder decodeObjectForKey:key] forKey:key];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{	
	NSEnumerator *keysToCode = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while (key = [keysToCode nextObject])
		[coder encodeObject:[self valueForKey:key] forKey:key];
}

- (id)copyWithZone:(NSZone*)zone
{
	id newNode = [[[self class] allocWithZone:zone] init];
	
	NSEnumerator *keysToSet = [[self mutableKeys] objectEnumerator];
	NSString *key;
	while (key = [keysToSet nextObject])
		[newNode setValue:[self valueForKey:key] forKey:key];
	
	return newNode;
}

// -------------------------------------------------------------------------------
//	setNilValueForKey:key
//
//	Override this for any non-object values
// -------------------------------------------------------------------------------
- (void)setNilValueForKey:(NSString*)key
{
	if ([key isEqualToString:@"isLeaf"])
		isLeaf = NO;
	else
		[super setNilValueForKey:key];
}

*/

- (BOOL)isLeaf
{
	return isLeaf;
}

- (void)dealloc
{
	[nodeTitle release];
	[nodeIcon release];
	[children release];
	[super dealloc];
}

@end
