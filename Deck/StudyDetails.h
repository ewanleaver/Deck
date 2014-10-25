//
//  StudyDetails.h
//  deck
//
//  Created by Ewan Leaver on 23/10/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface StudyDetails : NSManagedObject

@property (nonatomic, retain) NSDate * lastStudied;
@property (nonatomic, retain) NSNumber * quality;
@property (nonatomic, retain) NSNumber * intervalNum;
@property (nonatomic, retain) NSNumber * interval;
@property (nonatomic, retain) NSNumber * eFactor;
@property (nonatomic, retain) Character *character;

@end
