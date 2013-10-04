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
#import "TracksTableViewController.h"
#import "SCUI.h"
#import "SoundManager.h"

#define PROGRESS_BAR_FULL_WIDTH 240.0
#define BOT_CIRCLE_MIN_SIZE 304.0
#define BOT_CIRCLE_MAX_SIZE 354.0
#define MID_CIRCLE_MIN_SIZE 268.0
#define MID_CIRCLE_MAX_SIZE 318.0
#define TOP_CIRCLE_MIN_SIZE 192.0
#define TOP_CIRCLE_MAX_SIZE 242.0
#define FADING_TIME_DEFAULT 0.25
#define FADING_TIME_PS_BUTTONS 0.75

@interface MainViewController : UIViewController{
    
    int recordEncoding;
    float progress;
    float fadingTime;
    float botCircleScale;
    float midCircleScale;
    float topCircleScale;
    double lowPassResults;
    bool startedPlaying;
    bool isProcessing;
    bool isAnimatingCircles;
    
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
    IBOutlet UIButton *thirdPSButton;
    IBOutlet UIButton *fifthPSButton;
    IBOutlet UIButton *triadPSButton;
    IBOutlet UIButton *listButton;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *shareButton;
    
    IBOutlet UIImageView *bottomCircle;
    IBOutlet UIImageView *middleCircle;
    IBOutlet UIImageView *topCircle;
    IBOutlet UIImageView *ring;
    IBOutlet UIImageView *progressBar;
    IBOutlet UIImageView *progressBarBackground;
    
    NSTimer* recordTimer;
    NSTimer* processTimer;
    NSTimer* playerTimer;
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    AVAssetReader *assetReader;
    AVAssetWriter *assetWriter;
    
    PitchShifter *pitchShifter;
}

- (void)playSound:(NSString*) outWavName;
- (void)stopSound;
- (void)pauseSound;

- (IBAction)centerButtonAction:(UIButton *)sender;
- (IBAction)touchDownCenterButtonEvent:(UIButton *)sender;
- (IBAction)touchUpCenterButtonEvent:(UIButton *)sender;
- (IBAction)touchDragOutsideCenterButtonEvent:(UIButton *)sender;
- (IBAction)listButtonAction:(UIButton *)sender;
- (IBAction)backButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)selectThirdButtonAction:(UIButton *)sender;
- (IBAction)selectFifthButtonAction:(UIButton *)sender;
- (IBAction)selectTriadButtonAction:(UIButton *)sender;
- (IBAction)saveButtonAction:(UIButton *)sender;
- (IBAction)shareButtonAction:(UIButton *)sender;

@end
