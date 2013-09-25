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

#define PROGRESS_BAR_FULL_WIDTH 240

@interface MainViewController : UIViewController{
    
    int recordEncoding;
    float progress;
    double lowPassResults;
    bool startedPlaying;
    
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
    
    IBOutlet UIButton *centerButton;
    IBOutlet UIButton *listButton;
    IBOutlet UIButton *downloadButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *shareButton;
    IBOutlet UILabel *centerTextLabel;
    IBOutlet UIView *selectingEffectView;
    IBOutlet UIImageView *floatingCircle;
    IBOutlet UIImageView *floatingCircleInverse;
    IBOutlet UIImageView *progressBar;
    IBOutlet UIImageView *progressBarBackground;
    
    NSTimer* levelTimer;
    NSTimer* progressBarTimer;
    NSTimer* animationTimer;
    NSTimer* playerTimer;
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecorder;
    AVAssetReader *assetReader;
    AVAssetWriter *assetWriter;
    
    PitchShifter *pitchShifter;
}

- (IBAction)centerButtonAction:(UIButton *)sender;
- (IBAction)cancelButtonAction:(UIButton *)sender;
- (IBAction)selectThirdButtonAction:(UIButton *)sender;
- (IBAction)selectFifthButtonAction:(UIButton *)sender;
- (IBAction)selectTriadButtonAction:(UIButton *)sender;
- (IBAction)shareButtonAction:(UIButton *)sender;
- (IBAction)listButtonAction:(UIButton *)sender;
- (IBAction)downloadButtonAction:(UIButton *)sender;

@end
