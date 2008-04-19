//
//  PBGWeightedConnection.m
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "PBGWeightedConnection.h"

@implementation PBGWeightedConnection

- (id)initWithInput:(PBGNeuron *)newInput weight:(double)w adjustable:(BOOL)adjustableValue
{
	self = [super init];
	if (self != nil) {
		weight = w;
		inputNeuron = [newInput retain];
		canBeAdjusted = adjustableValue;
	}
	return self;
}

- (double)outputValue
{
	return (double) ([inputNeuron outputValue] * weight);
}

- (PBGNeuron *)inputNeuron
{
	return inputNeuron;
}

- (double)weight
{
	return weight;
}

- (void)setWeight:(double)w
{
	weight = w;
}

- (void)setNewWeight:(double)w
{
	newWeight = w;
}

- (void)updateNow
{
	NSLog(@"Updating %@ to %f", self, newWeight);
	weight = newWeight;
	[inputNeuron updateNow];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ - %f ->", inputNeuron, weight];
}

- (void) dealloc
{
	[inputNeuron release];
	[super dealloc];
}

@end
