//
//  Character.h
//  deck
//
//  Created by Ewan Leaver on 5/19/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudyDetails;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * literal;
@property (nonatomic, retain) NSString * reading_kun;
@property (nonatomic, retain) NSString * reading_on;
@property (nonatomic, retain) NSString * reading_pin;
@property (nonatomic, retain) NSString * jlpt;
@property (nonatomic, retain) StudyDetails *studyDetails;

@end
