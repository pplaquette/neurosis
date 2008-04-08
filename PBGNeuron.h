//
//  PBGNeuron.h
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PBGWeightedConnection.h"
#import <math.h>

enum PBGActivationFunction	{
	PBGSignFunction,
	PBGStepFunction,
	PBGSigmoidFunction,
	PBGLinearFunction
};

@interface PBGNeuron : NSObject {
	int							neuronID;

	NSMutableArray				*inputConnectionsArray;
	int							value;
	BOOL						valueWasExplicitlySet; // Used in order to create "Dummy" Neurons for the input layer.
	double						threshold;
	enum PBGActivationFunction	activationFunction;
}

- (id)initWithID:(int)i;

- (double)outputValue;
- (void)addInputConnection:(PBGWeightedConnection *)connection;
- (PBGWeightedConnection *)connectionToNeuron:(PBGNeuron *)neuron;
- (void)setValue:(double)newValue;
- (NSMutableArray *)inputConnectionsArray;

@end
