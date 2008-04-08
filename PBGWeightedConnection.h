//
//  PBGWeightedConnection.h
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class PBGNeuron;

@interface PBGWeightedConnection : NSObject {
	PBGNeuron		*inputNeuron;
	double			weight;
	BOOL			canBeAdjusted;
}

- (id)initWithInput:(PBGNeuron *)newInput weight:(double)newWeight adjustable:(BOOL)adjustableValue;
- (double)outputValue;
- (PBGNeuron *)inputNeuron;
- (double)weight;
- (void)setWeight:(double)newWeight;

@end
