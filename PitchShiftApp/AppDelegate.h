//
//  AppDelegate.h
//  PitchShiftApp
//
//  Created by Alexandre Cordeiro on 9/17/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "MainViewController.h"
#import "PitchShifter.h"
#import "SCUI.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
