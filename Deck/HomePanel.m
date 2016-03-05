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
    
    self.toStudyCount = [d.numToStudy intValue];
    self.cardCount = [d.numToStudy intValue];
    
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame colour:(UIColor *)inputColour numToStudy:(int)cardsToStudy numTotal:(int)cardsTotal {
    
    bubbleColour = inputColour;
    customColour = YES; // Override default bubble colour
    
    self.toStudyCount = cardsToStudy;
    self.cardCount = cardsTotal;
    
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
        
        if (self.toStudyCount == 0) {
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
            self.bubble = [[Bubble alloc] initBubbleWithFrame:CGRectMake(self.frame.size.width/2 - 110,100,220,220) colour:bubbleColour regularSize:self.toStudyCount  inflatedSize:self.cardCount];
            //bubble = [[Bubble alloc] init:CGRectMake(self.frame.size.width/2 - 90,40,180,180) colour:bubbleColour];
        } else {
            self.bubble = [[Bubble alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 110,100,220,220)];
        }
        
        [self addSubview:self.bubble];
        
        self.toStudyLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100,178,200,50)];
        [self.toStudyLabel setTextAlignment:NSTextAlignmentCenter];
        [self.toStudyLabel setFont:[UIFont systemFontOfSize:64.0f]];
        [self.toStudyLabel setTextColor:labelColour];
        self.toStudyLabel.text = [NSString stringWithFormat:@"%d",self.toStudyCount];
        [self addSubview:self.toStudyLabel];
        
        // Displays total number of cards
        self.cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 100,178,200,50)];
        [self.cardLabel setTextAlignment:NSTextAlignmentCenter];
        [self.cardLabel setFont:[UIFont systemFontOfSize:64.0f]];
        [self.cardLabel setTextColor:labelColour];
        self.cardLabel.text = [NSString stringWithFormat:@"%d",self.cardCount];
        [self addSubview:self.cardLabel];
        [self.cardLabel setHidden:YES];
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 30,215,60,50)];
        [self.descLabel setTextAlignment:NSTextAlignmentCenter];
        [self.descLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [self.descLabel setTextColor:labelColour];
        self.descLabel.text = @"Cards";
        [self addSubview:self.descLabel];
        
        comments = [NSArray arrayWithObjects:@"Fantastic!",@"Good work!",@"Well done!",@"Spiffing!",@"Neato!",@"Fantastic!",nil];
        
        bubbleToggled = [self.bubble bubbleToggled];
        
    }
    return self;
}

- (void)changeBubbleView {
    
    if (!bubbleToggled) {
        self.toStudyLabel.hidden = YES;
        [self.cardLabel setText:[NSString stringWithFormat:@"%d",self.cardCount]];
        self.cardLabel.hidden = NO;
        
        self.descLabel.text = @"Total";
    } else {
        self.cardLabel.hidden = YES;
        self.toStudyLabel.hidden = NO;

        
        self.descLabel.text = @"Cards";
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
