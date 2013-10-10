//
//  SplashScreenController.m
//  PitchShiftApp
//
//  Created by Cassio Marcos Goulart on 10/8/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "SplashScreenController.h"

@implementation SplashScreenController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initDefaultXib
{
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if(screenHeight == 480){
        // retina 3.5:
        self = [super initWithNibName:@"SplashScreenController" bundle:nil];
    }else if(screenHeight == 568){
        // retina 4.0:
        self = [super initWithNibName:@"SplashScreenController_i5" bundle:nil];
    }
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

//[UIView animateWithDuration:1.0 animations:^{}completion:^(BOOL finished){}];

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Splash Screen Animations =)
    [UIView animateWithDuration:1.0 animations:^{
        
        backGroundImage.alpha = 1.0;
        
    }completion:^(BOOL finished){
        
        [UIView animateWithDuration:1.0 animations:^{
        
            float screenHeight = [UIScreen mainScreen].bounds.size.height;
            if(screenHeight == 480){
                bImage.frame = CGRectMake(160.0 - bImage.frame.size.width/2.0,
                                          241.0 - bImage.frame.size.height/2.0,
                                          bImage.frame.size.width,
                                          bImage.frame.size.height);
            }else if(screenHeight == 568){
                bImage.frame = CGRectMake(160.0 - bImage.frame.size.width/2.0,
                                          285.0 - bImage.frame.size.height/2.0,
                                          bImage.frame.size.width,
                                          bImage.frame.size.height);
            }

        }completion:^(BOOL finished){
            
            [UIView animateWithDuration:1.0 animations:^{
            
                bImage.alpha = 0.0;
                centerButton.alpha = 1.0;
                ring.alpha = 1.0;
                pressToRecordLabel.alpha = 1.0;
                listButton.alpha = 1.0;
                
            }completion:^(BOOL finished){
            
                [self.navigationController popViewControllerAnimated:NO];
                
            }];
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
