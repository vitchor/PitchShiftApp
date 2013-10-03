//
//  TracksViewCell.m
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/1/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "TracksTableViewCell.h"

@implementation TracksTableViewCell

@synthesize playButton, shareButton, deleteButton, trackNameLabel, tracksController;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        isPlaying = FALSE;
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshWithUrlSuffix:(NSString*)filePath{
    self.trackNameLabel.text = filePath;
    soundManager = [[SoundManager alloc] init];
}

- (IBAction)playTrack:(UIButton *)sender {
    if(!isPlaying){
        isPlaying = TRUE;
        [self.playButton setTitle:@"PAUSE" forState:UIControlStateNormal];
        [soundManager playSound:self.trackNameLabel.text];
        playerTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(checkPlayer) userInfo: nil repeats: YES];
    }else{
        isPlaying = FALSE;
        [self.playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        [soundManager pauseSound];
        NSLog(@"STOP");
    }
}


-(void)checkPlayer{
    if(soundManager.audioPlayer && isPlaying){
        if(![soundManager.audioPlayer isPlaying]){
            NSLog(@"TERMINEI DE TOCAR");
            [playerTimer invalidate], playerTimer = nil;
            isPlaying = NO;
            [self.playButton setTitle:@"PLAY" forState:UIControlStateNormal];
        }
    }
}


- (IBAction)deleteTrack:(UIButton *)sender {
    NSString *alertTitle = @"Delete this track?";
    NSString *alertMsg =@"Are you sure you wanna erase this track from your device? This action cannot be undone!";
    NSString *alertButton1 = @"Yes";
    NSString *alertButton2 =@"No";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:alertButton1 otherButtonTitles:nil];
    // optional - add more buttons:
    [alert setTag:1];
    [alert addButtonWithTitle:alertButton2];
    [alert show];
}

- (void)deleteTrackAction{
    // Firstly, lets delete the filefrom its path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:self.trackNameLabel.text];
    if([[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        NSLog(@"==== deleted file at path: %@", fullPath);
    }else{
        NSLog(@"==== there is no file to be deleted at path: %@", fullPath);
    }
    
    //Secondly, we need to refresnh the TableViewController
    [self.tracksController refreshCellsList];
    [self.tracksController.tracksTableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if (buttonIndex == 0) {
            [self deleteTrackAction];
        }
    }
}

@end
