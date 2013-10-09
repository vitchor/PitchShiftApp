//
//  PitchShifter.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 10/3/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "PitchShifter.h"

@implementation PitchShifter

- (void)pitchShiftWavFile:(NSString*)wavFilePath andOutFilePath:(NSString*)outWavFilePath andShiftType:(int)shiftType {
    NSString *tempFile = [[NSBundle mainBundle] pathForResource:@"pitchShifter" ofType:@"csd"];
    
    [self.csound stopCsound];
    self.csound = [[CsoundObj alloc] init];
    [self.csound addCompletionListener:self];
    [self.csound addValueCacheable:self];
    
    switch (shiftType) {
        case SHIFT_THIRD:
            *channelPtrPitch = THIRD_UP;
            break;
        case SHIFT_FIFTH:
            *channelPtrMix = FIFTH_UP;
            break;
        case SHIFT_TRIAD:
            NSLog(@"Not ready for triads yet!");
            break;
    }
    
    [self.csound startCsound:tempFile];
    
    recordingURL = [[NSURL alloc] URLByAppendingPathComponent:outWavFilePath];
}

- (void)stopPitchShifting {
    [self.csound stopCsound];
}

- (float)getProgressStatus {
    return 0.5;
}

#pragma mark - Completion Listener

- (void)csoundObjComplete:(CsoundObj *)csoundObj {
    NSLog(@"Csound object finished processing");
}

-(void)csoundObjDidStart:(CsoundObj *)csoundObj {
	[self.csound recordToURL:recordingURL];
}

#pragma mark - Value Cached

- (void)setup:(CsoundObj *)csoundObj {
    channelPtrPitch = [csoundObj getInputChannelPtr:@"pitch" channelType:CSOUND_CONTROL_CHANNEL];
    channelPtrMix = [csoundObj getInputChannelPtr:@"mix" channelType:CSOUND_CONTROL_CHANNEL];
    channelPtrLength = [csoundObj getInputChannelPtr:@"length" channelType:CSOUND_CONTROL_CHANNEL];
    cachedValuePitch = pitchValue;
    cachedValueMix = mixValue;
    cachedValueLength = lengthValue;
    self.cacheDirty = YES;
}



@end

