//
//  Defines.h
//  PitchShiftApp
//
//  Created by Marcelo Henrique Salloum dos Santos on 10/4/13.
//  Copyright (c) 2013 CheeseCakeGarage. All rights reserved.
//

#ifndef PitchShiftApp_Defines_h
#define PitchShiftApp_Defines_h

/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
} encodingTypes;

enum
{
    INITIAL_VIEW = 0,
    RECORDING_VIEW = 1,
    SELECTING_EFFECT_VIEW = 2,
    PROCESSING_VIEW = 3,
    PREVIEW_VIEW_NOT_PLAYING = 4,
    PREVIEW_VIEW_PLAYING = 5,
} currentViewState;

#endif
