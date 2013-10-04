//
//  TracksViewCell.h
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/1/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "TracksTableViewController.h"
#import "SCUI.h"
#import "SoundManager.h"

@interface TracksTableViewCell : UITableViewCell{
    
    BOOL isPlaying;
    
    NSTimer *playerTimer;
    
    SoundManager *soundManager;
    
}

@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) IBOutlet UIButton *shareButton;
@property (nonatomic,retain) IBOutlet UIButton *deleteButton;
@property (nonatomic,retain) IBOutlet UILabel *trackNameLabel;

//@property (nonatomic,retain) IBOutlet UIButton *playButton;
@property (nonatomic,retain) TracksTableViewController *tracksController;


-(void)refreshWithUrlSuffix:(NSString*)filePath;
- (IBAction)playTrack:(UIButton *)sender;
- (IBAction)deleteTrack:(UIButton *)sender;
- (IBAction)shareButtonAction:(UIButton *)sender;

@end
