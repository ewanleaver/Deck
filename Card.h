//
//  Card.h
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"
#import "StudyDetails.h"
#import "TempStudyDetails.h"

@interface Card : UIView

-(id)initCard:(Character*)inputChar fresh:(BOOL)Fresh;

@property int cardNum;
@property Character *c;
@property StudyDetails *studyDetails;
@property TempStudyDetails *tempStudyDetails;

@property UIView *frontView;
@property UIImageView *readingsView;

@property CGPoint originalPoint;

@property int repQuality; // Intra-repetition quality

@end
