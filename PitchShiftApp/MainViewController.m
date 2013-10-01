//
//  MainViewController.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "MainViewController.h"

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
    
    recordEncoding = ENC_PCM;
    currentViewState = INITIAL_VIEW;
    fadingTime = FADING_TIME_DEFAULT;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        //[self prefersStatusBarHidden];
        [self preferredStatusBarStyle];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    [self setupXib:INITIAL_VIEW];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupXib:(int)state
{
    dispatch_async(dispatch_get_main_queue(), ^{

        
        if(state == PROCESSING_VIEW)
            fadingTime = FADING_TIME_PS_BUTTONS;
        else
            fadingTime = FADING_TIME_DEFAULT;
        
        centerButton.alpha = 1.0;
        ring.alpha = 1.0;
        centerTextLabel.alpha = 1.0;
        progressBarBackground.alpha = 1.0;
        progressBar.alpha = 1.0;
        bottomCircle.alpha = 1.0;
        middleCircle.alpha = 1.0;
        topCircle.alpha = 1.0;
        thirdPSButton.alpha = 1.0;
        fifthPSButton.alpha = 1.0;
        triadPSButton.alpha = 1.0;
        
        [UIView animateWithDuration:fadingTime animations:^{
            
            if(state==INITIAL_VIEW){
                backButton.alpha = 0.0;
                cancelButton.alpha = 0.0;
            }
            
            centerButton.alpha = 0.0;
            ring.alpha = 0.0;
            centerTextLabel.alpha = 0.0;
            progressBarBackground.alpha = 0.0;
            progressBar.alpha = 0.0;
            bottomCircle.alpha = 0.0;
            middleCircle.alpha = 0.0;
            topCircle.alpha = 0.0;
            thirdPSButton.alpha = 0.0;
            fifthPSButton.alpha = 0.0;
            triadPSButton.alpha = 0.0;

            
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
                    
                    [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton.png"] forState:UIControlStateNormal];
                    [ring setImage:[UIImage imageNamed:@"PSA_0.2_Ring.png"]];

                    centerButton.alpha = 1.0;
                    ring.alpha = 1.0;
                    centerTextLabel.alpha = 1.0;
                    
                    currentViewState = INITIAL_VIEW;
                    
                    break;
                    
                case RECORDING_VIEW:
                    
                    centerButton.transform = CGAffineTransformIdentity;
                    [centerButton setHidden:NO];
                    [ring setHidden:NO];
                    [backButton setHidden:NO];
                    [cancelButton setHidden:NO];
                    [bottomCircle setHidden:NO];
                    [middleCircle setHidden:NO];
                    [topCircle setHidden:NO];
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];
                    
                    [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton.png"] forState:UIControlStateNormal];
                    [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning.png"]];
                    
                    centerButton.alpha = 1.0;
                    ring.alpha = 1.0;
                    backButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    bottomCircle.alpha = 1.0;
                    middleCircle.alpha = 1.0;
                    topCircle.alpha = 1.0;
                    
                    currentViewState = RECORDING_VIEW;

                    break;
                    
                case SELECTING_EFFECT_VIEW:
                    
                    [thirdPSButton setHidden:NO];
                    [fifthPSButton setHidden:NO];
                    [triadPSButton setHidden:NO];
                    [backButton setHidden:NO];
                    [cancelButton setHidden:NO];
                    
                    [centerButton setHidden:YES];
                    [ring setHidden:YES];
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];

                    thirdPSButton.alpha = 1.0;
                    fifthPSButton.alpha = 1.0;
                    triadPSButton.alpha = 1.0;
                    backButton.alpha = 1.0;
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

    //                [centerButton setImage:[UIImage imageNamed:@"PSA_0.1_PlayButton.png"] forState:UIControlStateNormal];
                    [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_CenterButton.png"] forState:UIControlStateNormal];
                    [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning.png"]];

                    
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
                    
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];

                    [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_PlayButton.png"] forState:UIControlStateNormal];
                    [ring setImage:[UIImage imageNamed:@"PSA_0.2_Ring.png"]];

                    centerButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    backButton.alpha = 1.0;
                    
                    currentViewState = PREVIEW_VIEW_NOT_PLAYING;
                    
                    break;
                
                case PREVIEW_VIEW_PLAYING:
                    
                    centerButton.transform = CGAffineTransformIdentity;
                    [centerButton setHidden:NO];
                    [cancelButton setHidden:NO];
                    [ring setHidden:NO];
                    [backButton setHidden:NO];
                    
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];

                    [centerButton setImage:[UIImage imageNamed:@"PSA_0.2_StopButton.png"] forState:UIControlStateNormal];
                    [ring setImage:[UIImage imageNamed:@"PSA_0.2_RingSpinning.png"]];
                    
                    centerButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    backButton.alpha = 1.0;
                    
                    currentViewState = PREVIEW_VIEW_PLAYING;
                    
                    break;
                    
                case PLAYER_VIEW:
                    
                    centerButton.transform = CGAffineTransformIdentity;
                    [centerButton setHidden:NO];
                    [ring setHidden:NO];
                    [cancelButton setHidden:NO];
                    [backButton setHidden:NO];
                    
                    [centerTextLabel setHidden:YES];
                    [progressBarBackground setHidden:YES];
                    [progressBar setHidden:YES];
                    [bottomCircle setHidden:YES];
                    [middleCircle setHidden:YES];
                    [topCircle setHidden:YES];
                    [thirdPSButton setHidden:YES];
                    [fifthPSButton setHidden:YES];
                    [triadPSButton setHidden:YES];
                    
                    centerButton.alpha = 1.0;
                    cancelButton.alpha = 1.0;
                    backButton.alpha = 1.0;
            
                    currentViewState = PLAYER_VIEW;
                    
                    break;
                    
                default:
                    
                    NSLog(@"UNRECOGNIZED STATE! setupXib : %d", state);
                    
                    break;
            } // switch end
            
            [UIView commitAnimations];
        
            
        }]; // block end
        
    }); // thread end
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
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recorded.caf", recDir]];
        
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
    
    recordTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback) userInfo: nil repeats: YES];
}

- (void)levelTimerCallback {
    
    if (audioRecorder) {
        [audioRecorder updateMeters];

        const double ALPHA = 0.05;
        double averagePowerForChannel = pow(10, (0.05 * [audioRecorder averagePowerForChannel:0]));
        lowPassResults = ALPHA * averagePowerForChannel + (1.0 - ALPHA) * lowPassResults;
        
        //NSLog(@"Average input: %f Peak input: %f Low pass results:%f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0], lowPassResults);
        
        float botCircleCurrentSize = BOT_CIRCLE_MIN_SIZE + (BOT_CIRCLE_MAX_SIZE-BOT_CIRCLE_MIN_SIZE)*lowPassResults;
        float midCircleCurrentSize = MID_CIRCLE_MIN_SIZE + (MID_CIRCLE_MAX_SIZE-MID_CIRCLE_MIN_SIZE)*lowPassResults;
//        float topCircleCurrentSize = TOP_CIRCLE_MIN_SIZE + (TOP_CIRCLE_MAX_SIZE-TOP_CIRCLE_MIN_SIZE)*lowPassResults;
        
        float botCircleScale = botCircleCurrentSize/BOT_CIRCLE_MAX_SIZE;
        float midCircleScale = midCircleCurrentSize/MID_CIRCLE_MAX_SIZE;
//        float topCircleScale = topCircleCurrentSize/TOP_CIRCLE_MAX_SIZE;
        
        rotationAngle += CIRCLE_ROTATION_INCREMENT;
        
        //DO THE FUCKING ANIMATION!
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.03];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationRepeatCount:1];
        
        CGAffineTransform botTransfScale = CGAffineTransformMakeScale(botCircleScale, botCircleScale);
        CGAffineTransform midTransfScale = CGAffineTransformMakeScale(midCircleScale,midCircleScale);
//        CGAffineTransform topTransfScale = CGAffineTransformMakeScale(topCircleScale,topCircleScale);

        CGAffineTransform botTransformRotate = CGAffineTransformMakeRotation(rotationAngle);
        CGAffineTransform midTransformRotate = CGAffineTransformMakeRotation(-rotationAngle);
//        CGAffineTransform topTransformRotate = CGAffineTransformMakeRotation(rotationAngle);

        bottomCircle.transform = CGAffineTransformConcat(botTransformRotate, botTransfScale);
        middleCircle.transform = CGAffineTransformConcat(midTransformRotate, midTransfScale);
//        topCircle.transform = CGAffineTransformConcat(topTransformRotate, topTransfScale);
        
        // Make the ring spin:
        
        ring.transform = CGAffineTransformMakeRotation(-rotationAngle*2);
        
        [UIView commitAnimations];
        
    } else {
        NSLog(@"Timer still running");
    }
}

- (void) stopRecordingSound
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"stopRecording");
        [audioRecorder stop];
        NSLog(@"stopped");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *recDir = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/recorded.caf", recDir];
        
        if ( ![self exportAssetAsWaveFormat:filePath]) {
            NSLog(@"ERROR IN WAV CONVERSION!");
        }
        
    });
    
    [recordTimer invalidate], recordTimer = nil;
    
}

-(BOOL)exportAssetAsWaveFormat:(NSString*)filePath
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
    
    NSString *audioFilePath = filePath;
    AVURLAsset * URLAsset = [[AVURLAsset alloc]  initWithURL:[NSURL fileURLWithPath:audioFilePath] options:nil];
    
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
    
    
    NSString *title = @"recordedWAV";
    NSArray *docDirs = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [docDirs objectAtIndex: 0];
    NSString *outPath = [[docDir stringByAppendingPathComponent :title]
                         stringByAppendingPathExtension:@"wav" ];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:outPath])
        [[NSFileManager defaultManager] removeItemAtPath:outPath error:&error];
    
    NSURL *outURL = [NSURL fileURLWithPath:outPath];
    
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
    NSString *inWavPath = [NSString stringWithFormat:@"%@/recordedWAV.wav", recDir];

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
        
        //centerButton.transform = CGAffineTransformRotate(centerButton.transform, CIRCLE_ROTATION_INCREMENT/2);
        ring.transform = CGAffineTransformRotate(ring.transform, -2.5*CIRCLE_ROTATION_INCREMENT);
        
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
        NSString *outWavName = @"/result-pitchshifted.wav";
        
        NSArray *directoriesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath =  [directoriesPath objectAtIndex:0];
        
        NSString *outWavPath = [documentsPath stringByAppendingString:outWavName];
        
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
        
        isProcessing = NO;
    
    });
}

- (void)playSound {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray *directoryPath = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath =  [directoryPath objectAtIndex:0];
        NSString *outWavName = @"/result-pitchshifted.wav";
        NSString *outWavPath = [documentsPath stringByAppendingString:outWavName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:outWavPath] == YES) {
            NSLog(@"File exists: %@",outWavPath);
        } else {
            NSLog(@"File does not exist");
        }
        
        NSURL *url = [NSURL fileURLWithPath:outWavPath];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        NSError *error = nil ;

//        if(!audioPlayer)
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
            //NSLog(@"%@",error);
        
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
        startedPlaying = true;
        
    });
    
     playerTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(checkPlayer) userInfo: nil repeats: YES];
}

-(void)checkPlayer{
    
    if(audioPlayer && startedPlaying){
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

- (void)stopSound {
    if(audioPlayer.isPlaying)
        [audioPlayer stop];
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

- (IBAction)uploadAction:(UIButton *)sender {
    
    NSURL *trackURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"sax" ofType:@"mp3"]];
    
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
    [self presentModalViewController:shareViewController animated:YES];
}

- (IBAction)centerButtonAction:(UIButton *)sender {
    
    switch (currentViewState) {
        
        case INITIAL_VIEW:
            
            // change center button
            
            [self setupXib:RECORDING_VIEW];
        
            [self startRecordingSound];
            
            break;
            
        case RECORDING_VIEW:
            
            [self stopRecordingSound];
            
            [self setupXib:SELECTING_EFFECT_VIEW];
            
            // do selecting
            
            break;
            
        case PROCESSING_VIEW:
            
            // do nothing
            
            break;
            
        case PREVIEW_VIEW_NOT_PLAYING:
            
            // do player sound
            [self playSound];
            [self setupXib:PREVIEW_VIEW_PLAYING];
            break;
            
        case PREVIEW_VIEW_PLAYING:
//            [self setupXib:PREVIEW_VIEW_NOT_PLAYING];
            [self stopSound];
            
            
            break;
            
        case PLAYER_VIEW:
            
            // do player selected sound
            
            break;
            
        default:
            
            NSLog(@"UNRECOGNIZED STATE! centerButtonAction : %d", currentViewState);
            
            break;
    }
}

- (IBAction)backButtonAction:(UIButton *)sender {
    
    [self killTimers];
    
    [self stopPitchSchifting];
    
    [self stopSound];
    
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
            
        case PLAYER_VIEW:
            [self setupXib:INITIAL_VIEW];
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
    
    [self setupXib:INITIAL_VIEW];
}

- (IBAction)selectThirdButtonAction:(UIButton *)sender {
    
    [fifthPSButton setHidden:YES];
    [triadPSButton setHidden:YES];
    
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_THIRD];
}

- (IBAction)selectFifthButtonAction:(UIButton *)sender {
    
    [thirdPSButton setHidden:YES];
    [triadPSButton setHidden:YES];
    
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_FIFTH];
}

- (IBAction)selectTriadButtonAction:(UIButton *)sender {
    
    [thirdPSButton setHidden:YES];
    [fifthPSButton setHidden:YES];
    
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_TRIAD];
}

- (IBAction)shareButtonAction:(UIButton *)sender {
}

@end