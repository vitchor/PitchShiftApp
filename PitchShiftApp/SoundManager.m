//
//  MainViewController.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/19/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

@synthesize recordEncoding, audioRecorder, audioPlayer, isPlaying;

-(id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.recordEncoding = ENC_PCM;
        isPlaying = NO;
    }
    return self;
}

- (void) startRecordingSound{
    [self startRecordingSoundWithEncoding:ENC_PCM andFileName:@"recorded"];
}

- (void) startRecordingSoundWithEncoding:(int)encoding andFileName:(NSString*)fileName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *newFileName = [[@"/" stringByAppendingString:fileName] stringByAppendingString:@".caf"];
        NSLog(@"startRecording to ");
        self.audioRecorder = nil;
        
        // Init audio with record capability
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
        
        NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
        if(self.recordEncoding == ENC_PCM)
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
            
            switch (self.recordEncoding) {
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
        

        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:newFileName, [self getRecDir]]];
        
        NSError *error = nil;
        self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
        
        if ([self.audioRecorder prepareToRecord] == YES){
            self.audioRecorder.meteringEnabled = YES;
            [self.audioRecorder record];
        } else {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
        NSLog(@"recording");
    });
    
}

- (NSString*)getRecDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *recDir = [paths objectAtIndex:0];
    return recDir;
}


- (void) stopRecordingSoundAndSaveToWav:(BOOL)saveToWav withName:(NSString*)wavName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"stopRecording");

        [self.audioRecorder stop];
        NSLog(@"stopped");
        
        if (saveToWav) {
            NSString *filePath = [[audioRecorder url] absoluteString];
            if ( ![self exportAssetAsWaveFormatWithInput:filePath andOutput:wavName]) {
                NSLog(@"ERROR IN WAV CONVERSION!");
            }
        }
    });
    
}

- (void)playSound{
    [self playSound:@"result-pitchshifted.wav"];
}

- (void)playSound:(NSString*) outWavName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *outWavPath = [[[self getRecDir] stringByAppendingString:@"/"] stringByAppendingString:outWavName];
        
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

        if(!audioPlayer){
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        }
        
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
        isPlaying = YES;
    });
}

- (void)stopSound {
    if(audioPlayer.isPlaying){
        [audioPlayer stop];
        audioPlayer.currentTime = 0;
        isPlaying = NO;
    }
}

- (void)pauseSound {
    if(audioPlayer.isPlaying)
        [audioPlayer pause];
        isPlaying = NO;
}


-(BOOL)exportAssetAsWaveFormatWithInput:(NSString*)inputFilePath andOutput:(NSString*)outputFileName
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
    
    NSString *audioFilePath = inputFilePath;
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
    
    
    NSString *outPath = [[[self getRecDir] stringByAppendingPathComponent :outputFileName]
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

-(UIViewController*) shareOnSoundCloudWithString:(NSString*)songName shouldLog:(BOOL)shouldLog{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    NSArray *directoryPath = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath =  [directoryPath objectAtIndex:0];
    NSString *outWavPath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:songName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(shouldLog){
        if ([fileManager fileExistsAtPath:outWavPath] == YES) {
            NSLog(@"File exists: %@",outWavPath);
        } else {
            NSLog(@"File does not exist: %@",outWavPath);
        }
    }
    
    NSURL *trackURL = [NSURL fileURLWithPath:outWavPath];
    SCShareViewController *shareViewController;
    shareViewController = [SCShareViewController shareViewControllerWithFileURL:trackURL
                                                              completionHandler:^(NSDictionary *trackInfo, NSError *error){
                                                                  if (SC_CANCELED(error)) {
                                                                      if (shouldLog) NSLog(@"Canceled!");
                                                                  } else if (error) {
                                                                      if (shouldLog) NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                  } else {
                                                                      // If you want to do something with the uploaded
                                                                      // track this is the right place for that.
                                                                      NSString *downloadLink = [trackInfo objectForKey:@"permalink_url"];
                                                                      NSLog(@"====Uploaded track: %@", downloadLink);
                                                                      AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//                                                                      [appDelegate logEvent:downloadLink];
                                                                      [appDelegate logEvent:@"Upload to SoundCloud" withParameters:downloadLink];
                                                                  }
                                                              }];
    
    NSDate* sourceDate = [NSDate date];
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateStr = [dateFormatters stringFromDate: sourceDate];
    [shareViewController setTitle:[NSString stringWithFormat:@"Back Vocal Sound %@",dateStr]];
    
    [shareViewController setPrivate:NO];
    [shareViewController setCreationDate:sourceDate];
    [shareViewController setCoverImage:[UIImage imageNamed:@"PSA_0.2_AppIcon_Large.png"]];
    
    // Now present the share view controller.
    //    [self presentViewController:shareViewController animated:YES completion:nil];
    return shareViewController;
}

@end