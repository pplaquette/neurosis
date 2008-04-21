//
//  PBGNeuron.h
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 Patrick B. Gibson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGWeightedConnection.h"
#import <math.h>

enum PBGActivationFunction	{
	PBGSignFunction,
	PBGStepFunction,
	PBGSigmoidFunction,
	PBGSigmoidFunctionHyperbolic,
	PBGLinearFunction
};

@interface PBGNeuron : NSObject {
	int							neuronID;

	NSMutableArray				*inputConnectionsArray;
	
	double						value;
	BOOL						valueWasExplicitlySet; // Used in order to create "Dummy" Neurons for the input layer.
	
	BOOL						usingThreshold;
	double						threshold;
	double						newThreshold;
	
	double						errorGradient;
	
	enum PBGActivationFunction	activationFunction;
}

- (id)initWithID:(int)i networkSize:(int)netSize threshold:(BOOL)t;

- (double)outputValue;

- (double)errorGradientUsingExpectedOutput:(double)expectedOutput;
- (double)errorGradient;
- (void)setErrorGradient:(double)e;

- (void)addInputConnection:(PBGWeightedConnection *)connection;
- (PBGWeightedConnection *)connectionToNeuron:(PBGNeuron *)neuron;
- (void)setValue:(double)newValue;

- (void)setThreshold:(double)t;
- (double)threshold;

- (NSMutableArray *)inputConnectionsArray;

- (void)setNewThreshold:(double)t;
- (void)updateNow;

@end
