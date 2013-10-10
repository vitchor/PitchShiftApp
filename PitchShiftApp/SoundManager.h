//
//  MainViewController.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "SCUI.h"
#import "AppDelegate.h"

#define GLOBAL_AUDIO_SAMPLE_RATE  48000.0

@interface SoundManager : NSObject{
    AVAssetReader *assetReader;
    AVAssetWriter *assetWriter;
}

@property(nonatomic,readonly) BOOL isPlaying;
@property(nonatomic,readwrite) int recordEncoding;
@property(nonatomic,retain) AVAudioRecorder *audioRecorder;
@property(nonatomic,retain) AVAudioPlayer *audioPlayer;

- (NSString*)getRecDir;
- (void)playSound;
- (void)playSound:(NSString*) outWavName;
- (void)pauseSound;
- (void)stopSound;
-(UIViewController*) shareOnSoundCloudWithString:(NSString*)songName shouldLog:(BOOL)shouldLog;

// NOT TESTED:
- (void) startRecordingSound;
- (void) startRecordingSoundWithEncoding:(int)encoding andFileName:(NSString*)fileName;
- (void) stopRecordingSoundAndSaveToWav:(BOOL)saveToWav withName:(NSString*)wavName;
@end
