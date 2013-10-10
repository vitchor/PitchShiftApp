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

- (IBAction)deleteButtonAction:(UIButton *)sender {
    NSString *alertTitle = @"Delete this track?";
    NSString *alertMsg =@"This action cannot be undone!";
    NSString *alertButton1 = @"Yes";
    NSString *alertButton2 =@"No";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:alertButton1 otherButtonTitles:nil];
    // optional - add more buttons:
    [alert setTag:1];
    [alert addButtonWithTitle:alertButton2];
    [alert show];
}


- (IBAction)shareButtonAction:(UIButton *)sender {
    UIViewController *sCSharingImageView = [soundManager shareOnSoundCloudWithString:self.trackNameLabel.text shouldLog:NO];
    [self.tracksController presentViewController:sCSharingImageView animated:YES completion:nil];
}

-(void) popupActivityViewWithURL:(NSString*) url{
    //    NSArray * activityItems = @{[NSString stringWithFormat:@"Some initial text."], [NSURL URLWithString:@"http://www.google.com"]};
    NSString *text = [NSString stringWithFormat:@"Check this awesome song: %@", url];
    UIImage *image = [UIImage imageNamed:@"icon 120.png"];
    NSArray *activityItems = [NSArray arrayWithObjects:text,image , nil];
    
    NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypeSaveToCameraRoll, UIActivityTypeCopyToPasteboard, UIActivityTypeAirDrop];
    
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems: activityItems applicationActivities:nil];
    avc.excludedActivityTypes = excludeActivities;
    
    NSLog(@"==== presentViewController");
//    [UIApplication sharedApplication].keyWindow
    [[UIApplication sharedApplication].keyWindow.rootViewController presentModalViewController:avc animated:YES];
}

- (IBAction)playButtonAction:(UIButton *)sender {
    if(isPlaying){
        isPlaying = NO;
        self.tracksController.isPlaying = NO;
        [soundManager stopSound];
        [playButton setImage:[UIImage imageNamed:@"PSA_0.2_ListPlay.png"] forState:UIControlStateNormal];
    }else if (!self.tracksController.isPlaying){
        [playButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton.png"] forState:UIControlStateNormal];
        isPlaying = YES;
        self.tracksController.isPlaying = YES;
        [soundManager playSound:self.trackNameLabel.text];
        playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector: @selector(checkPlayer) userInfo:nil repeats:YES];
    }
}

// Called from a timer started on playButtonAction
-(void)checkPlayer{
    if(soundManager.audioPlayer && isPlaying){
        if(![soundManager.audioPlayer isPlaying]){
            NSLog(@"TERMINEI DE TOCAR");
            [playerTimer invalidate], playerTimer = nil;
            isPlaying = NO;
            self.tracksController.isPlaying = NO;
            [playButton setImage:[UIImage imageNamed:@"PSA_0.2_ListPlay.png"] forState:UIControlStateNormal];
        }
    }
}

// Called as a result of an affirmative answer from the deleteButtonAction
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

// Called as a result of an affirmative answer from the deleteButtonAction
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if (buttonIndex == 0) {
            [self deleteTrackAction];
        }
    }
}

@end
