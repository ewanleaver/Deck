//
//  Bubble.m
//  deck
//
//  Created by Ewan Leaver on 6/10/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "Bubble.h"
#import "HomePanel.h"

#define BUBBLE_MAX_SIZE 120
#define BUBBLE_BASE_DIAMETER 100

@interface Bubble ()

@end

@implementation Bubble

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.colour = [UIColor redColor];
        [self setBackgroundColor:[UIColor clearColor]];
        
    }
    return self;
}

- (instancetype)initBubbleWithFrame:(CGRect)frame colour:(UIColor*)colour regularSize:(int)regularSize inflatedSize:(int)inflatedSize
{
    self = [super initWithFrame:frame];
    if (self) {

        inputRegularSize = regularSize;
        inputInflatedSize = inflatedSize;
        self.colour = colour;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    // Add the tap gesture recognizer to the view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    self.bubbleToggled = false;
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    //[numToStudyLabel setFrame:CGRectMake(self.frame.size.width/2 - 25, self.frame.size.height/2 - 15, 50, 30)];
    //[numToStudyLabel setText:@"Test Label"];
    
    // Max value to add to base value (of 100) is currently 120.
    float temp = pow(inputRegularSize,0.5);

    normalisedRegularSize = (temp/20) * BUBBLE_MAX_SIZE; // Currently maxes out at 400 cards to study
    if (normalisedRegularSize > BUBBLE_MAX_SIZE) {
        normalisedRegularSize = BUBBLE_MAX_SIZE;
    }
    float deflatedDiameter = normalisedRegularSize + BUBBLE_BASE_DIAMETER;
    
    
    // Calc deflated/inflated diameter ratio
    temp = pow(inputInflatedSize,0.5);
    
    normalisedInflatedSize = (temp/20) * BUBBLE_MAX_SIZE;
    if (normalisedInflatedSize > BUBBLE_MAX_SIZE) {
        normalisedInflatedSize = BUBBLE_MAX_SIZE;
    }
    float inflatedDiameter = normalisedInflatedSize + BUBBLE_BASE_DIAMETER;
    
    diameterRatio = inflatedDiameter/deflatedDiameter;
    //NSLog(@"Cards: %d, Diameter: %d",inputSize,diameter);
    
    
    // Draw the bubble
    CGFloat dashLengths[] = {8, 7.7};  // For empty deck case, we are drawing a dashed "empty" bubble
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineDash(context, 0, dashLengths, 2);
    self.transform = CGAffineTransformIdentity;
    CGRect rectangle = CGRectMake(self.frame.size.width/2 - deflatedDiameter/2,self.frame.size.height/2 - deflatedDiameter/2,deflatedDiameter,deflatedDiameter);
    CGContextAddEllipseInRect(context, rectangle);
    
    if (inputRegularSize == 0) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(200.0 / 255.0) green:(200.0 / 255.0) blue:(200.0 / 255.0) alpha: 1].CGColor);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    } else {
        CGContextSetFillColorWithColor(context, self.colour.CGColor);
        CGContextFillPath(context);
    }
}

- (void)handleTapFrom:(UIGestureRecognizer*)recognizer {
    
    if (inputRegularSize != 0) {
        
        HomePanel* controller = (HomePanel*) [self superview];
        [controller changeBubbleView];
    
        if (!self.bubbleToggled) {
            
            // Grow
            [UIView animateWithDuration:0.09f
                                  delay:0
                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                             animations:^{self.transform = CGAffineTransformMakeScale(diameterRatio*1.08,diameterRatio*1.08);self.alpha = 0.7;}
                             completion:^(BOOL fin) {
                                     
             [UIView animateWithDuration:0.08f
                                   delay:0
                                 options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                              animations:^{self.transform = CGAffineTransformMakeScale(diameterRatio*0.95,diameterRatio*0.95);}
                              completion:^(BOOL fin) {
                              
              [UIView animateWithDuration:0.07f
                                    delay:0
                                  options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                               animations:^{self.transform = CGAffineTransformMakeScale(diameterRatio*1.04,diameterRatio*1.04);}
                               completion:^(BOOL fin) {
                                   
               [UIView animateWithDuration:0.06f
                                     delay:0
                                   options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                animations:^{self.transform = CGAffineTransformMakeScale(diameterRatio*0.975,diameterRatio*0.975);}
                                completion:^(BOOL fin) {
                                
                [UIView animateWithDuration:0.05f
                                      delay:0
                                    options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                 animations:^{self.transform = CGAffineTransformMakeScale(diameterRatio,diameterRatio);}
                                 completion:^(BOOL fin) { }  ]; }]; }]; }]; }];
            
        } else {
            // Shrink
            
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
        self.bubbleToggled = !self.bubbleToggled;
    }
}

@end
