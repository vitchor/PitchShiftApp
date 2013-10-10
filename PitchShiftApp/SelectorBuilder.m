//
//  SelectorBuilder.m
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/10/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#import "SelectorBuilder.h"

@implementation SelectorBuilder

- (id)init{
    self = [super init];
    if (self){
        self.myGlobalOperationQueue = [[NSOperationQueue alloc] init];
    }
    return self;
}

//Singleton Pattern instance:
+ (SelectorBuilder *)sharedInstance{
    static SelectorBuilder *sharedInstance = nil;
    static dispatch_once_t isDispatched;
    
    dispatch_once(&isDispatched, ^
                  {
                      sharedInstance = [[SelectorBuilder alloc] init];
                  });
    
    return sharedInstance;
}

//Perform selector with more than 2 entries:
/** Calls arbitary methods inside of a new thread. */
- (void)performSelector:(SEL)aSelector withContext:(id)context{
    // Before we get ahead of ourselves, let's do some
    // sanity checking on the context object pass
    // to the method.
    int i = 0;
    NSLog(@"0%i", i++);
    NSInvocationOperation *theOperation ;
    if ([context isKindOfClass:[NSArray class]])
    {
            NSLog(@"1 %i", i++);
        // The docs explicity tell you not to use alloc/init,
        // but instead, use the class method invocationWithMethodSignature,
        // which takes a selector and returns its method's signature.
        NSMethodSignature *theSignature = [self methodSignatureForSelector:aSelector];
            NSLog(@"2 %i", i++);
            NSLog(@"SELECTOR %@", NSStringFromSelector(aSelector));
        // With our signature in hand, we can now call our
        // class method, which returns a usable (and autoreleased)
        // NSInvocation instance.
//        NSInvocation *theInvocation = [NSInvocation invocationWithMethodSignature:theSignature];
        
        NSInvocation* theInvocation = [NSInvocation invocationWithMethodSignature:
                             [self methodSignatureForSelector:aSelector]];
//        [inv setTarget:self];
//        [inv setSelector:aSelector];
            NSLog(@"3 %i", i++);
        // Now for the real automagic fun!  We will loop through our context array,
        // and match up each parameter with the corresponding value
        // passed to us in our array.  First we will check to see if the there
        // are the same number of parameters and argument values (always nice).
        // Since we know context is a kind of NSArray, we cast it as one.
        NSArray *parameterValues = (NSArray *)context;
            NSLog(@"3 %i", i++);
        NSUInteger parameterCount = [parameterValues count];
            NSLog(@"%i", i++);
        // Objective-C actually converts selectors into C methods, and
        // some of that behind-the-scenes chicanary will affect us here.
        // To get an idea of how, let's look at the official guidance:
        
        /* From SDK Docs:
         
         NSInvocation Class Reference ...
         There are always at least 2 arguments, because an NSMethodSignature
         object includes the hidden arguments self and _cmd, which are the
         first two arguments passed to every method implementation.
         
         NSMethodSignature Class Reference ...
         Indices 0 and 1 indicate the hidden arguments self and _cmd,
         respectively; you should set these values directly with the
         setTarget: and setSelector: methods. Use indices 2 and greater
         for the arguments normally passed in a message.
         */
        
        NSUInteger argumentCount = [theSignature numberOfArguments] - 2;
        
        if (parameterCount == argumentCount)
        {
            [theInvocation setTarget:self];      // There's our index 0.
            [theInvocation setSelector:aSelector]; // There's our index 1.
            
            // Now for arguments 2 and up...
            NSUInteger i, count = parameterCount;
            
            for (i = 0; i < count; i++) {
                
                // We're agnostic about object types, so assume nothing.
                id currentValue = [parameterValues objectAtIndex:i];
                
                // Well, not entirely agnostic. We do have one problem
                // case that is likely to occur somewhat frequently.
                //
                // Objective-C data types, like int, float, etc., are
                // not objects.  We can't pass them in an array. However,
                // there are many methods that take these types of
                // parameters.  Since we have a goal of supporting
                // arbitrary methods--without modifying them--we need
                // some way to transport these.  A quick and simple way
                // so to wrap them in an NSValue object, then add them
                // to our array.
                //
                // Good so now we have our NSValue.  Now what? Well,
                // now we need to unwrap the basic value nestled inside.
                // Once tranformed, we can pass it as a parameter.
                // Here's how we do that:
                //
                // Test to see if we have a foundation class
                // wrapped in an NSValue.
                if ([currentValue isKindOfClass:[NSValue class]])
                {
                    void *bufferForValue;
                    [currentValue getValue:&bufferForValue];
                    [theInvocation
                     setArgument:&bufferForValue
                     atIndex:(i + 2)];
                    // The +2 represents the (self) and (cmd) offsets
                } else
                {
                    [theInvocation
                     setArgument:&currentValue
                     atIndex:(i + 2)];
                    // Again, our +2 represents (self) and (cmd) offsets
                }
            }
            // That's it! (For our NSInvocation).
        }
        // Now we use the invocation to create our operation, which I explain
        // a bit more about below.  I'm including it as reference, since
        // there are good advantages to using a queue.
        theOperation = [[NSInvocationOperation alloc]
                        initWithInvocation:theInvocation];
    }
    else
    {   // Okay. We were not passed an array in our context parameter.
        // Well, that's just fine.  If we received something, we'll just
        // pass it on.  This way, our users don't have to go through the
        // hassle of creating an NSArray of just one item.  We could check
        // to see if our selector has just one parameter, and then ensure
        // that context is not nil, but that's left as an exercise to
        // the reader.
        // Note, context is of type (void), so it doesn't need to be
        // wrapped/unwrapped in an NSValue object.  Woo hoo!
        // Invoke a selector with a single parameter.
        theOperation = [[NSInvocationOperation alloc]
                        initWithTarget:self
                        selector:aSelector
                        object:context];
    }
    // In this example, I'm submitting my NSInvocationOperation
    // to an NSOperationQueue, which I have already built using
    // a singleton pattern.  You could also use NSThread, but
    // there are some pluses to using NSInvocationQueues for my
    // application (and probably yours too). For NSThread, you
    // use NSInvocation instead of NSInvocationOperation, and
    // might end up with something like:
    
    // [theInvocation performSelectorInBackground:@selector(invoke) withObject:nil]
    
    // where the invoke selector is sent to theInvocation, telling it to
    // call the method with the arguements as we defined above, but on
    // a background thread.  The other performSelector* methods work similarly.
    //
    // In this case, though, I'm adding my operation to the queue.
    // Add the operation to the internal operation queue
    // managed by our application delegate.
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    [self.myGlobalOperationQueue addOperation:theOperation] ;
    
    // Make sure theOperation gets released later, once it's it finished running.
    // [theOperation release];
}

- (void)doGeneralStuff:(SEL)aSelector withContext:(id)context{
    NSLog(@"==== 1 doing the very general stuff firstly");
    [self performSelector:aSelector withContext:context];
}

//-(UIViewController*) shareOnSoundCloudWithString:(NSString*)songName shouldLog:(BOOL)shouldLog{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//
//    NSArray *directoryPath = NSSearchPathForDirectoriesInDomains
//    (NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath =  [directoryPath objectAtIndex:0];
//    NSString *outWavPath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:songName];
//
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    if(shouldLog){
//        if ([fileManager fileExistsAtPath:outWavPath] == YES) {
//            NSLog(@"File exists: %@",outWavPath);
//        } else {
//            NSLog(@"File does not exist: %@",outWavPath);
//        }
//    }
//
//    NSURL *trackURL = [NSURL fileURLWithPath:outWavPath];
//    SCShareViewController *shareViewController;
//    shareViewController = [SCShareViewController shareViewControllerWithFileURL:trackURL
//                                                              completionHandler:^(NSDictionary *trackInfo, NSError *error){
//                                                                  if (SC_CANCELED(error)) {
//                                                                      if (shouldLog) NSLog(@"Canceled!");
//                                                                  } else if (error) {
//                                                                      if (shouldLog) NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
//                                                                  } else {
//                                                                      // If you want to do something with the uploaded
//                                                                      // track this is the right place for that.
//                                                                      NSString *downloadLink = [trackInfo objectForKey:@"permalink_url"];
//                                                                      NSLog(@"====Uploaded track: %@", downloadLink);
//                                                                      [Flurry logEvent:downloadLink];
//                                                                  }
//                                                              }];
//
//    NSDate* sourceDate = [NSDate date];
//    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
//    [dateFormatters setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSString *dateStr = [dateFormatters stringFromDate: sourceDate];
//    [shareViewController setTitle:[NSString stringWithFormat:@"Back Vocal Sound %@",dateStr]];
//
//    [shareViewController setPrivate:NO];
//    [shareViewController setCreationDate:sourceDate];
//    [shareViewController setCoverImage:[UIImage imageNamed:@"PSA_0.2_AppIcon_Large.png"]];
//
//    // Now present the share view controller.
////    [self presentViewController:shareViewController animated:YES completion:nil];
//    return shareViewController;
//}

@end
