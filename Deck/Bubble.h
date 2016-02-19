//
//  Bubble.h
//  deck
//
//  Created by Ewan Leaver on 6/10/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bubble : UIView {
    int inputRegularSize;
    int normalisedRegularSize;
    
    int inputInflatedSize;
    int normalisedInflatedSize;
    float diameterRatio;
}

@property (nonatomic, strong) UIColor *colour;
@property (nonatomic, strong) UILabel *numToStudyLabel;
@property (nonatomic, assign) bool bubbleToggled;

- (instancetype)initBubbleWithFrame:(CGRect)frame colour:(UIColor*)colour regularSize:(int)regularSize inflatedSize:(int)inflatedSize;

- (void)handleTapFrom:(UIGestureRecognizer*)recognizer;

@end