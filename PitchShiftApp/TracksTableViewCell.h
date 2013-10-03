//
//  TracksViewCell.h
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/1/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "TracksTableViewController.h"
//#import "MainViewController.h"
#import "SoundManager.h"

@interface TracksTableViewCell : UITableViewCell{
    BOOL isPlaying;
    SoundManager *soundManager;
    NSTimer *playerTimer;
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

@end
