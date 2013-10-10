//
//  MainViewController.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

- (id)initDefaultXib{
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(screenHeight == 480){
        // retina 3.5:
        self = [super initWithNibName:@"MainViewController" bundle:nil];
    }else if(screenHeight == 568){
        // retina 4.0:
        self = [super initWithNibName:@"MainViewController_i5" bundle:nil];
    }
    if (self) {
        // Custom initialization
        [self customInit];
    }
    return self;
}

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
    
    SplashScreenController *splashScreenController = [[SplashScreenController alloc] initDefaultXib];
    [self.navigationController pushViewController:splashScreenController animated:NO];
    
    recordEncoding = ENC_PCM;
    currentViewState = INITIAL_VIEW;
    fadingTime = FADING_TIME_DEFAULT;
    screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    botCircleScale = 1.0;
    midCircleScale = 1.0;
    topCircleScale = 1.0;
    
    if (![self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    
    UITapGestureRecognizer *tapArea1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArea1Action)];
    [tapArea1View addGestureRecognizer:tapArea1];
    
    UITapGestureRecognizer *tapArea2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArea2Action)];
    [tapArea2View addGestureRecognizer:tapArea2];

    UITapGestureRecognizer *tapArea3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArea3Action)];
    [tapArea3View addGestureRecognizer:tapArea3];

    UITapGestureRecognizer *tapArea4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArea4Action)];
    [tapArea4View addGestureRecognizer:tapArea4];
    
    
    [self setupXib:INITIAL_VIEW];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) customInit{
    lastRecordCaf = @"_buffer.caf";
    lastRecordWav = @"_buffer.wav";
    lastRecording = @"Last recording.wav";
}

-(void) eraseBuffers{
    [self eraseFile:lastRecordCaf];
    [self eraseFile:lastRecordWav];
}

-(void) eraseFile:(NSString*) fileName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        NSLog(@"==== deleted file at path: %@", fullPath);
    }else{
        NSLog(@"==== there is no file to be deleted at path: %@", fullPath);
    }
}

-(void)setupXib:(int)state
{
    dispatch_async(dispatch_get_main_queue(), ^{

        
        if(state == PROCESSING_VIEW)
            fadingTime = FADING_TIME_PS_BUTTONS;
        else
            fadingTime = FADING_TIME_DEFAULT;
        
        bottomCircle.alpha = 1.0;
        middleCircle.alpha = 1.0;
        topCircle.alpha = 1.0;
        ring.alpha = 1.0;
        centerTextLabel.alpha = 1.0;
        centerButton.alpha = 1.0;
        listButton.alpha = 1.0;
        backButton.alpha = 1.0;
        cancelButton.alpha = 1.0;
        thirdPSButton.alpha = 1.0;
        fifthPSButton.alpha = 1.0;
        triadPSButton.alpha = 1.0;
        progressBarBackground.alpha = 1.0;
        progressBar.alpha = 1.0;
        saveButton.alpha = 1.0;
        shareButton.alpha = 1.0;
        
        
        
        [UIView animateWithDuration:fadingTime animations:^{
            
            if(state == INITIAL_VIEW){
                
                backButton.alpha = 0.0;
                cancelButton.alpha = 0.0;
                saveButton.alpha = 0.0;
                shareButton.alpha = 0.0;
                
            }
            
            bottomCircle.alpha = 0.0;
            middleCircle.alpha = 0.0;
            topCircle.alpha = 0.0;
            ring.alpha = 0.0;
            centerTextLabel.alpha = 0.0;
            centerButton.alpha = 0.0;
            listButton.alpha = 0.0;
            thirdPSButton.alpha = 0.0;
            fifthPSButton.alpha = 0.0;
            triadPSButton.alpha = 0.0;
            progressBarBackground.alpha = 0.0;
            progressBar.alpha = 0.0;
            
            
        } completion: ^(BOOL finished) {
        
            fadingTime = FADING_TIME_DEFAULT;
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:fadingTime];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationRepeatCount:1];
            
            switch (state) {
                    
                case INITIAL_VIEW:
                    
                    centerButton.transform = CGAffineTransformIdentity;
                    [centerButton setHidden:NO];
                    [centerTextLabel setHidden:NO];
                    [ring setHidden:NO];
                    [listButton setHidden:NO];
                    
                    [backButton setHidden:YES];
                    [cancelButton setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];
                    [saveButton setHidden:YES];
                    [shareButton setHidden:YES];
                    
                    if(screenHeight == 480){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_Ring.png"]];
                        
                    }else if(screenHeight == 568){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton_i5.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_Ring_i5.png"]];
                        
                    }

                    centerButton.alpha = 1.0;
                    ring.alpha = 1.0;
                    centerTextLabel.alpha = 1.0;
                    listButton.alpha = 1.0;
                    
                    currentViewState = INITIAL_VIEW;
                    
                    break;
                    
                case RECORDING_VIEW:
                    
                    centerButton.transform = CGAffineTransformIdentity;
                    [centerButton setHidden:NO];
                    [ring setHidden:NO];
                    [backButton setHidden:NO];
                    [bottomCircle setHidden:NO];
                    [middleCircle setHidden:NO];
                    [topCircle setHidden:NO];
                    
                    [cancelButton setHidden:YES];
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];
                    [listButton setHidden:YES];
                    [saveButton setHidden:YES];
                    [shareButton setHidden:YES];
                    
                    if(screenHeight == 480){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning.png"]];
                        
                    }else if(screenHeight == 568){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton_i5.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning_i5.png"]];
                        
                    }
                    
                    centerButton.alpha = 1.0;
                    ring.alpha = 1.0;
                    backButton.alpha = 1.0;
                    bottomCircle.alpha = 1.0;
                    middleCircle.alpha = 1.0;
                    topCircle.alpha = 1.0;
                    
                    currentViewState = RECORDING_VIEW;

                    break;
                    
                case SELECTING_EFFECT_VIEW:
                    
                    [thirdPSButton setHidden:NO];
                    [fifthPSButton setHidden:NO];
                    [triadPSButton setHidden:NO];
                    [cancelButton setHidden:NO];
                    
                    [backButton setHidden:YES];
                    [centerButton setHidden:YES];
                    [ring setHidden:YES];
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [listButton setHidden:YES];
                    [saveButton setHidden:YES];
                    [shareButton setHidden:YES];

                    thirdPSButton.alpha = 1.0;
                    fifthPSButton.alpha = 1.0;
                    triadPSButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    
                    currentViewState = SELECTING_EFFECT_VIEW;
                    
                    break;
                
                case PROCESSING_VIEW:
                    
                    [centerButton setHidden:NO];
                    [ring setHidden:NO];
                    [progressBarBackground setHidden:NO];
                    [cancelButton setHidden:NO];
                    [backButton setHidden:NO];
//                    [progressBar setHidden:NO];
                    
                    [centerTextLabel setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];
                    [listButton setHidden:YES];
                    [saveButton setHidden:YES];
                    [shareButton setHidden:YES];

                    if(screenHeight == 480){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning.png"]];
                        
                    }else if(screenHeight == 568){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton_i5.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning_i5.png"]];
                        
                    }
                    
                    centerButton.alpha = 1.0;
                    ring.alpha = 1.0;
                    progressBar.alpha = 1.0;
                    progressBarBackground.alpha = 1.0;
                    backButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    
                    currentViewState = PROCESSING_VIEW;
                    
                    break;
                    
                case PREVIEW_VIEW_NOT_PLAYING:
                    
                    centerButton.transform = CGAffineTransformIdentity;
                    [centerButton setHidden:NO];
                    [ring setHidden:NO];
                    [cancelButton setHidden:NO];
                    [backButton setHidden:NO];
                    [shareButton setHidden:NO];
                    [saveButton setHidden:NO];
                    
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];
                    [listButton setHidden:YES];
                   
                    if(screenHeight == 480){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButton.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_Ring.png"]];
                        
                    }else if(screenHeight == 568){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButton_i5.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_Ring_i5.png"]];
                        
                    }
                    
                    centerButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    backButton.alpha = 1.0;
                    ring.alpha = 1.0;
                    saveButton.alpha = 1.0;
                    shareButton.alpha = 1.0;
                    
                    currentViewState = PREVIEW_VIEW_NOT_PLAYING;
                    
                    break;
                
                case PREVIEW_VIEW_PLAYING:
                    
                    centerButton.transform = CGAffineTransformIdentity;
                    [centerButton setHidden:NO];
                    [cancelButton setHidden:NO];
                    [ring setHidden:NO];
                    [backButton setHidden:NO];
                    [shareButton setHidden:NO];
                    [saveButton setHidden:NO];
                    
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];
                    [listButton setHidden:YES];
            
                    if(screenHeight == 480){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning.png"]];
                        
                    }else if(screenHeight == 568){
                        
                        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton_i5.png"] forState:UIControlStateNormal];
                        [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning_i5.png"]];
                    }
                    
                    centerButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    backButton.alpha = 1.0;
                    ring.alpha = 1.0;
                    saveButton.alpha = 1.0;
                    shareButton.alpha = 1.0;
                    
                    currentViewState = PREVIEW_VIEW_PLAYING;
                    
                    break;
                    
                default:
                    
                    NSLog(@"UNRECOGNIZED STATE! setupXib : %d", state);
                    
                    break;
            } // switch end
            
            [UIView commitAnimations];
        
            
        }]; // block end
        
    }); // thread end
}

- (void) checkButtonState {
    
    if (centerButton.state == UIControlStateHighlighted) {

        if(currentViewState == INITIAL_VIEW || currentViewState == PROCESSING_VIEW)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButtonSelected.png"] forState:UIControlStateHighlighted];
        
        else if (currentViewState == PREVIEW_VIEW_NOT_PLAYING)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButtonSelected.png"] forState:UIControlStateHighlighted];
        
        else if (currentViewState == RECORDING_VIEW || currentViewState == PREVIEW_VIEW_PLAYING )
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButtonSelected.png"] forState:UIControlStateHighlighted];

        
        [UIView animateWithDuration:0.1 animations:^{
            centerButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }];

    }
    
    
    if (centerButton.state == UIControlStateNormal) {
        
        if(currentViewState == INITIAL_VIEW || currentViewState == PROCESSING_VIEW){
            if(screenHeight == 480)
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton.png"] forState:UIControlStateNormal];
                
            else if(screenHeight == 568)
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton_i5.png"] forState:UIControlStateNormal];
        }
        

        else if (currentViewState == PREVIEW_VIEW_NOT_PLAYING){
            if(screenHeight == 480)
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButton.png"] forState:UIControlStateNormal];
            
            else if(screenHeight == 568)
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButton_i5.png"] forState:UIControlStateNormal];
        }

        
        else if (currentViewState == RECORDING_VIEW || currentViewState == PREVIEW_VIEW_PLAYING){
            if(screenHeight == 480)
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton.png"] forState:UIControlStateNormal];
            
            else if(screenHeight == 568)
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton_i5.png"] forState:UIControlStateNormal];
        }
        
        
        [UIView animateWithDuration:0.1 animations:^{
            centerButton.transform = CGAffineTransformIdentity;
        }];
        
    }

}

- (void) startRecordingSound
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSLog(@"startRecording");
        audioRecorder = nil;
        
        // Init audio with record capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
        if(recordEncoding == ENC_PCM)
        {
            [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
            [recordSettings setObject:[NSNumber numberWithFloat:GLOBAL_AUDIO_SAMPLE_RATE] forKey: AVSampleRateKey];
            [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
            [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
            [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
            [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        }
        else
        {
            NSNumber *formatObject;
            
            switch (recordEncoding) {
                case (ENC_AAC):
                    formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                    break;
                case (ENC_ALAC):
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                    break;
                case (ENC_IMA4):
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                    break;
                case (ENC_ILBC):
                    formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                    break;
                case (ENC_ULAW):
                    formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                    break;
                default:
                    formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
            }
            
            [recordSettings setObject:formatObject forKey: AVFormatIDKey];
            [recordSettings setObject:[NSNumber numberWithFloat:GLOBAL_AUDIO_SAMPLE_RATE] forKey: AVSampleRateKey];
            [recordSettings setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
            [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
            [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
            [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *recDir = [paths objectAtIndex:0];
        NSURL *url = [NSURL fileURLWithPath:[[recDir stringByAppendingString:@"/"] stringByAppendingString:lastRecordCaf]];
        
        NSError *error = nil;
        audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        
        if ([audioRecorder prepareToRecord] == YES){
            audioRecorder.meteringEnabled = YES;
            [audioRecorder record];
        } else {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
        NSLog(@"recording");
    });
    
    [self startCenterButtonAnimations];
}

-(void) startCenterButtonAnimations {
    
    recordTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(levelTimerCallback) userInfo: nil repeats: YES];
    
     isAnimatingCircles = true;
    
    [self startSpinAndScaleWithImage:ring options:UIViewAnimationOptionCurveEaseIn duration:0.3 angleIncrement: M_PI/2.0 andAcumulatedAngle: M_PI/2.0];
    
    [self startSpinAndScaleWithImage:topCircle options:UIViewAnimationOptionCurveEaseIn duration:0.4 angleIncrement: -M_PI/2.0 andAcumulatedAngle: -M_PI/2.0];
    
    [self startSpinAndScaleWithImage:middleCircle options:UIViewAnimationOptionCurveEaseIn duration:0.5 angleIncrement: M_PI/2.0 andAcumulatedAngle: M_PI/2.0];
    
    [self startSpinAndScaleWithImage:bottomCircle options:UIViewAnimationOptionCurveEaseIn duration:0.6 angleIncrement: -M_PI/2.0 andAcumulatedAngle: -M_PI/2.0];
    
}

- (void)levelTimerCallback {
    
    if (audioRecorder) {
        [audioRecorder updateMeters];
        
        const double ALPHA = 0.05;
        double averagePowerForChannel = pow(10, (0.05 * [audioRecorder averagePowerForChannel:0]));
        lowPassResults = ALPHA * averagePowerForChannel + (1.0 - ALPHA) * lowPassResults;
        
        //NSLog(@"Average input: %f Peak input: %f Low pass results:%f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0], lowPassResults);
        
        float botCircleCurrentSize = BOT_CIRCLE_MIN_SIZE + (BOT_CIRCLE_MAX_SIZE-BOT_CIRCLE_MIN_SIZE)*5*lowPassResults;
        float midCircleCurrentSize = MID_CIRCLE_MIN_SIZE + (MID_CIRCLE_MAX_SIZE-MID_CIRCLE_MIN_SIZE)*5*lowPassResults;
        float topCircleCurrentSize = TOP_CIRCLE_MIN_SIZE + (TOP_CIRCLE_MAX_SIZE-TOP_CIRCLE_MIN_SIZE)*5*lowPassResults;
        
        botCircleScale = botCircleCurrentSize/BOT_CIRCLE_MAX_SIZE;
        midCircleScale = midCircleCurrentSize/MID_CIRCLE_MAX_SIZE;
        topCircleScale = topCircleCurrentSize/TOP_CIRCLE_MAX_SIZE;
        
    } else {
        NSLog(@"Timer still running");
    }
}

- (void) startSpinAndScaleWithImage: (UIImageView *) imageToSpin options: (UIViewAnimationOptions) options duration: (float) duration angleIncrement: (float) angleIncrement andAcumulatedAngle:(float) acumulatedAngle{
    
    ////Set scale to circles
    
    float scale;
    
    if(imageToSpin == bottomCircle){
        scale = botCircleScale;
    }
    else if(imageToSpin == middleCircle){
        scale = midCircleScale;
    }
    else if(imageToSpin == topCircle){
        scale = topCircleScale;
    }
    else if(imageToSpin == ring){
        scale = 1.0;
    }
    else
    {
        scale = 1.0;
        
        NSLog(@"ERROR! - UNKNOWN imageToSpin: %@", imageToSpin);
    }
    
    
    ////Instantiate the scale and rotation animations
    
    CGAffineTransform transfScale = CGAffineTransformMakeScale(scale, scale);
    
    CGAffineTransform transfRotation = CGAffineTransformMakeRotation(acumulatedAngle);
    
    
    ////Do the concatenated animation
    
    [UIView animateWithDuration: duration delay: 0.0f options: options animations: ^{
        
        if(imageToSpin == ring)
            imageToSpin.transform = transfRotation;
        else
            imageToSpin.transform = CGAffineTransformConcat(transfScale, transfRotation);
        
     }
     completion: ^(BOOL finished) {
         
         if(isAnimatingCircles)
             [self startSpinAndScaleWithImage:imageToSpin options:UIViewAnimationOptionCurveLinear duration:duration angleIncrement:angleIncrement andAcumulatedAngle: (acumulatedAngle+angleIncrement)];
         
     }];
}

-(void) stopCenterButtonAnimations {
    
    botCircleScale = 1.0;
    midCircleScale = 1.0;
    topCircleScale = 1.0;
    
    isAnimatingCircles = false;
}

- (void) stopRecordingSound {
    
    [self stopCenterButtonAnimations];
    
    NSLog(@"stopRecording");
    NSTimeInterval audioLength = audioRecorder.currentTime;
    [audioRecorder stop];
    
    if (audioLength <= RECORDING_MIN_DURATION) {

        NSString *message = [NSString stringWithFormat:@"The recording is too short. Maybe you won't be able to notice the recording effects"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

    NSLog(@"stopped with a record duration of %f", audioLength);
    if ( ![self exportAssetAsWaveFromInput:lastRecordCaf andOutput:lastRecordWav]) {
        NSLog(@"ERROR IN WAV CONVERSION!");
    }
    
    [recordTimer invalidate], recordTimer = nil;
}

-(BOOL)exportAssetAsWaveFromInput:(NSString*)inputName andOutput:(NSString*)outputName
{
    NSError *error = nil ;
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSNumber numberWithFloat:GLOBAL_AUDIO_SAMPLE_RATE], AVSampleRateKey,
                                  [ NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                  [ NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                  [ NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                  [ NSNumber numberWithBool:0], AVLinearPCMIsBigEndianKey,
                                  [ NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                  [ NSData data], AVChannelLayoutKey, nil ];
    
//    NSString *audioFilePath = filePath;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    
    NSString *inputPath = [[recDir stringByAppendingString:@"/"] stringByAppendingString:inputName];
    AVURLAsset * URLAsset = [[AVURLAsset alloc]  initWithURL:[NSURL fileURLWithPath:inputPath] options:nil];
    
    if (!URLAsset) return NO ;
    
    assetReader = [AVAssetReader assetReaderWithAsset:URLAsset error:&error];
    if (error) return NO;
    
    NSArray *tracks = [URLAsset tracksWithMediaType:AVMediaTypeAudio];
    if (![tracks count]) return NO;
    
    AVAssetReaderAudioMixOutput *audioMixOutput = [AVAssetReaderAudioMixOutput
                                                   assetReaderAudioMixOutputWithAudioTracks:tracks
                                                   audioSettings :audioSetting];
    
    if (![assetReader canAddOutput:audioMixOutput]) return NO ;
    
    [assetReader addOutput :audioMixOutput];
    
    if (![assetReader startReading]) return NO;
    
    NSString *outputPath = [[recDir stringByAppendingString:@"/"] stringByAppendingString:outputName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:outputPath])
        [[NSFileManager defaultManager] removeItemAtPath:outputPath error:&error];
    
    NSURL *outURL = [NSURL fileURLWithPath:outputPath];
    
    assetWriter = [AVAssetWriter assetWriterWithURL:outURL
                                                          fileType:AVFileTypeWAVE
                                                             error:&error];
    if (error) return NO;
    
    AVAssetWriterInput *assetWriterInput = [ AVAssetWriterInput assetWriterInputWithMediaType :AVMediaTypeAudio
                                                                                outputSettings:audioSetting];
    assetWriterInput. expectsMediaDataInRealTime = NO;
    
    if (![assetWriter canAddInput:assetWriterInput]) return NO;
    
    [assetWriter addInput :assetWriterInput];
    
    if (![assetWriter startWriting]) return NO;
    
    [assetWriter startSessionAtSourceTime:kCMTimeZero ];
    
    
    dispatch_queue_t queue = dispatch_queue_create( "assetWriterQueue", NULL );
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:queue usingBlock:^{
        
        NSLog(@"start");
        
        while (1)
        {
            if ([assetWriterInput isReadyForMoreMediaData]) {
                
                CMSampleBufferRef sampleBuffer = [audioMixOutput copyNextSampleBuffer];
                
                if (sampleBuffer) {
                    [assetWriterInput appendSampleBuffer :sampleBuffer];
                    CFRelease(sampleBuffer);
                } else {
                    [assetWriterInput markAsFinished];
                    break;
                }
            }
        }
        
        [assetWriter finishWriting];
        
        NSLog(@"finish");
    }];
    
    return YES;
}

- (void)processSound:(int) pitchShiftType {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    NSString *inWavPath = [[recDir stringByAppendingString:@"/"] stringByAppendingString:lastRecordWav];
//    NSString *inWavPath = [NSString stringWithFormat:@"%@/recordedWAV.wav", recDir];

    [self doPitchShift:inWavPath type:pitchShiftType];
    
//    usleep(100000);
    
    processTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(updateProgressBar) userInfo: nil repeats: YES];
}

-(void) updateProgressBar {
    
    if (isProcessing){
        
        progress = [pitchShifter getProgressStatus];
        
        // make animations
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.01];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationRepeatCount:1];
        
        if (!(progress != progress) && progress != -1.0 && progress != 0.0 &&  progress < 0.999) {
            
            NSLog(@"STATUS : %f ",progress);
            
            progressBar.transform = CGAffineTransformMakeScale(progress, 1.0);
            
            if(progressBar.alpha==1.0)
               [progressBar setHidden:NO];
        }

        ring.transform = CGAffineTransformRotate(ring.transform, 0.1);
        
        [UIView commitAnimations];
        
    }
    else
    {
        [processTimer invalidate], processTimer = nil;
        
        centerButton.transform = CGAffineTransformIdentity;
        
        [self setupXib:PREVIEW_VIEW_NOT_PLAYING];
    }
    
}

- (void)doPitchShift:(NSString *)inWavPath type:(int)pitchShiftType{
    
    isProcessing = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
        //Get wav file's directory
//        NSString *outWavName = lastRecorder;
        
        NSArray *directoriesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath =  [directoriesPath objectAtIndex:0];
        
        NSString *outWavPath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:lastRecording];
        
        NSError *error = nil ;
        if([[NSFileManager defaultManager] fileExistsAtPath:outWavPath])
            [[NSFileManager defaultManager] removeItemAtPath:outWavPath error:&error];
        
        char *inWavPathCharArray = [inWavPath UTF8String];
        
        char *outWavPathCharArray = [outWavPath UTF8String];
        
        if (!pitchShifter) {
            
            pitchShifter = [PitchShifter alloc];
            
            [pitchShifter pitchShiftWavFile:inWavPathCharArray andOutFilePath:outWavPathCharArray andShiftType:pitchShiftType];
            
        } else {
            
            [pitchShifter stopPitchShifting];
            
            pitchShifter = nil;
            
            pitchShifter = [PitchShifter alloc];
            
            [pitchShifter pitchShiftWavFile:inWavPathCharArray andOutFilePath:outWavPathCharArray andShiftType:pitchShiftType];
            
        }
        
        [self eraseBuffers];
        NSLog(@"==== erase buffers");
        isProcessing = NO;
    
    });
}

- (void)playSound{
    [self playSound:lastRecording];
}

- (void)playSound:(NSString*) outWavName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *directoryPath = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath =  [directoryPath objectAtIndex:0];
        NSString *outWavPath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:outWavName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outWavPath] == YES) {
            NSLog(@"File exists: %@",outWavPath);
        } else {
            NSLog(@"File does not exist: %@",outWavPath);
        }
        
        NSURL *url = [NSURL fileURLWithPath:outWavPath];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSError *error = nil ;

        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
        startedPlaying = true;
    });
    
     playerTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(checkPlayer) userInfo: nil repeats: YES];
}

-(void)checkPlayer{
    
    if(audioPlayer && startedPlaying){
        
        ring.transform = CGAffineTransformRotate(ring.transform, 0.06);
        
        if(![audioPlayer isPlaying]){
        
            NSLog(@"TERMINEI DE TOCAR");
        
            [self setupXib:PREVIEW_VIEW_NOT_PLAYING];
            
            [playerTimer invalidate], playerTimer = nil;
            
            startedPlaying = false;
        }
    }
}

- (void)stopPitchSchifting{
    if (pitchShifter) {
        [pitchShifter stopPitchShifting];
        pitchShifter = nil;
    }
}

// Called as a result of an affirmative answer from the SaveButtonAction
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 2) {
        if (buttonIndex != [alertView cancelButtonIndex]){
            NSString *entered = [(InputAlertView *)alertView enteredText];
            entered = [entered stringByAppendingString:@".wav"];
            [self exportAssetAsWaveFromInput:lastRecording andOutput:entered];
            
            //            NSLog(@"You typed: %@", entered);
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fullPath = [[documentsDirectory stringByAppendingString:@"/"] stringByAppendingString:entered];
            UIAlertView *newAlert;
            if([[NSFileManager defaultManager] fileExistsAtPath:fullPath]){
                newAlert = [[UIAlertView alloc] initWithTitle:@"Saved as..." message:[NSString stringWithFormat:@"Your recording was successfully saved as: %@",entered] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            }else{
                newAlert = [[UIAlertView alloc] initWithTitle:@"An error occured..." message:[NSString stringWithFormat:@"Your recording could not be saved!"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            }
            
            //            UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"Saved as..." message:[NSString stringWithFormat:@"Your recording was asved as: %@",entered] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [newAlert show];
        }
    }
}

- (void)killTimers {
    
    if (recordTimer) {
        [recordTimer invalidate], recordTimer = nil;
    }
    
    if (processTimer) {
        [processTimer invalidate], processTimer = nil;
        isProcessing = false;
    }
    
    if (playerTimer) {
        [playerTimer invalidate], playerTimer = nil;
        startedPlaying = false;
    }
    
}

- (void)stopSound {
    if(audioPlayer.isPlaying)
        [audioPlayer stop];
}

- (void)pauseSound {
    if(audioPlayer.isPlaying){
        [audioPlayer pause];
        audioPlayer.currentTime = 0;
    }
}

- (void) touchDownCenterButtonAnimation {
    
    if(currentViewState == INITIAL_VIEW)
        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButtonSelected.png"] forState:UIControlStateNormal];
    
    else if (currentViewState == PREVIEW_VIEW_NOT_PLAYING)
        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButtonSelected.png"] forState:UIControlStateNormal];
    
    else if (currentViewState == RECORDING_VIEW || currentViewState == PREVIEW_VIEW_PLAYING )
        [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButtonSelected.png"] forState:UIControlStateNormal];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        centerButton.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }];
    
}

- (void) touchUpCenterButtonAnimation {
    
    if(currentViewState == INITIAL_VIEW){
        if(screenHeight == 480)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton.png"] forState:UIControlStateNormal];
        else if(screenHeight == 568)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton_i5.png"] forState:UIControlStateNormal];
    }
    else if (currentViewState == PREVIEW_VIEW_NOT_PLAYING){
        if(screenHeight == 480)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButton.png"] forState:UIControlStateNormal];
        else if(screenHeight == 568)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButton_i5.png"] forState:UIControlStateNormal];
    }
    else if (currentViewState == RECORDING_VIEW || currentViewState == PREVIEW_VIEW_PLAYING){
        if(screenHeight == 480)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton.png"] forState:UIControlStateNormal];
        else if(screenHeight == 568)
            [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton_i5.png"] forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        centerButton.transform = CGAffineTransformIdentity;
    }];
    
}

- (void) tapArea1Action {

    if (!backButton.isHidden)
        [self backButtonAction:nil];
    
}

- (void) tapArea2Action {

    if(!saveButton.isHidden)
        [self saveButtonAction:nil];
    
}

- (void) tapArea3Action {

    if (!shareButton.isHidden)
        [self shareButtonAction:nil];
    
}

- (void) tapArea4Action {

    if (!cancelButton.isHidden)
        [self cancelButtonAction:nil];
    
    else if (!listButton.isHidden)
        [self listButtonAction:nil];
    
}

- (IBAction)centerButtonAction:(UIButton *)sender {
    
    switch (currentViewState) {
        
        case INITIAL_VIEW:
            
            [self setupXib:RECORDING_VIEW];
            [self startRecordingSound];
            break;
            
        case RECORDING_VIEW:
            
            [self stopRecordingSound];
            [self setupXib:SELECTING_EFFECT_VIEW];
            break;
            
        case PROCESSING_VIEW:
            
            break;
            
        case PREVIEW_VIEW_NOT_PLAYING:

            [self playSound];
            [self setupXib:PREVIEW_VIEW_PLAYING];
            break;
            
        case PREVIEW_VIEW_PLAYING:
            
            [self stopSound];
            break;
            
        default:
            
            NSLog(@"UNRECOGNIZED STATE! centerButtonAction : %d", currentViewState);
            break;
    }
}

- (IBAction)listButtonAction:(UIButton *)sender{
    
//    TracksTableViewController *trackTableViewController = [[TracksTableViewController alloc] initWithNibName:@"TracksTableViewController" bundle:nil];
    TracksTableViewController *trackTableViewController = [[TracksTableViewController alloc] initDefaultXib];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:trackTableViewController animated:YES];
    
}

- (IBAction)backButtonAction:(UIButton *)sender {
    
    [self killTimers];
    
    [self stopPitchSchifting];
    
    [self stopSound];
    
    [self stopCenterButtonAnimations];
    
    switch (currentViewState) {
            
        case RECORDING_VIEW:
            
            [self setupXib:INITIAL_VIEW];
            break;
            
        case SELECTING_EFFECT_VIEW:
            
            [self setupXib:INITIAL_VIEW];
            break;
            
        case PROCESSING_VIEW:
            
            [self setupXib:SELECTING_EFFECT_VIEW];
            break;
            
        case PREVIEW_VIEW_NOT_PLAYING:
            
            [self setupXib:SELECTING_EFFECT_VIEW];
            break;
            
        case PREVIEW_VIEW_PLAYING:
            
            [self setupXib:SELECTING_EFFECT_VIEW];
            break;
            
        default:
            
            NSLog(@"UNRECOGNIZED STATE! backButtonAction : %d", currentViewState);
            break;
    }
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    
    [self killTimers];
    
    [self stopPitchSchifting];
    
    [self stopSound];
    
    [self stopCenterButtonAnimations];
    
    [self eraseBuffers];
    
    [self setupXib:INITIAL_VIEW];
}

- (IBAction)thirdButtonAction:(UIButton *)sender {
    
    [fifthPSButton setHidden:YES];
    [triadPSButton setHidden:YES];
    
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_THIRD];
}

- (IBAction)fifthButtonAction:(UIButton *)sender {
    
    [thirdPSButton setHidden:YES];
    [triadPSButton setHidden:YES];
    
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_FIFTH];
}

- (IBAction)triadButtonAction:(UIButton *)sender {
    
    [thirdPSButton setHidden:YES];
    [fifthPSButton setHidden:YES];
    
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_TRIAD];
}

- (IBAction)saveButtonAction:(UIButton *)sender {
    
    // Open popup with text view and current date and time:
    InputAlertView *prompt = [[InputAlertView alloc] initWithTitle:@"Save to your device" message:@"Please enter a name to this track" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Save"];
    [prompt setTag:2];
    [prompt show];
    //Show popup to save the track
    
}

- (IBAction)shareButtonAction:(UIButton *)sender {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    NSArray *directoryPath = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath =  [directoryPath objectAtIndex:0];
    NSString *outWavPath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:lastRecording];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outWavPath] == YES) {
        NSLog(@"File exists: %@",outWavPath);
    } else {
        NSLog(@"File does not exist: %@",outWavPath);
    }
    
    NSURL *trackURL = [NSURL fileURLWithPath:outWavPath];
    
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

    NSDate* sourceDate = [NSDate date];
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatters stringFromDate: sourceDate];
    [shareViewController setTitle:[NSString stringWithFormat:@"Back Vocal Sound %@",dateStr]];

    [shareViewController setPrivate:YES];
    [shareViewController setCreationDate:sourceDate];
    [shareViewController setCoverImage:[UIImage imageNamed:@"PSA_0.2_AppIcon_Large.png"]];
    
    // Now present the share view controller.
    [self presentModalViewController:shareViewController animated:YES];
}

- (IBAction)touchDownCenterButtonEvent:(UIButton *)sender {
    [self touchDownCenterButtonAnimation];
}

- (IBAction)touchUpCenterButtonEvent:(UIButton *)sender {
    [self touchUpCenterButtonAnimation];
}

- (IBAction)touchDragOutsideCenterButtonEvent:(UIButton *)sender {
    [self touchUpCenterButtonAnimation];
}

@end