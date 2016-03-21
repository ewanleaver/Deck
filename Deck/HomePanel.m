//
//  HomePanel.m
//  deck
//
//  Created by Ewan Leaver on 10/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <stdlib.h>
#import "HomePanel.h"
#import "Deck.h"
#import "Bubble.h"

@interface HomePanel ()

@property (nonatomic, strong) UIColor *bubbleColour;
@property (nonatomic, assign) bool customColour;
@property (nonatomic, assign) bool bubbleToggled;

@property (nonatomic, strong) NSArray *commentArray;
@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation HomePanel

- (instancetype)initWithFrame:(CGRect)frame deck:(Deck *)d {
    
    // Unarchive and create bubble colour
    NSDictionary *colourData = [NSKeyedUnarchiver unarchiveObjectWithData:d.bubbleColour];
    int bR = [[colourData valueForKeyPath:@"r"] intValue];
    int bG = [[colourData valueForKeyPath:@"g"] intValue];
    int bB = [[colourData valueForKeyPath:@"b"] intValue];
    UIColor *bubbleColour = [UIColor colorWithRed:(bR /255.0) green:(bG / 255.0) blue:(bB / 255.0) alpha: 1];
    
    int unstudiedCount = [d.numToStudy intValue];
    int totalCount = (int)[d.cardsInDeck count];
    
    // Some value dummying for demo purposes
    // (Remove this when we implement saving of study state)
    if ([d.name isEqualToString:@"JLPT N3"]) {
        unstudiedCount = 0;
    }
    if ([d.name isEqualToString:@"Review"]) {
        totalCount = 135;
    }

    return [self initWithFrame:frame colour:bubbleColour numUnstudied:unstudiedCount numTotal:totalCount];
}

- (instancetype)initWithFrame:(CGRect)frame colour:(UIColor *)inputColour numUnstudied:(int)unstudiedCount numTotal:(int)totalCount {
    
    self = [super initWithFrame:frame];
    if (self) {
        _bubbleColour = inputColour;
        _customColour = YES; // Override default bubble colour
    
        _unstudiedCount = unstudiedCount;
        _totalCount = totalCount;
        
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 120,20,240,50)];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setFont:[UIFont systemFontOfSize:35.0f]];
        [_titleLabel setTextColor:[UIColor darkGrayColor]];
        _titleLabel.text = @"Empty Panel";
        [self addSubview:_titleLabel];
        
        UIColor *labelColour = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 0.7];
        
        if (_unstudiedCount == 0) {
            // Remember this colour (green):
            //labelColour = [UIColor colorWithRed:(65.0 / 255.0) green:(220.0 / 255.0) blue:(130.0 / 255.0) alpha: 1];
            labelColour = _bubbleColour;
            _bubbleColour = [UIColor whiteColor];
            
            _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 120,260,240,30)];
            [_commentLabel setTextAlignment:NSTextAlignmentCenter];
            [_commentLabel setFont:[UIFont systemFontOfSize:25.0f]];
            [_commentLabel setTextColor:[UIColor lightGrayColor]];
            _commentLabel.text = @"Fantastic!";
            _commentLabel.alpha = 0;
            [self addSubview:_commentLabel];
        }
        
        if (_customColour) {
            _bubble = [[Bubble alloc] initBubbleWithFrame:CGRectMake(self.frame.size.width/2 - 110,100,220,220) colour:_bubbleColour regularSize:_unstudiedCount  inflatedSize:_totalCount];
            //bubble = [[Bubble alloc] init:CGRectMake(self.frame.size.width/2 - 90,40,180,180) colour:bubbleColour];
        } else {
            _bubble = [[Bubble alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 110,100,220,220)];
        }
        
        [self addSubview:_bubble];
        
        _unstudiedCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100,178,200,50)];
        [_unstudiedCountLabel setTextAlignment:NSTextAlignmentCenter];
        [_unstudiedCountLabel setFont:[UIFont systemFontOfSize:64.0f]];
        [_unstudiedCountLabel setTextColor:labelColour];
        _unstudiedCountLabel.text = [NSString stringWithFormat:@"%d",_unstudiedCount];
        [self addSubview:_unstudiedCountLabel];
        
        // Displays total number of cards
        _totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100,178,200,50)];
        [_totalCountLabel setTextAlignment:NSTextAlignmentCenter];
        [_totalCountLabel setFont:[UIFont systemFontOfSize:64.0f]];
        [_totalCountLabel setTextColor:labelColour];
        _totalCountLabel.text = [NSString stringWithFormat:@"%d",_totalCount];
        [self addSubview:_totalCountLabel];
        [_totalCountLabel setHidden:YES];
        
        _countDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 30,215,60,50)];
        [_countDescLabel setTextAlignment:NSTextAlignmentCenter];
        [_countDescLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_countDescLabel setTextColor:labelColour];
        _countDescLabel.text = @"Cards";
        [self addSubview:_countDescLabel];
        
        _commentArray = [NSArray arrayWithObjects:@"Fantastic!",@"Good work!",@"Well done!",@"Spiffing!",@"Neato!",@"Fantastic!",nil];
        
        _bubbleToggled = [_bubble bubbleToggled];
    }

    return self;
};

- (void)changeBubbleView {
    
    if (!self.bubbleToggled) {
        self.unstudiedCountLabel.hidden = YES;
        [self.totalCountLabel setText:[NSString stringWithFormat:@"%d",self.totalCount]];
        self.totalCountLabel.hidden = NO;
        
        self.countDescLabel.text = @"Total";
    } else {
        self.totalCountLabel.hidden = YES;
        self.unstudiedCountLabel.hidden = NO;

        
        self.countDescLabel.text = @"Cards";
    }
    
    self.bubbleToggled = !self.bubbleToggled;
    
    // Flip the toggle
    //[bubble setBubbleToggled:![bubble bubbleToggled]];
}

- (void)showComment {
    
    int rnd = arc4random_uniform(6);

    [UIView animateWithDuration:0.4 animations:^{
        [self.commentLabel setText:[self.commentArray objectAtIndex:rnd]];
        self.commentLabel.frame = CGRectMake(self.frame.size.width/2 - 120,275,240,30);
        self.commentLabel.alpha = 1;
    }];
}

- (void)hideComment {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.commentLabel.frame = CGRectMake(self.frame.size.width/2 - 120,260,240,30);
        self.commentLabel.alpha = 0;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
