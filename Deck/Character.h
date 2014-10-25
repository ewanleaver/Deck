//
//  Character.h
//  deck
//
//  Created by Ewan Leaver on 12/10/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StudyDetails;

@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * id_num;
@property (nonatomic, retain) NSString * jlpt;
@property (nonatomic, retain) NSString * literal;
@property (nonatomic, retain) id meaning;
@property (nonatomic, retain) id reading_kun;
@property (nonatomic, retain) id reading_on;
@property (nonatomic, retain) id reading_pin;
@property (nonatomic, retain) StudyDetails *studyDetails;

@end
