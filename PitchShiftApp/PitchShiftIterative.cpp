//
//  PitchShiftIterative.cpp
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/17/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//
// ------------------------------------------------------------------------------
// Compile me with:
//  $ g++ pitch_shift.cpp -o pitch_shift -lsndfile
//
// NOTE: to install libsndfile on mac, use:
//  $ sudo port install libsndfile
// ------------------------------------------------------------------------------
// CODE START
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <cmath>
#include <algorithm>
#include <cstring>
#include <iostream>

#include "PitchShiftIterative.h"
using namespace std;

#pragma region "Singleton pattern"

PitchShiftIterative *PitchShiftIterative::instance;
PitchShiftIterative::PitchShiftIterative() {
    smbPitchShifter = new SmbPitchShifter();
}
PitchShiftIterative *PitchShiftIterative::getInstance() {
    if (!instance) {
		instance = new PitchShiftIterative();
	}
	return instance;
}
PitchShiftIterative::~PitchShiftIterative() {
    //delete smbPitchShifter;
}

#pragma region "PitchShift Functions Implementation"

float PitchShiftIterative::getSmbPitchShiftProgress() {
    return smbPitchShifter->getProgress();
    //return 2.0;
}

void PitchShiftIterative::stop_pitch_shifting() {
    if (smbPitchShifter) {
        smbPitchShifter->stopPitchShifting();
    }
    else {
        printf("smbPitchShifter not found for stopping its action");
    }
}


void PitchShiftIterative::get_info(char* c_in_wav_file_name) {
    SNDFILE *m_wave_file;
    SF_INFO m_wave_info;
    int i_err_code;
    
    // Opens wav file:
    m_wave_info.format = 0;
    m_wave_file = sf_open(c_in_wav_file_name,SFM_READ,&m_wave_info);
    
    i_err_code = sf_error(m_wave_file);
    
    if (i_err_code == SF_ERR_NO_ERROR) {
        printf("Opened WAV file to gather info successfully.\n");
    } else {
        printf("SNDFILE ERROR: %s\n", sf_error_number(i_err_code));
        return;
    }

    
    // Gathers information from wav file:
    i_wave_frames = m_wave_info.frames;
    i_wave_sample_rate = m_wave_info.samplerate;
    i_wave_channels = m_wave_info.channels;
    i_wave_num_of_itens = i_wave_frames*i_wave_channels;
    
    printf("Info gathered from WAV file: \n Sample rate: %d\nNumber of Channels: %d\n", i_wave_sample_rate, i_wave_channels);
    
    sf_close(m_wave_file);
}

void PitchShiftIterative::wave_to_array(char* c_in_wav_file_name, int* i_out_wave_array) {
    printf("File name i got: %s\n", c_in_wav_file_name);
    
    SNDFILE *m_wave_file;
    SF_INFO m_wave_info;
    int i_err_code;
    
    // Opens wave file
    m_wave_info.format = 0;
    m_wave_file = sf_open(c_in_wav_file_name,SFM_READ,&m_wave_info);
    
    i_err_code = sf_error(m_wave_file);
    
    if (i_err_code == SF_ERR_NO_ERROR) {
        printf("Opened WAV file to read successfully.\n");
    } else {
        printf("SNDFILE ERROR: %s\n", sf_error_number(i_err_code));
        return;
    }

    
    // Writes on integer range the wave to i_out_wave_array
    i_wave_length = sf_read_int(m_wave_file,i_out_wave_array,i_wave_num_of_itens);
    sf_close(m_wave_file);
}

void PitchShiftIterative::array_to_wave(char* c_out_wav_file_name, int* i_in_wave_array) {

    //printf("File name i got: %s\n", c_out_wav_file_name);
    
    const int i_format=SF_FORMAT_WAV | SF_FORMAT_PCM_32;
    int i_err_code;
    
    SNDFILE *m_wave_file;
    SF_INFO m_wave_info;
    
    m_wave_info.format = i_format;
    m_wave_info.channels = i_wave_channels;
    m_wave_info.samplerate = i_wave_sample_rate;
    m_wave_file = sf_open(c_out_wav_file_name, SFM_WRITE, &m_wave_info);
    
    i_err_code = sf_error(m_wave_file);

    if (i_err_code == SF_ERR_NO_ERROR) {
        printf("Opened WAV file to write successfully.\n");
    } else {
        printf("SNDFILE ERROR ON WRITING: %s\n", sf_error_number(i_err_code));
        return;
    }
    sf_write_int(m_wave_file, i_in_wave_array, i_wave_num_of_itens);
    sf_close(m_wave_file);
    
}

int PitchShiftIterative::pitch_shift(int* i_in_wave_array, int* i_out_wave_array, float f_ratio_shift) {
    float *f_wave_array;
    float *f_wave_shifted_pitch;
    float f_byte_value;
    float f_sample_rate;
    int error;
    
    f_wave_array = (float *) malloc(i_wave_num_of_itens*sizeof(float));
    f_wave_shifted_pitch = (float *) malloc(i_wave_num_of_itens*sizeof(float));

    // Normalizes the wave data from wave_array to the interval [-1,1]
    for (int i = 0; i < i_wave_length; i += i_wave_channels) {
        f_wave_array[i] = 1.0 * i_in_wave_array[i];
        f_wave_array[i] /= INT_MAX;
    }
    
    printf("[3. 1/5] Starting pitch shifting algorithm de facto:\n");
    
    f_sample_rate = i_wave_sample_rate * 1.0;
    
    //smbPitchShifter->smbPitchShift(f_ratio_shift, i_wave_length, 1024, 32, 44100, f_wave_array, f_wave_shifted_pitch);
    error = smbPitchShifter->smbPitchShift(f_ratio_shift, i_wave_length, 1024, 32, f_sample_rate, f_wave_array, f_wave_shifted_pitch);
    
    printf("[3. 2/5]Finished pitch shifting algorithm\n");
    
    // Gets max absolute value from f_wave_shifted_pitch so as to normalize it back to [-1,1]
    
    printf("[3. 3/5] Getting max value of wave for normalization:\n");
    
    float f_abs_max_of_wave = 0.0;
    for (int i = 0; i < i_wave_length; i += i_wave_channels) {
        f_abs_max_of_wave = std::max(fabs(f_wave_shifted_pitch[i]), f_abs_max_of_wave);
    }
    
    printf("[3. 4/5] Finished getting max value of wave for normalization:\n");
    
    // Normalizes f_wave_shifted_pitch back to [-1,1]. Converts the result back as an integer on i_wave_shifted_pitch
    
    printf("[3. 5/5] Normalizing wave back to integer values:\n");
    for (int i = 0; i < i_wave_length; i += i_wave_channels) {
        f_wave_shifted_pitch[i] /= f_abs_max_of_wave;
        f_byte_value = f_wave_shifted_pitch[i] * INT_MAX;
        i_out_wave_array[i] = f_byte_value;
    }
    
    //delete(smbPitchShifter);
    
    printf("*** Finished normalizing wave back to integer values: ***\n");
    
    return error;

}

void PitchShiftIterative::sum_two_waves(int* i_in_first_wave_array, int* i_in_second_wave_array, int* i_out_result_wave_array) {
    // Original wave on first array, with ratio 3:1
    int i_first_value, i_second_value;
    for (int i = 0; i < i_wave_length; i += i_wave_channels) {
        i_first_value = i_in_first_wave_array[i];
        i_first_value /= 8;
        i_first_value *= 5;
        i_second_value = i_in_second_wave_array[i];
        i_second_value /= 8;
        i_second_value *= 3;
        i_out_result_wave_array[i] = i_first_value + i_second_value;
    }
}

void PitchShiftIterative::sum_three_waves(int* i_in_first_wave_array, int* i_in_second_wave_array, int* i_in_third_wave_array, int* i_out_result_wave_array) {
    int i_first_value, i_second_value, i_third_value;
    for (int i = 0; i < i_wave_length; i += i_wave_channels) {
        i_first_value = i_in_first_wave_array[i];
        i_first_value /= 8;
        i_first_value *= 4;
        i_second_value = i_in_second_wave_array[i];
        i_second_value /= 8;
        i_second_value *= 2;
        i_third_value = i_in_third_wave_array[i];
        i_third_value /= 8;
        i_third_value *= 2;
        i_out_result_wave_array[i] = i_first_value + i_second_value + i_third_value;
    }
}



