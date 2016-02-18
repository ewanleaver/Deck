//
//  Bubble.m
//  deck
//
//  Created by Ewan Leaver on 6/10/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "Bubble.h"
#import "HomePanel.h"

@implementation Bubble

@synthesize numToStudyLabel;
@synthesize bubbleToggled;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        bubbleColour = [UIColor redColor];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;

}

- (instancetype)initBubbleWithFrame:(CGRect)frame colour:(UIColor*)inputColor size:(int)bubbleSize totalSize:(int)totalSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        inputSize = bubbleSize;
        totalCards = totalSize;
        bubbleColour = inputColor;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    // Add the tap gesture recognizer to the view
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    bubbleToggled = false;
    
    return self;
    
}

- (void)drawRect:(CGRect)rect {
    
    //[numToStudyLabel setFrame:CGRectMake(self.frame.size.width/2 - 25, self.frame.size.height/2 - 15, 50, 30)];
    //[numToStudyLabel setText:@"Test Label"];
    
    // Max value to add to base value (of 100) is currently 120.
    
    float temp = pow(inputSize,0.5);

    actualSize = (temp/20) * 120; // Maxes out at 400 cards to study
    
    if (actualSize > 120) {
        actualSize = 120;
    }
    
    float diameter = 100 + actualSize;
    
    
    // Calc ratio
    temp = pow(totalCards,0.5);
    
    int temp2 = (temp/20) * 120;
    
    if (temp2 > 120) {
        temp2 = 120;
    }
    
    float diameter2 = temp2 + 100;
    
    ratio = diameter2/diameter;
    
    //NSLog(@"Cards: %d, Diameter: %d",inputSize,diameter);
    
    CGFloat dashLengths[] = {8, 7.7};
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineDash(context, 0, dashLengths, 2);
    self.transform = CGAffineTransformIdentity;
    CGRect rectangle = CGRectMake(self.frame.size.width/2 - diameter/2,self.frame.size.height/2 - diameter/2,diameter,diameter);
    CGContextAddEllipseInRect(context, rectangle);
    
    if (inputSize == 0) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(200.0 / 255.0) green:(200.0 / 255.0) blue:(200.0 / 255.0) alpha: 1].CGColor);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    } else {
        CGContextSetFillColorWithColor(context, bubbleColour.CGColor);
        CGContextFillPath(context);
    } 

 }

- (void)handleTapFrom:(UIGestureRecognizer*)recognizer {
    
    if (inputSize != 0) {
        
        HomePanel* controller = (HomePanel*) [self superview];
        
        [controller changeBubbleView];
    
        if (!bubbleToggled) {
            
            // Grow
            [UIView animateWithDuration:0.09f
                                  delay:0
                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                             animations:^{self.transform = CGAffineTransformMakeScale(ratio*1.08,ratio*1.08);self.alpha = 0.7;}
                             completion:^(BOOL fin) {
                                     
             [UIView animateWithDuration:0.08f
                                   delay:0
                                 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                              animations:^{self.transform = CGAffineTransformMakeScale(ratio*0.95,ratio*0.95);}
                              completion:^(BOOL fin) {
                              
              [UIView animateWithDuration:0.07f
                                    delay:0
                                  options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                               animations:^{self.transform = CGAffineTransformMakeScale(ratio*1.04,ratio*1.04);}
                               completion:^(BOOL fin) {
                                   
               [UIView animateWithDuration:0.06f
                                     delay:0
                                   options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                animations:^{self.transform = CGAffineTransformMakeScale(ratio*0.975,ratio*0.975);}
                                completion:^(BOOL fin) {
                                
                [UIView animateWithDuration:0.05f
                                      delay:0
                                    options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                 animations:^{self.transform = CGAffineTransformMakeScale(ratio,ratio);}
                                 completion:^(BOOL fin) { }  ]; }]; }]; }]; }];
            
        } else {
            // Revert
            
            [UIView animateWithDuration:0.09f
                                  delay:0
                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                             animations:^{self.transform = CGAffineTransformMakeScale(0.92,0.92);self.alpha = 1.0;}
                             completion:^(BOOL fin) {
                                 
             [UIView animateWithDuration:0.08f
                                   delay:0
                                 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                              animations:^{self.transform = CGAffineTransformMakeScale(1.05,1.05);}
                              completion:^(BOOL fin) {
                                  
              [UIView animateWithDuration:0.07f
                                    delay:0
                                  options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                               animations:^{self.transform = CGAffineTransformMakeScale(0.96,0.96);}
                               completion:^(BOOL fin) {
                                   
               [UIView animateWithDuration:0.06f
                                     delay:0
                                   options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                animations:^{self.transform = CGAffineTransformMakeScale(1.025,1.025);}
                                completion:^(BOOL fin) {
                                    
                [UIView animateWithDuration:0.05f
                                      delay:0
                                    options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                 animations:^{self.transform = CGAffineTransformIdentity; }
                                 completion:^(BOOL fin) { }  ]; }]; }]; }]; }];
        }
        
        // Flip the toggle
        bubbleToggled = !bubbleToggled;
    
    }
}

@end
