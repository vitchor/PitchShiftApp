//
//  SelectorBuilder.h
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/10/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectorBuilder : NSObject{
    
}

@property (nonatomic) NSOperationQueue* myGlobalOperationQueue;

+ (SelectorBuilder *)sharedInstance;
- (void)performSelector:(SEL)aSelector withContext:(id)context;
- (void)doGeneralStuff:(SEL)aSelector withContext:(id)context;
//-(UIViewController*) shareOnSoundCloudWithString:(NSString*)songName shouldLog:(BOOL)shouldLog;
@end
