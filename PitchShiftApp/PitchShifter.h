//
//  PitchShifter.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/18/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PitchShifter : NSObject
-(void) pitchShiftWavFile:(char*) wavFilePath andOutFilePath:(char*) outWavFilePath;
-(float) getProgressStatus;
@end
