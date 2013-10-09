//
//  PitchShifter.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 10/03/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CsoundObj.h"
#import "CsoundValueCacheable.h"

#define SHIFT_THIRD 1
#define SHIFT_FIFTH 2
#define SHIFT_TRIAD 3
#define THIRD_UP 1.259921
#define OCTAVE_UP 2.0
#define FIFTH_UP 1.5

@interface PitchShifter : UIControl <CsoundObjCompletionListener, CsoundValueCacheable> {
    
    bool shouldStopPitchShifting;
    CsoundObj *mCsound;
    NSURL *recordingURL;
    Float32 pitchValue, mixValue, lengthValue;
    
    // Value Cacheable
    BOOL mCacheDirty;
    float *channelPtrPitch, *channelPtrMix, *channelPtrLength;
    float cachedValuePitch, cachedValueMix, cachedValueLength;
}

- (void)pitchShiftWavFile:(NSString*)wavFilePath andOutFilePath:(NSString*)outWavFilePath andShiftType:(int)shiftType;
- (float)getProgressStatus;
- (void)stopPitchShifting;

@property (assign) BOOL cacheDirty;
@property (nonatomic, readwrite, setter = setPitchValue:) Float32 pitchValue;
@property (nonatomic, readwrite, setter = setMixValue:) Float32 mixValue;
@property (nonatomic, readwrite, setter = setLengthValue:) Float32 lengthValue;
@property (nonatomic, strong) CsoundObj* csound;

@end
