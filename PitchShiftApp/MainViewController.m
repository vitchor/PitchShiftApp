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
    
<<<<<<< HEAD
    recordEncoding = ENC_PCM;
    
    pickerStatus = [[NSArray alloc] initWithObjects:@"Third shift", @"Fifth shift", @"Triad shift", nil];}
=======
    recordEncoding = ENC_AAC;
}
>>>>>>> 76140f2a13da2f7e054e0f678036b1228b9891b8

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) recordButtonAction:(UIButton *)sender
{
    if(!isRecording){
        
        [sender setTitle:@"Recording..." forState:UIControlStateNormal];
        
        isRecording = true;
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
            [audioRecorder record];
        }else {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
        NSLog(@"recording");
    
    }else{
    
        [sender setTitle:@"Record" forState:UIControlStateNormal];
        
        isRecording = false;
        NSLog(@"stopRecording");
        [audioRecorder stop];
        NSLog(@"stopped");
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *recDir = [paths objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/recorded.caf", recDir];
        
        if ( ![self exportAssetAsWaveFormat:filePath]) {
            NSLog(@"DEU PAAAAAAAAUUUUUUUUUU");
        }

    }
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
    
    if (![assetWriter canAddInput:assetWriterInput]) return NO ;
    
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

- (IBAction)processButtonAction:(UIButton *)sender {


    [sender setTitle:@"Processing..." forState:UIControlStateNormal];
    

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self processSound];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [sender setTitle:@"Process" forState:UIControlStateNormal];
            
        });
    });
    
}

-(void) processSound{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    NSString *inWavPath = [NSString stringWithFormat:@"%@/recordedWAV.wav", recDir];

    [self doPitchShift:inWavPath];
}

- (void)doPitchShift:(NSString *)inWavPath {
    
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
    
    PitchShifter *pitchShifter = [PitchShifter alloc];
    [pitchShifter pitchShiftWavFile:inWavPathCharArray andOutFilePath:outWavPathCharArray];
    
}


- (IBAction)playButtonAction:(UIButton *)sender {
    
    
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
    NSLog(@"%@",error);
    
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    
    NSLog(@"%@",error);

    [sender setTitle:@"Play" forState:UIControlStateNormal];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return pickerStatus.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [pickerStatus objectAtIndex:row];
}




////// NOT USED:

-(IBAction) stopRecording:(UIButton *)sender
{
    NSLog(@"stopRecording");
    [audioRecorder stop];
    NSLog(@"stopped");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/recorded.caf", recDir];
    
    if ( ![self exportAssetAsWaveFormat:filePath]) {
        NSLog(@"DEU PAAAAAAAAUUUUUUUUUU");
    }
}

-(IBAction) playRecording:(UIButton *)sender
{
    NSLog(@"playRecording");
    // Init audio with playback capability
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordTest.caf", recDir]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/recordedWAV.wav", recDir]];
    
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *inWavName = @"sax.wav";
//    NSString *inWavPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:inWavName];
//    NSURL *url2 = [NSURL fileURLWithPath:inWavPath];
    
    NSError *error;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
    NSLog(@"playing");
}

-(IBAction) stopPlaying:(UIButton *)sender
{
    NSLog(@"stopPlaying");
    [audioPlayer stop];
    NSLog(@"stopped");
}


@end
