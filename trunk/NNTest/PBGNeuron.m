//
//  PBGNeuron.m
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 Patrick B. Gibson. All rights reserved.
//

#import "PBGNeuron.h"
#include <stdlib.h>

@interface PBGNeuron (Private)
- (double)evaluate;
@end

@implementation PBGNeuron

- (id)initWithID:(int)i networkSize:(int)netSize threshold:(BOOL)t
{
	self = [super init];
	if (self != nil) {
		neuronID = i;
		inputConnectionsArray = [[NSMutableArray alloc] initWithCapacity:3];
		double high = 2.4 / netSize;
		double low = -2.4 / netSize;
		
		value = 0;
		valueWasExplicitlySet = NO;
		
		errorGradient = 0;
		
		usingThreshold = t;
		if (usingThreshold)
			threshold = (rand() / ( (double) (RAND_MAX) + 1.0)) * (high - low) + low;
		else
			threshold = 0;
		
		activationFunction = PBGSigmoidFunction;
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
	return [NSString stringWithFormat:@"(%d)", neuronID];
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

- (void)setThreshold:(double)t
{
	threshold = t;
}

- (double)threshold
{
	return threshold;
}

- (NSMutableArray *)inputConnectionsArray
{
	return inputConnectionsArray;
}

- (void)setNewThreshold:(double)t
{
	newThreshold = t;
}

- (void)updateNow
{
	if (DEBUG_LOGGING)
		NSLog(@"%@ Updating...", self);
		
	[self setThreshold:newThreshold];
	
	for (PBGWeightedConnection *connection in inputConnectionsArray) {
		[connection updateNow];
	}
}

- (double)errorGradientUsingExpectedOutput:(double)expectedOutput
{
	double errorDelta = expectedOutput - value;
	errorGradient = value * (1 - value) * errorDelta;	
	return errorGradient;
}

- (double)errorGradient
{
	return errorGradient;
}

- (void)setErrorGradient:(double)e
{
	errorGradient = e;
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
	
	if (usingThreshold)
		sigma = sigma + (-1 * threshold);
	
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
			value = 1/(1+exp(-sigma));
			break;
			
		case PBGLinearFunction:
			value = sigma;
			break;
	}
	
	if (DEBUG_LOGGING)
		NSLog(@"Neuron %@ is returning value of %f", self, value);
	
	return value;
}

@end
