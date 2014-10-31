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
    bool customColour;     // Putting them in the .m file makes them class vairables...
    
    UILabel *comment;
    
    bool bubbleToggled;
    
}

- (instancetype)initWithFrameAndDeck:(CGRect)frame deck:(Deck*)d;
- (instancetype)initWithFrameAndColour:(CGRect)frame colour:(UIColor*)inputColour numToStudy:(int)numToStudy numTotal:(int)cardsTotal;

- (void)changeBubbleView;

- (void)showComment;
- (void)hideComment;

@property UILabel *titleLabel;

@property int cardCount;
@property UILabel *cardLabel;

@property int toStudyCount;
@property UILabel *toStudyLabel;

@property UILabel *descLabel;

@end
