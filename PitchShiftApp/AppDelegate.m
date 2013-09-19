//
//  AppDelegate.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/17/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "AppDelegate.h"
#import "PitchShifter.h"

@implementation AppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Configures UINavigationController:
    
    self.navigationController = [[UINavigationController alloc] init];
    self.window.rootViewController = self.navigationController;
    
    [self.window addSubview:self.navigationController.view];
    
//    //Get wav file's directory
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
    
    //[pitchShifter pitchShiftWavFile];
    
    NSString *documentsDirectoryPath = [directoryPaths objectAtIndex:0];
    if ([fileManager fileExistsAtPath:outWavPath]==YES) {
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
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
