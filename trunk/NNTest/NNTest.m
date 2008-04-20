#import <Foundation/Foundation.h>
#import "PBGNeuralNetwork.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// Create our neural network
	int inputSize = 2;
	PBGNeuralNetwork *neuralNet = [[PBGNeuralNetwork alloc] initWithInputs:inputSize outputs:1 hiddenLayers:1];
	
	NSMutableArray *zeroZeroArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[zeroZeroArray addObject:[NSNumber numberWithInt:0]];
	[zeroZeroArray addObject:[NSNumber numberWithInt:0]];
	NSMutableArray *zeroOneArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[zeroOneArray addObject:[NSNumber numberWithInt:0]];
	[zeroOneArray addObject:[NSNumber numberWithInt:1]];
	NSMutableArray *oneZeroArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[oneZeroArray addObject:[NSNumber numberWithInt:1]];
	[oneZeroArray addObject:[NSNumber numberWithInt:0]];
	NSMutableArray *oneOneArray = [[NSMutableArray alloc] initWithCapacity:inputSize];
	[oneOneArray addObject:[NSNumber numberWithInt:1]];
	[oneOneArray addObject:[NSNumber numberWithInt:1]];
	 
	double sumSquaredError = 100;
	int i = 1;
	
	double error1, error2, error3, error4;
	
	[neuralNet printDescription];
	
	while (sumSquaredError > 0.01) {
		[neuralNet setStartingValues:zeroZeroArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
		double foo1 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error1 = 0 - foo1;
		
		[neuralNet setStartingValues:zeroOneArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
		double foo2 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error2 = 1 - foo2;
		
		[neuralNet setStartingValues:oneZeroArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
		double foo3 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error3 = 1 - foo3;
		
		[neuralNet setStartingValues:oneOneArray];
		[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
		double foo4 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
		error4 = 0 - foo4;
		
		sumSquaredError = pow(error1, 2) + pow(error2, 2) + pow(error3, 2) + pow(error4, 2);
		
		NSLog(@"Sum Squared Error at epoch %d: %f", i++, sumSquaredError);
		
		if (i % 2000 == 0) {
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
	/*
	
	double _sumSquaredError = 100;
	int j = 1;
	
	while (_sumSquaredError > 0.001) {
		
		sumSquaredError = 100;
		while (sumSquaredError > 0.001) {
			[neuralNet setStartingValues:zeroZeroArray];
			[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
			double foo1 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
			error1 = 0 - foo1;
			
			sumSquaredError = pow(error1, 2);
			
			NSLog(@"Sum Squared Error at epoch %d: %f", i++, sumSquaredError);
		}
		
		sumSquaredError = 100;
		while (sumSquaredError > 0.001) {
			[neuralNet setStartingValues:zeroOneArray];
			[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
			double foo2 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
			error2 = 0 - foo2;
			
			sumSquaredError = pow(error2, 2);
			
			NSLog(@"Sum Squared Error at epoch %d: %f", i++, sumSquaredError);
		}
		
		sumSquaredError = 100;
		while (sumSquaredError > 0.001) {
			[neuralNet setStartingValues:oneZeroArray];
			[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:1]]];
			double foo3 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
			error3 = 0 - foo3;
			
			sumSquaredError = pow(error3, 2);
			
			NSLog(@"Sum Squared Error at epoch %d: %f", i++, sumSquaredError);
		}
		
		sumSquaredError = 100;
		while (sumSquaredError > 0.001) {
			[neuralNet setStartingValues:oneOneArray];
			[neuralNet learnFromExpectedOutputs:[NSArray arrayWithObject:[NSNumber numberWithInt:0]]];
			double foo4 = [[[neuralNet computeOutputValues] objectAtIndex:0] doubleValue];
			error4 = 0 - foo4;
			
			sumSquaredError = pow(error4, 2);
			
			NSLog(@"Sum Squared Error at epoch %d: %f", i++, sumSquaredError);
		}
		
		_sumSquaredError = pow(error1, 2) + pow(error2, 2) + pow(error3, 2) + pow(error4, 2);
		NSLog(@"Sum Squared Error at epoch %d: %f", j++, sumSquaredError);
	}
	*/
	[neuralNet setStartingValues:zeroZeroArray];
	NSLog(@"Output for 0, 0: %@", [neuralNet outputValuesString]);
	
	[neuralNet setStartingValues:zeroOneArray];
	NSLog(@"Output for 0, 1: %@", [neuralNet outputValuesString]);
	
	[neuralNet setStartingValues:oneZeroArray];
	NSLog(@"Output for 1, 0: %@", [neuralNet outputValuesString]);
	
	[neuralNet setStartingValues:oneOneArray];
	NSLog(@"Output for 1, 1: %@", [neuralNet outputValuesString]);

    [pool drain];
    return 0;
}
