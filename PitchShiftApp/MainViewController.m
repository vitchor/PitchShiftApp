//
//  MainViewController.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "MainViewController.h"

float GlobalAudioSampleRate = 32000;

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
    
    progressBar.frame = CGRectMake(progressBar.frame.origin.x, progressBar.frame.origin.y, 1.0, progressBar.frame.size.height);
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    [self setupXib:INITIAL_VIEW];
}

// Add this method
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupXib:(int)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch (state) {
                
            case INITIAL_VIEW:
                
                [centerButton setHidden:NO];
                [centerTextLabel setHidden:NO];
                //[listButton setHidden:NO];
                [listButton setHidden:YES];

                [downloadButton setHidden:YES];
                [cancelButton setHidden:YES];
                [shareButton setHidden:YES];
                [progressBarBackground setHidden:YES];
                [progressBar setHidden:YES];
                [selectingEffectView setHidden:YES];
                [floatingCircle setHidden:YES];
                [floatingCircleInverse setHidden:YES];
                
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.1_CenterButton.png"] forState:UIControlStateNormal];
                
                currentViewState = INITIAL_VIEW;
                
                break;
                
            case RECORDING_VIEW:
                
                [centerButton setHidden:NO];
                
                [centerTextLabel setHidden:YES];
                [listButton setHidden:YES];
                [downloadButton setHidden:YES];
                [cancelButton setHidden:YES];
                [shareButton setHidden:YES];
                [progressBarBackground setHidden:YES];
                [progressBar setHidden:YES];
                [selectingEffectView setHidden:YES];
                [floatingCircle setHidden:NO];
                [floatingCircleInverse setHidden:NO];
                
                [centerButton setImage:[UIImage imageNamed:@"PSA_0.1_StopButton.png"] forState:UIControlStateNormal];
                
                currentViewState = RECORDING_VIEW;

                break;
                
            case SELECTING_EFFECT_VIEW:
                
                [selectingEffectView setHidden:NO];
                
                [cancelButton setHidden:YES];
                [centerButton setHidden:YES];
                [centerTextLabel setHidden:YES];
                [listButton setHidden:YES];
                [downloadButton setHidden:YES];
                [shareButton setHidden:YES];
                [progressBarBackground setHidden:YES];
                [progressBar setHidden:YES];
                [floatingCircle setHidden:YES];
                [floatingCircleInverse setHidden:YES];

                currentViewState = SELECTING_EFFECT_VIEW;
                
                break;
            
            case PROCESSING_VIEW:
                
                [centerButton setHidden:NO];
                [progressBarBackground setHidden:NO];
                [progressBar setHidden:NO];
                [cancelButton setHidden:NO];
                
                [centerTextLabel setHidden:YES];
                [listButton setHidden:YES];
                [downloadButton setHidden:YES];
                [shareButton setHidden:YES];
                [selectingEffectView setHidden:YES];
                [floatingCircle setHidden:YES];
                [floatingCircleInverse setHidden:YES];

                [centerButton setImage:[UIImage imageNamed:@"PSA_0.1_CenterButton.png"] forState:UIControlStateNormal];
                
                currentViewState = PROCESSING_VIEW;
                
                break;
                
            case PREVIEW_VIEW_NOT_PLAYING:
                
                [centerButton setHidden:NO];
                [downloadButton setHidden:NO];
                [shareButton setHidden:NO];
                [cancelButton setHidden:NO];
                
                [centerTextLabel setHidden:YES];
                [listButton setHidden:YES];
                [progressBarBackground setHidden:YES];
                [progressBar setHidden:YES];
                [selectingEffectView setHidden:YES];
                [floatingCircle setHidden:YES];
                [floatingCircleInverse setHidden:YES];

                [centerButton setImage:[UIImage imageNamed:@"PSA_0.1_PlayButton.png"] forState:UIControlStateNormal];

                currentViewState = PREVIEW_VIEW_NOT_PLAYING;
                
                break;
            
            case PREVIEW_VIEW_PLAYING:
                
                [centerButton setHidden:NO];
                [downloadButton setHidden:NO];
                [shareButton setHidden:NO];
                [cancelButton setHidden:NO];
                
                [centerTextLabel setHidden:YES];
                [listButton setHidden:YES];
                [progressBarBackground setHidden:YES];
                [progressBar setHidden:YES];
                [selectingEffectView setHidden:YES];
                [floatingCircle setHidden:YES];
                [floatingCircleInverse setHidden:YES];

                [centerButton setImage:[UIImage imageNamed:@"PSA_0.1_StopButton.png"] forState:UIControlStateNormal];
                
                currentViewState = PREVIEW_VIEW_PLAYING;
                
                break;
                
            case PLAYER_VIEW:
                
                [centerButton setHidden:NO];
                [shareButton setHidden:NO];
                [cancelButton setHidden:NO];
                
                [downloadButton setHidden:YES];
                [centerTextLabel setHidden:YES];
                [listButton setHidden:YES];
                [progressBarBackground setHidden:YES];
                [progressBar setHidden:YES];
                [selectingEffectView setHidden:YES];
                [floatingCircle setHidden:YES];
                [floatingCircleInverse setHidden:YES];
                
                currentViewState = PLAYER_VIEW;
                
                break;
                
            default:
                
                NSLog(@"UNRECOGNIZED STATE! setupXib : %d", state);
                
                break;
        }
        
    });
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
            [recordSettings setObject:[NSNumber numberWithFloat:GlobalAudioSampleRate] forKey: AVSampleRateKey];
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
            [recordSettings setObject:[NSNumber numberWithFloat:GlobalAudioSampleRate] forKey: AVSampleRateKey];
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
    levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.03 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    
    animationTimer = [NSTimer scheduledTimerWithTimeInterval: 0.025 target: self selector: @selector(animateCircles) userInfo: nil repeats: YES];
}

-(void)animateCircles{
    
//    CGAffineTransform transformScale = CGAffineTransformMakeScale((float)((float)rand()/(float)INT32_MAX), (float)((float)rand()/(float)INT32_MAX));
//    CGAffineTransform transformRotateInverse = CGAffineTransformRotate(floatingCircleInverse.transform, 0.01);
//    CGAffineTransform transformRotate = CGAffineTransformRotate(floatingCircle.transform, -0.01);
//    
//
//    
//    NSLog(@"TIMEEEEERRRRRR");
//    
//    [UIView animateWithDuration:0.025 animations:^(void){
//        floatingCircleInverse.transform = transformRotateInverse;
//        floatingCircle.transform = transformRotate;
//    }];
}

- (void)levelTimerCallback:(NSTimer *)timer {
    
    float angle = 0;
    
    floatingCircle.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    if (audioRecorder) {
        [audioRecorder updateMeters];
        float circleMinSize = 200;
        float circleMaxSize = 300;
        float circleCurrentSize;
        float invCircleMinSize = 200;
        float invCircleMaxSize = 300;
        float invCircleCurrentSize;
        
        angle = angle + 0.1;
        
        const double ALPHA = 0.05;
        double averagePowerForChannel = pow(10, (0.05 * [audioRecorder averagePowerForChannel:0]));
        lowPassResults = ALPHA * averagePowerForChannel + (1.0 - ALPHA) * lowPassResults;
        
        //NSLog(@"Average input: %f Peak input: %f Low pass results:%f", [audioRecorder averagePowerForChannel:0], [audioRecorder peakPowerForChannel:0], lowPassResults);
        circleCurrentSize = circleMinSize + (circleMaxSize-circleMinSize)*lowPassResults;
        invCircleCurrentSize = invCircleMinSize + (invCircleMaxSize-invCircleMinSize)*(1-lowPassResults);
        
////        CGAffineTransform transformScale = CGAffineTransformMakeScale(circleCurrentSize, circleCurrentSize);
//        CGAffineTransform transformRotate = CGAffineTransformMakeRotation(angle);
//        
//        
//        
//        NSLog(@"TIMEEEEERRRRRR");
//        
////        [UIView animateWithDuration:0.0002 animations:^(void){
//        
//            floatingCircleInverse.transform = transformRotate;
//            
////        }];
//
//        
//        
        floatingCircle.frame = CGRectMake(160-circleCurrentSize/2, 208-circleCurrentSize/2, circleCurrentSize, circleCurrentSize);
        
        
        floatingCircleInverse.frame = CGRectMake(160-invCircleCurrentSize/2, 208-invCircleCurrentSize/2, invCircleCurrentSize, invCircleCurrentSize);
//        floatingCircle.transform = CGAffineTransformRotate(floatingCircle.transform, 0.001);
        
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
            NSLog(@"DEU PAAAAAAAAUUUUUUUUUU");
        }
        
    });
    [levelTimer invalidate];
}

-(BOOL)exportAssetAsWaveFormat:(NSString*)filePath
{
    NSError *error = nil ;
    
    NSDictionary *audioSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSNumber numberWithFloat:GlobalAudioSampleRate], AVSampleRateKey,
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
    
    progress = 0.1;
    
    usleep(100000);
    
    progressBarTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector: @selector(updateProgressBar) userInfo: nil repeats: YES];
}

-(void) updateProgressBar {
    
    if (progress < 0.99){
        
        progress = [pitchShifter getProgressStatus];
        
        if (progress != 0.0 && !(progress != progress) && progress != -1.0) {
            
            NSLog(@"STATUS: %f ",progress);
            
                progressBar.frame = CGRectMake(progressBar.frame.origin.x, progressBar.frame.origin.y, progress * PROGRESS_BAR_FULL_WIDTH, progressBar.frame.size.height);
        }
    }
    else
    {
        progressBar.frame = CGRectMake(progressBar.frame.origin.x, progressBar.frame.origin.y, PROGRESS_BAR_FULL_WIDTH, progressBar.frame.size.height);
        
        [progressBarTimer invalidate], progressBarTimer = nil;
        
        [self setupXib:PREVIEW_VIEW_NOT_PLAYING];
    }
    
}

- (void)doPitchShift:(NSString *)inWavPath type:(int)pitchShiftType{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    
        //Get wav file's directory
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *outWavName = @"/result-pitchshifted.wav";
        
        NSArray *directoriesPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath =  [directoriesPath objectAtIndex:0];
        
        NSString *outWavPath = [documentsPath stringByAppendingString:outWavName];
        
        NSError *error = nil ;
        if([[NSFileManager defaultManager] fileExistsAtPath:outWavPath])
            [[NSFileManager defaultManager] removeItemAtPath:outWavPath error:&error];
        
        char *inWavPathCharArray = [inWavPath UTF8String];
        
        char *outWavPathCharArray = [outWavPath UTF8String];
        
        pitchShifter = [PitchShifter alloc];
        
        [pitchShifter pitchShiftWavFile:inWavPathCharArray andOutFilePath:outWavPathCharArray andShiftType:pitchShiftType];
    
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
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //NSLog(@"%@",error);
        
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
        
        NSLog(@"TERMINEI DE TOCAR");
        
    });
}

- (void)stopSound {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [audioPlayer stop];
    });
}

- (IBAction)centerButtonAction:(UIButton *)sender {
    
    switch (currentViewState) {
        
        case INITIAL_VIEW:
            
            // change center button
            
            [self startRecordingSound];
            
            [self setupXib:RECORDING_VIEW];
            
            break;
            
        case RECORDING_VIEW:
            
            [self stopRecordingSound];
            
            [self setupXib:SELECTING_EFFECT_VIEW];
            
            // do selecting
            
            break;
            
        case PROCESSING_VIEW:
            
            //[self setupXib:PREVIEW_VIEW_NOT_PLAYING];
            
            // do preview
            
            break;
            
        case PREVIEW_VIEW_NOT_PLAYING:
            
            // do player sound
            [self setupXib:PREVIEW_VIEW_PLAYING];
            [self playSound];
            break;
            
        case PREVIEW_VIEW_PLAYING:
            [self setupXib:PREVIEW_VIEW_NOT_PLAYING];
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

- (IBAction)listButtonAction:(id)sender {
}

- (IBAction)downloadButtonAction:(UIButton *)sender {
}

- (IBAction)cancelButtonAction:(UIButton *)sender {
    if (pitchShifter) {
        pitchShifter = nil;
    }
    
    if (progressBarTimer) {
        [progressBarTimer invalidate], progressBarTimer = nil;
    }
    
    [self setupXib:INITIAL_VIEW]; //testing - avoid app termination
}

- (IBAction)shareButtonAction:(UIButton *)sender {
}

- (IBAction)selectThirdButtonAction:(UIButton *)sender {
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_THIRD];
}

- (IBAction)selectFifthButtonAction:(UIButton *)sender {
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_FIFTH];
}

- (IBAction)selectTriadButtonAction:(UIButton *)sender {
    [self setupXib:PROCESSING_VIEW];
    [self processSound:SHIFT_TRIAD];
}
@end