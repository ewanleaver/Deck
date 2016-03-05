//
//  HomePanel.h
//  deck
//
//  Created by Ewan Leaver on 10/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Bubble.h"

@interface HomePanel : UIView {
    
    UIColor *bubbleColour; // Put variables here to make them INSTANCE variables!
    bool customColour;     // Putting them in the .m file makes them class variables...
    
    UILabel *comment;
    
    bool bubbleToggled;
}

- (instancetype)initWithFrame:(CGRect)frame deck:(Deck*)d;
- (instancetype)initWithFrame:(CGRect)frame colour:(UIColor*)inputColour numToStudy:(int)numToStudy numTotal:(int)cardsTotal;

- (void)changeBubbleView;

- (void)showComment;
- (void)hideComment;

// Consider whether these should be made private
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) int cardCount;
@property (nonatomic, strong) UILabel *cardLabel;
@property (nonatomic, assign) int toStudyCount;
@property (nonatomic, strong) UILabel *toStudyLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) Bubble *bubble;

@end
