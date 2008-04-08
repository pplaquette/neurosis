//
//  PGBSourceObject.h
//  Neurosis
//
//  Created by Patrick B. Gibson on 02/04/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBGSourceObject : NSObject {
	NSIndexPath *indexPath;
	NSString	*nodeURL;
	NSString	*nodeName;
}

- (id)initWithURL:(NSString *)url withName:(NSString *)name;

@property (readonly) NSIndexPath *indexPath;
@property (readonly) NSString *nodeURL;
@property (readonly) NSString *nodeName;
@end
