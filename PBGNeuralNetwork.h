//
//  PBGNeuralNetwork.h
//  neurosis
//
//  Created by Patrick B. Gibson on 27/10/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PBGNeuralNetwork : NSObject {
	int				neuronCounter;
	float			learningRate;

	NSMutableArray	*hiddenLayersArray;
	NSMutableArray	*inputsArray;
	NSMutableArray	*outputsArray;
}

// Designated Initializer. For now, hidden layers are assumed to be the same size as the input layer.
- (id)initWithInputs:(int)inputCount outputs:(int)outputCount hiddenLayers:(int)hiddenLayersCount;

- (void)setStartingValues:(NSArray *)values;
- (void)learnFromExpectedOutputs:(NSArray *)expectedOutputs;

- (NSArray *)computeOutputValues;
- (NSString *)outputValuesString;

@end
