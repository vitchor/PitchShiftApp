//
//  InputAlertView.m
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/4/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "InputAlertView.h"

@implementation InputAlertView
@synthesize textField, enteredText;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle{
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil]){
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
            [theTextField setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:theTextField];
            self.textField = theTextField;
            CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0);
            [self setTransform:translate];
        }else{
            // else if ios version grather than 7
            self.alertViewStyle = UIAlertViewStylePlainTextInput;
            textField = [self textFieldAtIndex:0];
        }
        
        
        NSDate* sourceDate = [NSDate date];
        NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
        [dateFormatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateStr = [dateFormatters stringFromDate: sourceDate];
        [textField setText:[NSString stringWithFormat:@"%@",dateStr]];
    }
    return self;
}

- (void)show{
    [textField becomeFirstResponder];
    [super show];
}

- (NSString *)enteredText{
    return textField.text;
}
@end