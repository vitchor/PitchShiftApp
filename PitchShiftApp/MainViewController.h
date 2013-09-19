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

@interface MainViewController : UIViewController {
    AVAudioPlayer *audioPlayer;
}
- (IBAction)recordButtonAction:(id)sender;
- (IBAction)playButtonAction:(id)sender;

@end
