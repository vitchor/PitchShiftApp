//
//  MainViewController.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

//#define GLOBAL_AUDIO_SAMPLE_RATE  32000.0
#define GLOBAL_AUDIO_SAMPLE_RATE  48000.0

@interface SoundManager : NSObject{
    
//    NSTimer* playerTimer;
    AVAssetReader *assetReader;
    AVAssetWriter *assetWriter;
    
}

@property(nonatomic,readonly) BOOL isPlaying;
@property(nonatomic,readwrite) int recordEncoding;
@property(nonatomic,retain) AVAudioRecorder *audioRecorder;
@property(nonatomic,retain) AVAudioPlayer *audioPlayer;
//- (IBAction)shareButtonAction:(UIButton *)sender;

- (NSString*)getRecDir;
- (void)playSound;
- (void)playSound:(NSString*) outWavName;
- (void)pauseSound;
- (void)stopSound;

//TEST:
- (void) startRecordingSound;
- (void) startRecordingSoundWithEncoding:(int)encoding andFileName:(NSString*)fileName;

- (void) stopRecordingSoundAndSaveToWav:(BOOL)saveToWav withName:(NSString*)wavName;


//- (void)killTimers;

@end
