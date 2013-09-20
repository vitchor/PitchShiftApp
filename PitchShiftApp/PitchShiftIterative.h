//
//  PitchShiftIterative.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/17/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#ifndef __PitchShiftApp__PitchShiftIterative__
#define __PitchShiftApp__PitchShiftIterative__

// Basic C/C++ libs needed for this program
// Additional libs required
#include "SmbPitchShifter.h"
#include "sndfile.h"
#include "pthread.h"

// Music frequencies definitions
#define THIRD_UP 1.259921
#define OCTAVE_UP 2.0
#define FIFTH_UP 1.5

using namespace std;

class PitchShiftIterative {
    
    public:
        static PitchShiftIterative *getInstance();
        void get_info(char* c_in_wav_file_name);
        void wave_to_array(char* c_in_wav_file_name, int* i_out_wave_array);
        void pitch_shift(int* i_in_wave_array, int* i_out_wave_array, float f_ratio_shift);
        void array_to_wave(char* c_out_wav_file_name, int* i_in_wave_array);
        void sum_two_waves(int* i_in_first_wave_array, int* i_in_second_wave_array, int* i_out_result_wave_array);
        void sum_three_waves(int* i_in_first_wave_array, int* i_in_second_wave_array, int* i_in_third_wave_array, int* i_out_result_wave_array);
        virtual ~PitchShiftIterative();
        float getSmbPitchShiftProgress();
    
        // GLOBAL VARIABLES:
        int i_num_channels, i_wave_length, i_wave_num_of_itens;
        int i_wave_frames, i_wave_sample_rate, i_wave_channels;
    
    private:
        static PitchShiftIterative *instance;
        SmbPitchShifter *smbPitchShifter;

    protected:
        PitchShiftIterative();
    
};


#endif /* defined(__PitchShiftApp__PitchShiftIterative__) */
