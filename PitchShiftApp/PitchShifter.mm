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

-(void) pitchShiftWavFile {
    NSLog(@"Initializing shifting algorithm");
    PitchShiftIterative *pitchShiftIterator = PitchShiftIterative::getInstance();
    
    char* c_in_file = "sax.wav";
    //TODO: convert the given wavFileName to c_in_file
    pitchShiftIterator->get_info(c_in_file);
    
    int *i_original_wave_array;
    int *i_third_up_wave_array;
    int *i_fifth_up_wave_array;
    int *i_summed_triads_array;

    NSLog(@"Allocating space for wave arrays");
    i_original_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_third_up_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_fifth_up_wave_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    i_summed_triads_array = (int *) malloc(pitchShiftIterator->i_wave_num_of_itens*sizeof(int));
    
    // Converts from wave to array
    NSLog(@"Converting from wave to array");
    pitchShiftIterator->wave_to_array(c_in_file, i_original_wave_array);
    
    // Generates thirds and fifths up
    NSLog(@"Generating thirds and fifths up");
    pitchShiftIterator->pitch_shift(i_original_wave_array, i_third_up_wave_array, THIRD_UP);
    pitchShiftIterator->pitch_shift(i_original_wave_array, i_fifth_up_wave_array, FIFTH_UP);
    
    // Sums all three waves
    NSLog(@"Summing all three waves");
    pitchShiftIterator->sum_three_waves(i_original_wave_array, i_third_up_wave_array, i_fifth_up_wave_array, i_summed_triads_array);
    
    // Writes the wav file for the triads
    NSLog(@"Writing wav file");
    char* c_out_file_name = "triad.wav";
    pitchShiftIterator->array_to_wave(c_out_file_name, i_summed_triads_array);
}
@end
