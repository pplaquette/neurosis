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
		double high = 2.4 / (inputCount * hiddenLayersCount + outputCount);
		double low = -2.4 / (inputCount * hiddenLayersCount + outputCount);
		
		int i, j; // Counters for various looping
	
		// Create the input layer
		inputsArray = [[NSMutableArray alloc] initWithCapacity:inputCount];
		for (i = 0; i < inputCount; i++){
			PBGNeuron *newNeuron = [[PBGNeuron alloc] initWithID:neuronCounter++ 
													 networkSize:(inputCount * hiddenLayersCount + outputCount)
													   threshold:NO];
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
				PBGNeuron *newNeuron = [[PBGNeuron alloc] initWithID:neuronCounter++ 
														 networkSize:(inputCount * hiddenLayersCount + outputCount)
														   threshold:YES];
				
				for (PBGNeuron *inputNeuron in previousLayerArray) {
					PBGWeightedConnection *connection;
					
					// Generate random weighting
					double weight = (rand() / ( (double) (RAND_MAX) + 1.0)) * (high - low) + low;
					
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
		
			[hiddenLayersArray addObject:newHiddenLayer]; // Uhh, this might be important, you frigtard.
		} // Finish creation of the hidden layers
		
		// ----------------------------------------------------------------
		
		// Create our final output layer
		outputsArray = [[NSMutableArray alloc] initWithCapacity:outputCount];
		for (i = 0; i < outputCount; i++){
			PBGNeuron *newNeuron = [[PBGNeuron alloc] initWithID:neuronCounter++ 
													 networkSize:(inputCount * hiddenLayersCount + outputCount)
													   threshold:YES];
			
			for (PBGNeuron *inputNeuron in previousLayerArray) {
					
					// Generate random weighting
					double weight = (rand() / ( (double) (RAND_MAX) + 1.0)) * (high - low) + low;
					
					PBGWeightedConnection *connection = [[PBGWeightedConnection alloc] initWithInput:inputNeuron
																	   weight:weight
																   adjustable:YES];
				
					NSLog(@"Adding connection %@ to neuron %@", connection, newNeuron);
				
					[newNeuron addInputConnection:connection];
				} // Finish adding connections to new neuron
			
			[outputsArray addObject:newNeuron];
		} // Finish creating the output layer
		
		[self printDescription];
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
		[(PBGNeuron *)[inputsArray objectAtIndex:counter] setValue:[value doubleValue]];
		counter++;
	}
}

- (void)learnFromExpectedOutputs:(NSArray *)expectedOutputs
{
	[self computeOutputValues];
	int i = 0;
	
	NSLog(@" ----- Starting ouput layers section ------ ");
	
	// ---------------- Output layer -----------------
	for (PBGNeuron *currentNeuron in outputsArray){
		
		double errorGradient = [currentNeuron errorGradientUsingExpectedOutput:[[expectedOutputs objectAtIndex:i++] doubleValue]];
				
		NSLog(@"Error gradient for %@ is %f", currentNeuron, errorGradient);
		
		// Calculate the weight corrections
		for (PBGWeightedConnection *connection in [currentNeuron inputConnectionsArray]){
			double conValue = [connection outputValue];
			double weightDelta = learningRate * conValue * errorGradient;
			double newWeight = [connection weight] + weightDelta;
			NSLog(@"Neuron %@ has connection from %@ with weight %f. Will apply weight delta %f.", 
				  currentNeuron, [connection inputNeuron], [connection weight], weightDelta);
			// Update the weights going to the output neurons
			[connection setNewWeight:newWeight];
		}
		
		double thresholdErrorDelta = learningRate * -1 * errorGradient;
		NSLog(@"Changing threshold in %@ from %f to %f", currentNeuron, [currentNeuron threshold], [currentNeuron threshold] + thresholdErrorDelta);
		[currentNeuron setNewThreshold:(thresholdErrorDelta + [currentNeuron threshold])];
	}	
	
	
	NSArray *nextArrayForwards = outputsArray;
	int j = 0;
	
	NSLog(@" ----- Starting hidden layers section ------ ");
	
	for (j = [hiddenLayersArray count]; j > 0; j--){
		
		NSMutableArray *hiddenLayer = [hiddenLayersArray objectAtIndex:(j-1)];
			
		for (PBGNeuron *currentNeuron in hiddenLayer){
			double sigmaOfWeights = 0;
			i = 0;
			for (i = 0; i < [nextArrayForwards count]; i++){
				PBGNeuron *neuronToCheck = [nextArrayForwards objectAtIndex:i];
				double errorGradientOfForwardNeuron = [neuronToCheck errorGradient];
				sigmaOfWeights += (errorGradientOfForwardNeuron * [[neuronToCheck connectionToNeuron:currentNeuron] weight]);
			}
			
			NSLog(@"sigma of weights: %f", sigmaOfWeights);
			
			double currentValue = [currentNeuron outputValue];
			double errorGradient = currentValue * (1 - currentValue) * sigmaOfWeights;
			
			[currentNeuron setErrorGradient:errorGradient];
			
			NSLog(@"Error gradient for %@ is %f", currentNeuron, errorGradient);
			
			// Calculate the weight corrections
			for (PBGWeightedConnection *connection in [currentNeuron inputConnectionsArray]){
				double errorDelta = learningRate * errorGradient * [connection outputValue];
				double newWeight = [connection weight] + errorDelta;
				NSLog(@"Neuron %@ has connection from %@ with weight %f. Will apply error delta %f.", 
					  currentNeuron, [connection inputNeuron], [connection weight], errorDelta);
				// Update the weights going to the output neurons
				[connection setNewWeight:newWeight];
			}
			
			double thresholdErrorDelta = learningRate * -1 * errorGradient;
			NSLog(@"Changing threshold in %@ from %f to %f", currentNeuron, [currentNeuron threshold], [currentNeuron threshold] + thresholdErrorDelta);
			[currentNeuron setNewThreshold:(thresholdErrorDelta + [currentNeuron threshold])];
		
		} // End each neuron in this layer
		
		nextArrayForwards = hiddenLayer;
	}
	
	[self printDescription];
	
	for (PBGNeuron *neuron in outputsArray) {
		[neuron updateNow];
	}
	
	double sigmaOfError = 0;
	int z = 0;
	
	for (PBGNeuron *neuron in outputsArray) {
		sigmaOfError += pow(([[expectedOutputs objectAtIndex:z++] doubleValue] - [neuron outputValue]), 2);
	}
	
	NSLog(@"Mean squared error: %f", sigmaOfError);
	
	//if (sigmaOfError > 0.25)
	//	[self learnFromExpectedOutputs:expectedOutputs];
	
}

- (NSArray *)computeOutputValues
{
	NSMutableArray *computedOutputValues = [[NSMutableArray alloc] initWithCapacity:[outputsArray count]];
	for (PBGNeuron *outputNeuron in outputsArray) {
		[computedOutputValues addObject:[NSNumber numberWithDouble:[outputNeuron outputValue]]];
	}
	
	NSLog(@"Output values will be: %@", computedOutputValues);
	
	return computedOutputValues;
}

- (NSString *)outputValuesString
{
	NSArray *outputs = [self computeOutputValues];
	NSMutableString *returnString = [[NSMutableString alloc] initWithString:@""];
	
	for (NSNumber *output in outputs){
		[returnString appendString:[NSString stringWithFormat:@"%f, ", [output doubleValue]]];
	}
	
	NSRange range = NSMakeRange([returnString length] - 2, 2);
		
	[returnString deleteCharactersInRange:range];
	[outputs release];
	
	return returnString;
}

- (void)printDescription
{
	NSLog(@"- Neural Network - ");
	NSLog(@"\tSize: %d", neuronCounter);
	NSLog(@"\tLearning Rate: %f", learningRate);
	NSLog(@"Input Layer:");
	for (PBGNeuron *n in inputsArray) {
		NSLog(@"\tNeuron %@", n);
		NSLog(@"\t\tThreshold:");
		NSLog(@"\t\t\t%f", [n threshold]);
		NSLog(@"\t\tConnections:", n);
		for (PBGWeightedConnection *con in [n inputConnectionsArray]) {
				NSLog(@"\t\t\t%@", con);
		}
	}
	NSLog(@"Hidden Layer:");
	for (NSArray *a in hiddenLayersArray) {
		for (PBGNeuron *n in a) {
			NSLog(@"\tNeuron %@", n);
			NSLog(@"\t\tThreshold:");
			NSLog(@"\t\t\t%f", [n threshold]);
			NSLog(@"\t\tConnections:");
			for (PBGWeightedConnection *con in [n inputConnectionsArray]) {
				NSLog(@"\t\t\t%@", con);
			}
		}
	}
	NSLog(@"Outputs Layer:");
	for (PBGNeuron *n in outputsArray) {
		NSLog(@"\tNeuron %@", n);
		NSLog(@"\t\tThreshold:");
		NSLog(@"\t\t\t%f", [n threshold]);
		NSLog(@"\t\tConnections:", n);
		for (PBGWeightedConnection *con in [n inputConnectionsArray]) {
			NSLog(@"\t\t\t%@", con);
		}
	}
}

@end

