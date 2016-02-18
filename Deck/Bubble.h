//
//  Bubble.h
//  deck
//
//  Created by Ewan Leaver on 6/10/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bubble : UIView {
    UIColor *bubbleColour;
    int inputSize;
    int actualSize;
    
    int totalCards;
    float ratio;    // Make this more descriptive
}

@property (nonatomic, strong) UILabel* numToStudyLabel;
@property (nonatomic, assign) bool bubbleToggled;

- (instancetype)initBubbleWithFrame:(CGRect)frame colour:(UIColor*)bubbleColor size:(int)bubbleSize totalSize:(int)totalSize;

- (void)handleTapFrom:(UIGestureRecognizer*)recognizer;

@end