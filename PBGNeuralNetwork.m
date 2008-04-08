//
//  PBGNeuralNetwork.m
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "PBGNeuralNetwork.h"
#import "PBGNeuron.h"
#import "PBGWeightedConnection.h"

@implementation PBGNeuralNetwork

- (id)initWithInputs:(int)inputCount outputs:(int)outputCount hiddenLayers:(int)hiddenLayersCount;
{
	self = [super init];
	if (self != nil) {
		neuronCounter = 0;
		learningRate = 0.1;
		srand( time(NULL) );
		
		int i, j; // Counters for various looping
	
		// Create the input layer
		inputsArray = [[NSMutableArray alloc] initWithCapacity:inputCount];
		for (i = 0; i < inputCount; i++){
			PBGNeuron *newNeuron = [[PBGNeuron alloc] initWithID:neuronCounter++];
			[inputsArray addObject:newNeuron];
		}
		
		// ----------------------------------------------------------------
	
		// Create the hidden layers, assume their size to be equal to that of the input layer.
		hiddenLayersArray = [[NSMutableArray alloc] initWithCapacity:hiddenLayersCount];
		
		// Set our first "previous layer" to be the input array
		NSMutableArray *previousLayerArray = inputsArray;
		
		for (i = 0; i < hiddenLayersCount; i++){
			NSMutableArray *newHiddenLayer = [[NSMutableArray alloc] initWithCapacity:inputCount];
			
			// After creating the new hidden layer, fill it with neurons, connecting each neuron to every input neuron.
			for (j = 0; j < inputCount; j++){
				PBGNeuron *newNeuron = [[PBGNeuron alloc] initWithID:neuronCounter++];
				
				for (PBGNeuron *inputNeuron in previousLayerArray) {
					PBGWeightedConnection *connection;
					
					// Generate random weighting
					double weight = (double) rand() / RAND_MAX;
					
					connection = [[PBGWeightedConnection alloc] initWithInput:inputNeuron
																	   weight:weight
																   adjustable:YES];
										
					NSLog(@"Adding connection %@ to neuron %@", connection, newNeuron);
					[newNeuron addInputConnection:connection];
				} // Finish adding connections to new neuron
				
				[newHiddenLayer addObject:newNeuron];
			} // Finish adding neurons to the new layer
			
			// Move our "previous layer" up so all the neurons in the next layer connect to this one.
			previousLayerArray = newHiddenLayer;
		
		} // Finish creation of the hidden layers
		
		// ----------------------------------------------------------------
		
		// Create our final output layer
		outputsArray = [[NSMutableArray alloc] initWithCapacity:outputCount];
		for (i = 0; i < outputCount; i++){
			PBGNeuron *newNeuron = [[PBGNeuron alloc] initWithID:neuronCounter++];
			
			for (PBGNeuron *inputNeuron in previousLayerArray) {
					PBGWeightedConnection *connection;
					
					// Generate random weighting
					double weight = (double) rand() / RAND_MAX;
					
					connection = [[PBGWeightedConnection alloc] initWithInput:inputNeuron
																	   weight:weight
																   adjustable:YES];
					NSLog(@"Adding connection %@ to neuron %@", connection, newNeuron);
					[newNeuron addInputConnection:connection];
				} // Finish adding connections to new neuron
			
			[outputsArray addObject:newNeuron];
		} // Finish creating the output layer
		
		
	} // End creation of self
	return self;
}

- (void)setStartingValues:(NSArray *)values
{
	// Clear all values to zero. We need this in case there are fewer given values than there are inputs.
	for (PBGNeuron *neuron in inputsArray){
		[neuron setValue:0];
	}

	// Set each neuron to it's given value, in order.
	int counter = 0;
	for (NSNumber *value in values) {
		[(PBGNeuron *)[inputsArray objectAtIndex:counter] setValue:(int)[value intValue]];
		counter++;
	}
}

- (void)learnFromExpectedOutputs:(NSArray *)expectedOutputs
{
	NSArray * actualOutputs = [self computeOutputValues];
	int i = 0;
	
	// Output layer
	for (PBGNeuron *currentNeuron in outputsArray){
	
		// Calculate the error gradient for the neurons in the output layer
		double currentValue = [currentNeuron outputValue];
		double expectedValue = [[expectedOutputs objectAtIndex:i++] doubleValue];
		NSLog(@"For neuron %@, value was %f but expected %f", currentNeuron, currentValue, expectedValue);
		double errorGradient = currentValue * (1 - currentValue) * (expectedValue - currentValue);
		
		// Calculate the weight corrections
		for (PBGWeightedConnection *connection in [currentNeuron inputConnectionsArray]){
			double errorDelta = learningRate * currentValue * errorGradient;
			double newWeight = [connection weight] + errorDelta;
			NSLog(@"Updating connection %@ to %f from %f", connection, newWeight, [connection weight]);
			// Update the weights going to the output neurons
			[connection setWeight:newWeight];
		}
	}	
	
	NSArray *nextArrayForwards = outputsArray;
	int j = 0;
	
	for (j = [hiddenLayersArray count] - 1; j >= 0; j--){
		NSMutableArray *hiddenLayer = [hiddenLayersArray objectAtIndex:j];
		
		if (j > 0) {
			NSMutableArray *nextLayerBackwards = [hiddenLayersArray objectAtIndex:j-1];
		} else {
			NSMutableArray *nextLayerBackwards = inputsArray;
		}
		
		for (PBGNeuron *currentNeuron in hiddenLayer){
		
			double currentValue = [currentNeuron outputValue];
			double sigmaOfWeights = 0;
			i = 0;

			for (i = 0; i < [nextArrayForwards count]; i++){
				PBGNeuron *neuronToCheck = [nextArrayForwards objectAtIndex:i];
				double neuronToCheckOutputValue = [neuronToCheck outputValue];
				double checkingErrorDelta = ((neuronToCheckOutputValue * (1 - neuronToCheckOutputValue)) * [[expectedOutputs objectAtIndex:i] doubleValue]);
				sigmaOfWeights = sigmaOfWeights + (checkingErrorDelta * [[neuronToCheck connectionToNeuron:currentNeuron] outputValue]);
			}
			
			// Calculate the error gradient for the neurons in the hidden layer
			double errorGradient = currentValue * (1 - currentValue) * sigmaOfWeights;
	
			// Calculate the weight corrections
			for (PBGWeightedConnection *connection in [currentNeuron inputConnectionsArray]){
				double inputSignal = [[connection inputNeuron] outputValue];
				double errorDelta = learningRate * inputSignal * errorGradient;
				double newWeight = [connection weight] + errorDelta;
				// Update the weights going to the output neurons
				[connection setWeight:newWeight];
			}
			
		}
		
		nextArrayForwards = hiddenLayer;
	}
}

- (NSArray *)computeOutputValues
{
	NSMutableArray *computedOutputValues = [[NSMutableArray alloc] initWithCapacity:[outputsArray count]];
	for (PBGNeuron *outputNeuron in outputsArray) {
		[computedOutputValues addObject:[NSNumber numberWithInt:[outputNeuron outputValue]]];
	}
	
	NSLog(@"Output values will be: %@", computedOutputValues);
	
	return [computedOutputValues copy];
}

- (NSString *)outputValuesString
{
	NSArray *outputs = [self computeOutputValues];
	NSMutableString *returnString = [[NSMutableString alloc] initWithString:@""];
	
	for (NSNumber *output in outputs){
		[returnString appendString:[NSString stringWithFormat:@"%@, ", output]];
	}
	
	NSRange range = NSMakeRange([returnString length] - 2, 2);
	
	
	[returnString deleteCharactersInRange:range];
	[outputs release];
	return returnString;
}

@end

