//
//  PitchShifter.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/18/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "PitchShifter.h"
#import "PitchShiftIterative.h"

@implementation PitchShifter

-(void) pitchShiftWavFile:(char*) wavFilePath andOutFilePath:(char*) outWavFilePath {
    NSLog(@"Initializing shifting algorithm");
    PitchShiftIterative *pitchShiftIterator = PitchShiftIterative::getInstance();
    
    pitchShiftIterator->get_info(wavFilePath);
    
    int *i_original_wave_array;
    int *i_third_up_wave_array;
    //int *i_fifth_up_wave_array;
    int *i_summed_triads_array;

    NSLog(@"Allocating space for wave arrays");
    i_original_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_third_up_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    //i_fifth_up_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_summed_triads_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    
    // Converts from wave to array
    NSLog(@"Converting from wave to array");
    pitchShiftIterator->wave_to_array(wavFilePath, i_original_wave_array);
    
    // Generates thirds and fifths up
    NSLog(@"Generating thirds and fifths up");
    pitchShiftIterator->pitch_shift(i_original_wave_array, i_third_up_wave_array, THIRD_UP);
    //pitchShiftIterator->pitch_shift(i_original_wave_array, i_fifth_up_wave_array, FIFTH_UP);
    
    // Sums all three waves
    NSLog(@"Summing all three waves");
    //pitchShiftIterator->sum_three_waves(i_original_wave_array, i_third_up_wave_array, i_fifth_up_wave_array, i_summed_triads_array);
    pitchShiftIterator->sum_two_waves(i_original_wave_array, i_third_up_wave_array, i_summed_triads_array);
    
    free(i_original_wave_array);
    free(i_third_up_wave_array);
    //free(i_fifth_up_wave_array);
    
    // Writes the wav file for the triads
    NSLog(@"Writing wav file");
    pitchShiftIterator->array_to_wave(outWavFilePath, i_summed_triads_array);
    //pitchShiftIterator->array_to_wave(outWavFilePath, i_original_wave_array);
    free(i_summed_triads_array);
}
@end
