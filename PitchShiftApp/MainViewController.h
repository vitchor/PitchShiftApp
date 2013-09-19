//
//  MainViewController.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "PitchShifter.h"

@interface MainViewController : UIViewController {
    
    int recordEncoding;

    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    
    AVAssetReader *assetReader;
    AVAssetWriter *assetWriter;
    
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
}






- (IBAction)startRecording:(UIButton *)sender;
- (IBAction)stopRecording:(UIButton *)sender;
- (IBAction)playButtonAction:(id)sender;



- (IBAction)recordButtonAction:(id)sender;
- (IBAction)playRecording:(UIButton *)sender;
- (IBAction)stopPlaying:(UIButton *)sender;

@end
