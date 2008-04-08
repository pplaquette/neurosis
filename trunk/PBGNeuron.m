//
//  PBGNeuron.m
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "PBGNeuron.h"

@interface PBGNeuron (Private)
- (double)evaluate;
@end

@implementation PBGNeuron

- (id)initWithID:(int)i
{
	self = [super init];
	if (self != nil) {
		neuronID = i;
		inputConnectionsArray = [[NSMutableArray alloc] initWithCapacity:3];
		value = 0;
		valueWasExplicitlySet = NO;
		threshold = 0.5;
		activationFunction = PBGStepFunction;
	}
	return self;
}

- (double)outputValue
{
	if (valueWasExplicitlySet) { 
		return value;
	} else {
		return [self evaluate];
	}
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%d", neuronID];
}

- (void)addInputConnection:(PBGWeightedConnection *)connection
{
	[inputConnectionsArray addObject:connection];
}

- (PBGWeightedConnection *)connectionToNeuron:(PBGNeuron *)neuron
{
	for (PBGWeightedConnection *connection in inputConnectionsArray){
		if ([connection inputNeuron] == neuron){
			return connection;
		}
	}
	return nil;
}

- (void)setValue:(double)newValue
{
	valueWasExplicitlySet = YES;
	value = newValue;
}

- (void)dealloc
{
	[inputConnectionsArray release];
	[super dealloc];
}

@end

@implementation PBGNeuron (Private)
- (double)evaluate
{
	double sigma = 0;
	for (PBGWeightedConnection *connection in inputConnectionsArray) {
		sigma += [connection outputValue];
	}
	
	sigma = sigma - threshold;
	
	switch (activationFunction) {
		default:
		case PBGSignFunction:
			if (sigma >= 0) {
				value = 1;
			} else {
				value = -1;
			}
			break;
			
		case PBGStepFunction:
			if (sigma >= 0) {
				value = 1;
			} else {
				value = 0;
			}
			break;
			
		case PBGSigmoidFunction:
			value = 1/(1+exp(0-sigma));
			break;
			
		case PBGLinearFunction:
			value = sigma;
			break;
	}
	
	return value;
}

- (NSMutableArray *)inputConnectionsArray
{
	return inputConnectionsArray;
}

@end
