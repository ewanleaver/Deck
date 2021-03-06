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

#define BUBBLE_ANIMATION_VELOCITY 2
#define BUBBLE_ANIMATION_BOUNCINESS 22.f
#define BUBBLE_ANIMATION_TENSION 800.f

@interface Bubble ()

@property (nonatomic, assign) int inputRegularSize;
@property (nonatomic, assign) int inputInflatedSize;
@property (nonatomic, assign) int normalisedRegularSize;
@property (nonatomic, assign) int normalisedInflatedSize;

@property (nonatomic, assign) float diameterRatio;

@end

@implementation Bubble

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initBubbleWithFrame:frame colour:[UIColor redColor] regularSize:10 inflatedSize:100];
}

- (instancetype)initBubbleWithFrame:(CGRect)frame colour:(UIColor*)colour regularSize:(int)regularSize inflatedSize:(int)inflatedSize {
    
    self = [super initWithFrame:frame];
    if (self) {

        _inputRegularSize = regularSize;
        _inputInflatedSize = inflatedSize;
        _colour = colour;
        
        _bubbleToggled = false;
    }
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    // Add the tap gesture recognizer to the view
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
//    NSLog(@"%f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);//[tapGestureRecognizer locationInView:self];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
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
        
        POPBasicAnimation *rotationAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
        rotationAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(M_PI, M_PI)];
        rotationAnimation.duration = 10;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        rotationAnimation.repeatForever = true;
        [self.layer pop_addAnimation:rotationAnimation forKey:@"rotateBubble"];
    } else {
        CGContextSetFillColorWithColor(context, self.colour.CGColor);
        CGContextFillPath(context);
    }
}

- (void)handleTapFrom:(UIGestureRecognizer*)recognizer {
    
//    CGPoint touchPoint = [recognizer locationInView: self];
//    NSLog(@"%f, %f",touchPoint.x,touchPoint.y);
    
    if (self.inputRegularSize != 0) {
        
        HomePanel* controller = (HomePanel*) [self superview];
        [controller changeBubbleView];
    
        if (self.bubbleToggled) {

            // Shrink
            
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
            scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(BUBBLE_ANIMATION_VELOCITY, BUBBLE_ANIMATION_VELOCITY)];
            scaleAnimation.springBounciness = BUBBLE_ANIMATION_BOUNCINESS;
            scaleAnimation.dynamicsTension = BUBBLE_ANIMATION_TENSION;
            [self pop_addAnimation:scaleAnimation forKey:@"scalingDown"];
            
            POPSpringAnimation *fadeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
            fadeAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
            fadeAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(BUBBLE_ANIMATION_VELOCITY, BUBBLE_ANIMATION_VELOCITY)];
            fadeAnimation.springBounciness = BUBBLE_ANIMATION_BOUNCINESS;
            fadeAnimation.dynamicsTension = BUBBLE_ANIMATION_TENSION;
            [self pop_addAnimation:fadeAnimation forKey:@"scalingDownAlpha"];
        } else {
            
            // Grow
            
            POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
            scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.diameterRatio, self.diameterRatio)];
            scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(BUBBLE_ANIMATION_VELOCITY, BUBBLE_ANIMATION_VELOCITY)];
            scaleAnimation.springBounciness = BUBBLE_ANIMATION_BOUNCINESS;
            scaleAnimation.dynamicsTension = BUBBLE_ANIMATION_TENSION;
            [self pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
            
            POPSpringAnimation *fadeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
            fadeAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
            fadeAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(BUBBLE_ANIMATION_VELOCITY, BUBBLE_ANIMATION_VELOCITY)];
            fadeAnimation.springBounciness = BUBBLE_ANIMATION_BOUNCINESS;
            fadeAnimation.dynamicsTension = BUBBLE_ANIMATION_TENSION;
            [self pop_addAnimation:fadeAnimation forKey:@"scalingUpAlpha"];
        }
        
        // Flip the toggle
        self.bubbleToggled = !self.bubbleToggled;
    }
}

@end
