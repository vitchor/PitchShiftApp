//
//  PitchShifter.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/18/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SHIFT_THIRD 1
#define SHIFT_FIFTH 2
#define SHIFT_TRIAD 3

@interface PitchShifter : NSObject {

    bool shouldStopPitchShifting;
    
}

-(void) pitchShiftWavFile:(char*) wavFilePath andOutFilePath:(char*) outWavFilePath andShiftType:(int) shiftType;
-(float) getProgressStatus;
-(void) stopPitchShifting;

@end
