//
//  PitchShifter.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/18/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "PitchShifter.h"
#import "PitchShiftIterative.h"

PitchShiftIterative *pitchShiftIterator;
float progressStatus;
float numStages, currentStage;
float currentProgress = 0.0;

@implementation PitchShifter
-(float) getProgressStatus {

    currentProgress = (currentStage-1)/numStages;
    currentProgress += 1/numStages*pitchShiftIterator->getSmbPitchShiftProgress();
    
    return currentProgress;
}

-(void) stopPitchShifting {
    if (pitchShiftIterator) {
        shouldStopPitchShifting = true;
        pitchShiftIterator->stop_pitch_shifting();
    }
    else {
        printf("smbPitchShifter not found for stopping its action");
    }
}


-(void) pitchShiftWavFile:(char*) wavFilePath andOutFilePath:(char*) outWavFilePath andShiftType:(int)shiftType {
    
    shouldStopPitchShifting = false;
    
    NSLog(@"Initializing shifting algorithm");
    pitchShiftIterator = PitchShiftIterative::getInstance();
    
    pitchShiftIterator->get_info(wavFilePath);
    
    int *i_original_wave_array;
    int *i_third_up_wave_array;
    int *i_fifth_up_wave_array;
    int *i_summed_triads_array;
    
    int error;

    NSLog(@"[1/5] Allocating space for wave arrays");
    i_original_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_third_up_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_fifth_up_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_summed_triads_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    
    NSLog(@"[2/5] Converting from wave to array");
    pitchShiftIterator->wave_to_array(wavFilePath, i_original_wave_array);
    
    switch (shiftType) {
            
        case SHIFT_THIRD:
            
            numStages = 1.0;
            
            NSLog(@"[3/5] Generating third up");
            currentStage = 1.0;
            error = pitchShiftIterator->pitch_shift(i_original_wave_array, i_third_up_wave_array, THIRD_UP);
            if (error == -1) {
                NSLog(@"Pitch shifting process terminated by user at stage %f",currentStage);
                return;
            }
            
            NSLog(@"[4/5] Summing the waves");
            pitchShiftIterator->sum_two_waves(i_original_wave_array, i_third_up_wave_array, i_summed_triads_array);
            break;
            
        case SHIFT_FIFTH:
            
            numStages = 1.0;
            
            NSLog(@"[3/5] Generating fifth up");
            currentStage = 1.0;
            error = pitchShiftIterator->pitch_shift(i_original_wave_array, i_fifth_up_wave_array, FIFTH_UP);
            if (error != 0) {
                NSLog(@"Pitch shifting process terminated by user at stage %f",currentStage);
                return;
            }
            
            NSLog(@"[4/5] Summing the waves");
            pitchShiftIterator->sum_two_waves(i_original_wave_array, i_fifth_up_wave_array, i_summed_triads_array);
            break;
            
        case SHIFT_TRIAD:
            
            numStages = 2.0;
            
            NSLog(@"[3/5] Generating thirds and fifths up");
            currentStage = 1.0;
            error = pitchShiftIterator->pitch_shift(i_original_wave_array, i_third_up_wave_array, THIRD_UP);
            if (error != 0) {
                NSLog(@"Pitch shifting process terminated by user at stage %f",currentStage);
                return;
            }
            currentStage = 2.0;
            error = pitchShiftIterator->pitch_shift(i_original_wave_array, i_fifth_up_wave_array, FIFTH_UP);
            if (error != 0) {
                NSLog(@"Pitch shifting process terminated by user at stage %f",currentStage);
                return;
            }
            
            NSLog(@"[4/5] Summing all three waves");
            pitchShiftIterator->sum_three_waves(i_original_wave_array, i_third_up_wave_array, i_fifth_up_wave_array, i_summed_triads_array);
            break;
            
    }
    
    free(i_original_wave_array);
    free(i_third_up_wave_array);
    free(i_fifth_up_wave_array);
    
    NSLog(@"[5/5] Writing wav file");
    pitchShiftIterator->array_to_wave(outWavFilePath, i_summed_triads_array);

    free(i_summed_triads_array);
    
    //delete(pitchShiftIterator);
    
     NSLog(@"*** SUCCESS! Ready to reproduce wav ***");
}
@end
