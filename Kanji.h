//
//  Kanji.h
//  TestPro_iOS
//
//  Created by Ewan Leaver on 23/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kanji : NSObject

@property NSString *character;

@property NSArray *onReadings;
@property NSArray *kunReadings;
@property NSString *pinyinReading;

@property NSArray *meanings;

@end
