//
//  StudyDetails.h
//  deck
//
//  Created by Ewan Leaver on 5/19/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface StudyDetails : NSManagedObject

@property (nonatomic, retain) NSString * userGrade;
@property (nonatomic, retain) NSDate * lastStudied;
@property (nonatomic, retain) Character *character;

@end
