//
//  AppDelegate.m
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/17/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize navigationController;

+ (void)initialize;
{
    [SCSoundCloud  setClientID:@"7185fbbd173252ddd2b8c8cbc601b489"
                        secret:@"d4ca6945bddca0714df0c4a40d54464c"
                   redirectURL:[NSURL URLWithString:@"backvocal://oauth2"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"2Y8VBJZ4TCH728HFXTG5"];
    //your code
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Configures UINavigationController:
    
    self.navigationController = [[UINavigationController alloc] init];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = self.navigationController;
    
    [self.window addSubview:self.navigationController.view];
    
    MainViewController *mainViewController = [[MainViewController alloc] initDefaultXib];
    
    [self.navigationController pushViewController:mainViewController animated:NO];
    
    // Navigation bar background image:
    UIImage *navBackgroundImage;
    
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(screenHeight == 480){
        // retina 3.5:
         navBackgroundImage = [UIImage imageNamed:@"PSA_0.2_Background.png"];
    }else if(screenHeight == 568){
        // retina 4.0:
         navBackgroundImage = [UIImage imageNamed:@"PSA_0.2_Background_i5.png"];
    }
   
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];

    // Navigation bar title text color:
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor, nil]];
    //Navigation bar back button color:
    self.window.tintColor = [UIColor whiteColor];
    
    //StatusBar color for the whole app (Also needs to define a variable in the *.plist file: [“View controller-based status bar appearance” = NO]:
    [ [ UIApplication sharedApplication ] setStatusBarStyle : UIStatusBarStyleLightContent ] ;
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

-(void) logEvent:(NSString *) event {
    [Flurry logEvent:event];
}

-(void) logEvent:(NSString *) event withParameters:(NSString*)soundCloudLink{
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   soundCloudLink, @"Sound Cloud Link",
                                   nil];
    
    [Flurry logEvent:event withParameters:articleParams];
}

@end
