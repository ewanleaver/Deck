//
//  Card.h
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@interface Card : UIView

-(id)initCard:(CGRect)frame :(int)cardNumInput fresh:(BOOL)Fresh;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *characters;

@property int cardNum;
@property Character *character;
@property StudyDetails *studyDetails;

@property UIView *frontView;
@property UIImageView *readingsView;

@property CGPoint originalPoint;

@property int repQuality; // Intra-repetition quality
@property int correctCount;
@property int incorrectCount;

@end
