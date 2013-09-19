//
//  MainViewController.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doPitchShift {

    //Get wav file's directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *inWavName = @"440Hz.wav";
    NSString *outWavName = @"/result.wav";

    NSArray *directoriesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath =  [directoriesPath objectAtIndex:0];

    NSString *inWavPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:inWavName];
    NSString *outWavPath = [documentsPath stringByAppendingString:outWavName];

    char *inWavPathCharArray = [inWavPath UTF8String];
    char *outWavPathCharArray = [outWavPath UTF8String];


    PitchShifter *pitchShifter = [PitchShifter alloc];
    [pitchShifter pitchShiftWavFile:inWavPathCharArray andOutFilePath:outWavPathCharArray];

    NSString *documentsDirectoryPath = [directoryPaths objectAtIndex:0];
    if ([fileManager fileExistsAtPath:outWavPath] == YES) {
        NSLog(@"File exists: %@",outWavPath);
    } else {
        NSLog(@"File does not exist");
    }

    NSURL *url = [NSURL fileURLWithPath:outWavPath];

    NSError *error;

    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    NSLog(@"%@",error);

    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];

    NSLog(@"%@",error);
}

- (IBAction)recordButtonAction:(id)sender {
    
}

- (IBAction)playButtonAction:(id)sender {
    [self doPitchShift];
}
@end
