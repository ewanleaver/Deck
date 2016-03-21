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

@interface HomePanel : UIView 

- (instancetype)initWithFrame:(CGRect)frame deck:(Deck *)d;
- (instancetype)initWithFrame:(CGRect)frame colour:(UIColor *)inputColour numUnstudied:(int)unstudiedCount numTotal:(int)totalCount NS_DESIGNATED_INITIALIZER;

- (void)changeBubbleView;

- (void)showComment;
- (void)hideComment;

// Consider whether these should be made private
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) int totalCount;
@property (nonatomic, strong) UILabel *totalCountLabel;
@property (nonatomic, assign) int unstudiedCount;
@property (nonatomic, strong) UILabel *unstudiedCountLabel;
@property (nonatomic, strong) UILabel *countDescLabel;

@property (nonatomic, strong) Bubble *bubble;

@end
