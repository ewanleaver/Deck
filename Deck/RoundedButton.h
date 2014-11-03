//
//  StudyButton.h
//  deck
//
//  Created by Ewan Leaver on 6/10/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedButton : UIButton

- (instancetype)initWithFrameAndColour:(CGRect)frame buttonColour:(UIColor*)buttonColour;

@property UIColor* backColour;

@end
