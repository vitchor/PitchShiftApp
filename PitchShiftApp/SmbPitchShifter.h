//
//  Header.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/18/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#ifndef PitchShiftApp_Header_h
#define PitchShiftApp_Header_h

#include <string.h>
#include <math.h>
#include <stdio.h>
#include <iostream>
//using namespace std;

class SmbPitchShifter {
    public:
        void smbFft(float *fftBuffer, long fftFrameSize, long sign);
        double smbAtan2(double x, double y);
        void smbPitchShift(float pitchShift, long numSampsToProcess, long fftFrameSize, long osamp, float sampleRate, float *indata, float *outdata);
        float getProgress();
    
    private:
        float progress;

};

#endif
