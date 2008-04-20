#import <Foundation/Foundation.h>
#import "PBGNeuralNetwork.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// Create our neural network
	int inputSize = 2;
	PBGNeuralNetwork *neuralNet = [[PBGNeuralNetwork alloc] initWithInputs:inputSize outputs:1 hiddenLayers:1];
	
	NSMutableArray *zeroZeroArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[zeroZeroArray addObject:[NSNumber numberWithDouble:0.000001]];
	[zeroZeroArray addObject:[NSNumber numberWithDouble:0.000001]];
	NSMutableArray *zeroOneArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[zeroOneArray addObject:[NSNumber numberWithDouble:0.000001]];
	[zeroOneArray addObject:[NSNumber numberWithDouble:0.999999]];
	NSMutableArray *oneZeroArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[oneZeroArray addObject:[NSNumber numberWithDouble:0.999999]];
	[oneZeroArray addObject:[NSNumber numberWithDouble:0.000001]];
	NSMutableArray *oneOneArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[oneOneArray addObject:[NSNumber numberWithDouble:0.999999]];
	[oneOneArray addObject:[NSNumber numberWithDouble:0.999999]];
	 
	double sumSquaredError = 100;
	int i = 1;
	
	double error1, error2, error3, error4;
	
	[neuralNet printDescription];
	
	while (sumSquaredError > 0.01) {
		[neuralNet setStartingValues:zeroZeroArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithDouble:0.000001]]];
		double foo1 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error1 = 0.000001 - foo1;
		
		[neuralNet setStartingValues:zeroOneArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithDouble:0.999999]]];
		double foo2 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error2 = 0.999999 - foo2;
		
		[neuralNet setStartingValues:oneZeroArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithDouble:0.999999]]];
		double foo3 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error3 = 0.999999 - foo3;
		
		[neuralNet setStartingValues:oneOneArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithDouble:0.000001]]];
		double foo4 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error4 = 0.000001 - foo4;
		
		i++;
		
		if (i % 1000 == 0) {
			sumSquaredError = pow(error1, 2) + pow(error2, 2) + pow(error3, 2) + pow(error4, 2);
			NSLog(@"Sum Squared Error at epoch %d: %f", i, sumSquaredError);
		}
		
		
		if (i % 100000 == 0) {
			
			[neuralNet printDescription];
			
			[neuralNet setStartingValues:zeroZeroArray];
			NSLog(@"Output for 0, 0: %@", [neuralNet outputValuesString]);
			
			[neuralNet setStartingValues:zeroOneArray];
			NSLog(@"Output for 0, 1: %@", [neuralNet outputValuesString]);
			
			[neuralNet setStartingValues:oneZeroArray];
			NSLog(@"Output for 1, 0: %@", [neuralNet outputValuesString]);
			
			[neuralNet setStartingValues:oneOneArray];
			NSLog(@"Output for 1, 1: %@", [neuralNet outputValuesString]);
		}			
		
	}

	[neuralNet setStartingValues:zeroZeroArray];
	NSLog(@"Output for 0, 0: %@", [neuralNet outputValuesString]);
	
	[neuralNet setStartingValues:zeroOneArray];
	NSLog(@"Output for 0, 1: %@", [neuralNet outputValuesString]);
	
	[neuralNet setStartingValues:oneZeroArray];
	NSLog(@"Output for 1, 0: %@", [neuralNet outputValuesString]);
	
	[neuralNet setStartingValues:oneOneArray];
	NSLog(@"Output for 1, 1: %@", [neuralNet outputValuesString]);

	[neuralNet printDescription];
	
    [pool drain];
    return 0;
}
