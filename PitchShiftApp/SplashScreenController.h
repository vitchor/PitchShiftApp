//
//  SplashScreenController.h
//  PitchShiftApp
//
//  Created by Cassio Marcos Goulart on 10/8/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashScreenController : UIViewController
{
    IBOutlet UIImageView *backGroundImage;
    IBOutlet UIImageView *bImage;
    IBOutlet UIImageView *ring;
    IBOutlet UIButton *centerButton;
    IBOutlet UIButton *listButton;
    IBOutlet UILabel *pressToRecordLabel;
}

- (id)initDefaultXib;

@end
