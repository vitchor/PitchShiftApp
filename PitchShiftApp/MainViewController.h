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

@interface MainViewController : UIViewController{
    
    int recordEncoding;
    bool isProcessing;
    
    enum
    {
        ENC_AAC = 1,
        ENC_ALAC = 2,
        ENC_IMA4 = 3,
        ENC_ILBC = 4,
        ENC_ULAW = 5,
        ENC_PCM = 6,
    } encodingTypes;
    
    enum
    {
        INITIAL_VIEW = 0,
        RECORDING_VIEW = 1,
        SELECTING_EFFECT_VIEW = 2,
        PROCESSING_VIEW = 3,
        PREVIEW_VIEW_NOT_PLAYING = 4,
        PREVIEW_VIEW_PLAYING = 5,
        PLAYER_VIEW = 6, 
    } currentViewState;
    
    __weak IBOutlet UIButton *centerButton;
    __weak IBOutlet UIButton *listButton;
    __weak IBOutlet UIButton *downloadButton;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *shareButton;
    __weak IBOutlet UILabel *centerTextLabel;
    __weak IBOutlet UIView *selectingEffectView;

    IBOutlet UIProgressView *progressView;
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    AVAssetReader *assetReader;
    AVAssetWriter *assetWriter;
    
    PitchShifter *pitchShifter;
    
}

- (IBAction)centerButtonAction:(UIButton *)sender;
- (IBAction)listButtonAction:(UIButton *)sender;
- (IBAction)downloadButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)shareButtonAction:(UIButton *)sender;
- (IBAction)selectThirdButtonAction:(UIButton *)sender;
- (IBAction)selectFifthButtonAction:(UIButton *)sender;
- (IBAction)selectTriadButtonAction:(UIButton *)sender;


@end
