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

@property (nonatomic, assign) int inputRegularSize;
@property (nonatomic, assign) int inputInflatedSize;
@property (nonatomic, assign) int normalisedRegularSize;
@property (nonatomic, assign) int normalisedInflatedSize;

@property (nonatomic, assign) float diameterRatio;

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

        self.inputRegularSize = regularSize;
        self.inputInflatedSize = inflatedSize;
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
    float temp = pow(self.inputRegularSize,0.5);

    self.normalisedRegularSize = (temp/20) * BUBBLE_MAX_SIZE; // Currently maxes out at 400 cards to study
    if (self.normalisedRegularSize > BUBBLE_MAX_SIZE) {
        self.normalisedRegularSize = BUBBLE_MAX_SIZE;
    }
    float deflatedDiameter = self.normalisedRegularSize + BUBBLE_BASE_DIAMETER;
    
    
    // Calc deflated/inflated diameter ratio
    temp = pow(self.inputInflatedSize,0.5);
    
    self.normalisedInflatedSize = (temp/20) * BUBBLE_MAX_SIZE;
    if (self.normalisedInflatedSize > BUBBLE_MAX_SIZE) {
        self.normalisedInflatedSize = BUBBLE_MAX_SIZE;
    }
    float inflatedDiameter = self.normalisedInflatedSize + BUBBLE_BASE_DIAMETER;
    
    self.diameterRatio = inflatedDiameter/deflatedDiameter;
    //NSLog(@"Cards: %d, Diameter: %d",inputSize,diameter);
    
    
    // Draw the bubble
    CGFloat dashLengths[] = {8, 7.7};  // For empty deck case, we are drawing a dashed "empty" bubble
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineDash(context, 0, dashLengths, 2);
    self.transform = CGAffineTransformIdentity;
    CGRect rectangle = CGRectMake(self.frame.size.width/2 - deflatedDiameter/2,self.frame.size.height/2 - deflatedDiameter/2,deflatedDiameter,deflatedDiameter);
    CGContextAddEllipseInRect(context, rectangle);
    
    if (self.inputRegularSize == 0) {
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(200.0 / 255.0) green:(200.0 / 255.0) blue:(200.0 / 255.0) alpha: 1].CGColor);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    } else {
        CGContextSetFillColorWithColor(context, self.colour.CGColor);
        CGContextFillPath(context);
    }
}

- (void)handleTapFrom:(UIGestureRecognizer*)recognizer {
    
    if (self.inputRegularSize != 0) {
        
        HomePanel* controller = (HomePanel*) [self superview];
        [controller changeBubbleView];
    
        if (!self.bubbleToggled) {
            
            // Grow
            
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.1, 1.1)];//self.diameterRatio, self.diameterRatio)];
            scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
            scaleAnimation.springBounciness = 20.f;
            
            [self pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
            //[self.alpha pop_addAnimation:scaleAnimation forKey:@"scalingDown"];
            //self.alpha = 0.7;
            
        } else {
            // Shrink
            
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
            scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2.5, 2.5)];
            scaleAnimation.springBounciness = 20.f;
            
            [self pop_addAnimation:scaleAnimation forKey:@"scalingDown"];
        }
        
        // Flip the toggle
        self.bubbleToggled = !self.bubbleToggled;
    }
}

@end
