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

- (IBAction)deleteTrack:(UIButton *)sender {
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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    NSArray *directoryPath = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath =  [directoryPath objectAtIndex:0];
    NSString *outWavPath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:@"result-pitchshifted.wav"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outWavPath] == YES) {
        NSLog(@"File exists: %@",outWavPath);
    } else {
        NSLog(@"File does not exist: %@",outWavPath);
    }
    
    NSURL *trackURL = [NSURL fileURLWithPath:outWavPath];
    //    NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sax" ofType:@"mp3"]];
    
    SCShareViewController *shareViewController;
    shareViewController = [SCShareViewController shareViewControllerWithFileURL:trackURL
                                                              completionHandler:^(NSDictionary *trackInfo, NSError *error){
                                                                  
                                                                  if (SC_CANCELED(error)) {
                                                                      NSLog(@"Canceled!");
                                                                  } else if (error) {
                                                                      NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                  } else {
                                                                      // If you want to do something with the uploaded
                                                                      // track this is the right place for that.
                                                                      NSLog(@"Uploaded track: %@", trackInfo);
                                                                  }
                                                                  
                                                              }];
    
    //    // If your app is a registered foursquare app, you can set the client id and secret.
    //    // The user will then see a place picker where a location can be selected.
    //    // If you don't set them, the user sees a plain plain text filed for the place.
    //    [shareViewController setFoursquareClientID:@"<foursquare client id>"
    //                                  clientSecret:@"<foursquare client secret>"];
    //
    //    // We can preset the title ...
    //    [shareViewController setTitle:@"Funny sounds"];
    //
    //    // ... and other options like the private flag.
    //    [shareViewController setPrivate:NO];
    
    // Now present the share view controller.
    
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        [self.tracksController presentModalViewController:shareViewController animated:YES];
    }else{
        [self.tracksController presentViewController:shareViewController animated:YES completion:nil];
    }
}

- (IBAction)playTrack:(UIButton *)sender {
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
