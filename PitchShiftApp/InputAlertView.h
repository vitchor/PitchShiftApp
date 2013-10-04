//
//  InputAlertView.h
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/4/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputAlertView : UIAlertView{
    UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;

@end