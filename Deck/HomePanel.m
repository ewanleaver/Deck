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

@implementation HomePanel

NSArray *comments;

- (instancetype)initWithFrame:(CGRect)frame deck:(Deck *)d {
    
    // Unarchive and create bubble colour
    NSDictionary *colourData = [NSKeyedUnarchiver unarchiveObjectWithData:d.bubbleColour];
    int bR = [[colourData valueForKeyPath:@"r"] intValue];
    int bG = [[colourData valueForKeyPath:@"g"] intValue];
    int bB = [[colourData valueForKeyPath:@"b"] intValue];
    bubbleColour = [UIColor colorWithRed:(bR /255.0) green:(bG / 255.0) blue:(bB / 255.0) alpha: 1];
    customColour = YES; // Override default bubble colour
    
    self.unstudiedCount = [d.numToStudy intValue];
    self.totalCount = [d.numToStudy intValue];
    
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame colour:(UIColor *)inputColour numToStudy:(int)cardsToStudy numTotal:(int)cardsTotal {
    
    bubbleColour = inputColour;
    customColour = YES; // Override default bubble colour
    
    self.unstudiedCount = cardsToStudy;
    self.totalCount = cardsTotal;
    
    return [self initWithFrame:frame];
};

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 120,20,240,50)];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.titleLabel setFont:[UIFont systemFontOfSize:35.0f]];
        [self.titleLabel setTextColor:[UIColor darkGrayColor]];
        self.titleLabel.text = @"Empty Panel";
        [self addSubview:self.titleLabel];
        
        UIColor *labelColour = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 0.7];
        
        if (self.unstudiedCount == 0) {
            // Remember this colour (green):
            //labelColour = [UIColor colorWithRed:(65.0 / 255.0) green:(220.0 / 255.0) blue:(130.0 / 255.0) alpha: 1];
            labelColour = bubbleColour;
            bubbleColour = [UIColor whiteColor];
            
            comment = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 120,260,240,30)];
            [comment setTextAlignment:NSTextAlignmentCenter];
            [comment setFont:[UIFont systemFontOfSize:25.0f]];
            [comment setTextColor:[UIColor lightGrayColor]];
            comment.text = @"Fantastic!";
            comment.alpha = 0;
            [self addSubview:comment];
        }
        
        if (customColour) {
            self.bubble = [[Bubble alloc] initBubbleWithFrame:CGRectMake(self.frame.size.width/2 - 110,100,220,220) colour:bubbleColour regularSize:self.unstudiedCount  inflatedSize:self.totalCount];
            //bubble = [[Bubble alloc] init:CGRectMake(self.frame.size.width/2 - 90,40,180,180) colour:bubbleColour];
        } else {
            self.bubble = [[Bubble alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 110,100,220,220)];
        }
        
        [self addSubview:self.bubble];
        
        self.unstudiedCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100,178,200,50)];
        [self.unstudiedCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.unstudiedCountLabel setFont:[UIFont systemFontOfSize:64.0f]];
        [self.unstudiedCountLabel setTextColor:labelColour];
        self.unstudiedCountLabel.text = [NSString stringWithFormat:@"%d",self.unstudiedCount];
        [self addSubview:self.unstudiedCountLabel];
        
        // Displays total number of cards
        self.totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100,178,200,50)];
        [self.totalCountLabel setTextAlignment:NSTextAlignmentCenter];
        [self.totalCountLabel setFont:[UIFont systemFontOfSize:64.0f]];
        [self.totalCountLabel setTextColor:labelColour];
        self.totalCountLabel.text = [NSString stringWithFormat:@"%d",self.totalCount];
        [self addSubview:self.totalCountLabel];
        [self.totalCountLabel setHidden:YES];
        
        self.countDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 30,215,60,50)];
        [self.countDescLabel setTextAlignment:NSTextAlignmentCenter];
        [self.countDescLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self.countDescLabel setTextColor:labelColour];
        self.countDescLabel.text = @"Cards";
        [self addSubview:self.countDescLabel];
        
        comments = [NSArray arrayWithObjects:@"Fantastic!",@"Good work!",@"Well done!",@"Spiffing!",@"Neato!",@"Fantastic!",nil];
        
        bubbleToggled = [self.bubble bubbleToggled];
        
    }
    return self;
}

- (void)changeBubbleView {
    
    if (!bubbleToggled) {
        self.unstudiedCountLabel.hidden = YES;
        [self.totalCountLabel setText:[NSString stringWithFormat:@"%d",self.totalCount]];
        self.totalCountLabel.hidden = NO;
        
        self.countDescLabel.text = @"Total";
    } else {
        self.totalCountLabel.hidden = YES;
        self.unstudiedCountLabel.hidden = NO;

        
        self.countDescLabel.text = @"Cards";
    }
    
    bubbleToggled = !bubbleToggled;
    
    // Flip the toggle
    //[bubble setBubbleToggled:![bubble bubbleToggled]];
}

- (void)showComment {
//    [UILabel animateWithDuration:1.0 animations:^{
//        [comment setTextColor:[UIColor lightGrayColor]];
//    } completion:NULL];
    
    int rnd = arc4random_uniform(6);

    [UIView animateWithDuration:0.4 animations:^{
        [comment setText:[comments objectAtIndex:rnd]];
        comment.frame = CGRectMake(self.frame.size.width/2 - 120,275,240,30);
        comment.alpha = 1;
    }];
    
//    comment.alpha = 0;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//    
//    //don't forget to add delegate.....
//    [UIView setAnimationDelegate:self];
//    
//    [UIView setAnimationDuration:0.2];
//    comment.alpha = 1;
//    
//    //also call this before commit animations......
//    //[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//    [UIView commitAnimations];
}

- (void)hideComment {
    
    [UIView animateWithDuration:0.4 animations:^{
        comment.frame = CGRectMake(self.frame.size.width/2 - 120,260,240,30);
        comment.alpha = 0;
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
