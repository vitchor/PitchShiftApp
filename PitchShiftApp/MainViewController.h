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

#define PROGRESS_BAR_FULL_WIDTH 240.0
#define CIRCLE_MIN_SIZE 200.0
#define CIRCLE_MAX_SIZE 300.0
#define INV_CIRCLE_MIN_SIZE 200.0
#define INV_CIRCLE_MAX_SIZE 300.0
#define CIRCLE_ROTATION_INCREMENT 0.075

@interface MainViewController : UIViewController{
    
    int recordEncoding;
    float progress;
    float rotationAngle;
    double lowPassResults;
    bool startedPlaying;
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
    
    IBOutlet UILabel *centerTextLabel;
    IBOutlet UIButton *centerButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIImageView *floatingCircle;
    IBOutlet UIImageView *floatingCircleInverse;
    IBOutlet UIImageView *progressBar;
    IBOutlet UIImageView *progressBarBackground;
    IBOutlet UIView *selectingEffectView;
//    IBOutlet UIButton *shareButton;
    
    NSTimer* recordTimer;
    NSTimer* processTimer;
    NSTimer* playerTimer;

    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    AVAssetReader *assetReader;
    AVAssetWriter *assetWriter;
    
    PitchShifter *pitchShifter;
}

- (IBAction)centerButtonAction:(UIButton *)sender;
- (IBAction)backButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)selectThirdButtonAction:(UIButton *)sender;
- (IBAction)selectFifthButtonAction:(UIButton *)sender;
- (IBAction)selectTriadButtonAction:(UIButton *)sender;
//- (IBAction)shareButtonAction:(UIButton *)sender;

@end
