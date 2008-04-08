//
//  PGSourceObject.m
//  Neurosis
//
//  Created by Patrick B. Gibson on 02/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PBGSourceObject.h"


@implementation PBGSourceObject

@synthesize indexPath, nodeURL, nodeName;

- (id)initWithURL:(NSString *)url withName:(NSString *)name
{
	self = [super init];
	
	nodeName = name;
	nodeURL = url;
	
	return self;
}

@end
