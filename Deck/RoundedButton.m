//
//  StudyButton.m
//  deck
//
//  Created by Ewan Leaver on 6/10/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "RoundedButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation RoundedButton

- (instancetype)initWithFrameAndColour:(CGRect)frame buttonColour:(UIColor*)buttonColour
{
    self = [super initWithFrame:frame];
    if (self) {
        _backColour = buttonColour;
    }
    return self;
}

- (CGPathRef) newPathForRoundedRect:(CGRect)rect radius:(CGFloat)radius
{
    CGMutablePathRef retPath = CGPathCreateMutable();
    
    CGRect innerRect = CGRectInset(rect, radius, radius);
    
    CGFloat inside_right = innerRect.origin.x + innerRect.size.width;
    CGFloat outside_right = rect.origin.x + rect.size.width;
    CGFloat inside_bottom = innerRect.origin.y + innerRect.size.height;
    CGFloat outside_bottom = rect.origin.y + rect.size.height;
    
    CGFloat inside_top = innerRect.origin.y;
    CGFloat outside_top = rect.origin.y;
    CGFloat outside_left = rect.origin.x;
    
    CGPathMoveToPoint(retPath, NULL, innerRect.origin.x, outside_top);
    
    CGPathAddLineToPoint(retPath, NULL, inside_right, outside_top);
    CGPathAddArcToPoint(retPath, NULL, outside_right, outside_top, outside_right, inside_top, radius);
    CGPathAddLineToPoint(retPath, NULL, outside_right, inside_bottom);
    CGPathAddArcToPoint(retPath, NULL,  outside_right, outside_bottom, inside_right, outside_bottom, radius);
    
    CGPathAddLineToPoint(retPath, NULL, innerRect.origin.x, outside_bottom);
    CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_bottom, outside_left, inside_bottom, radius);
    CGPathAddLineToPoint(retPath, NULL, outside_left, inside_top);
    CGPathAddArcToPoint(retPath, NULL,  outside_left, outside_top, innerRect.origin.x, outside_top, radius);
    
    CGPathCloseSubpath(retPath);
    
    return retPath;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{

    self.layer.cornerRadius = self.frame.size.height/2;
    [self.layer setMasksToBounds:YES];
    
    self.layer.backgroundColor = _backColour.CGColor;
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGRect frame = self.bounds;
//    
//    CGPathRef roundedRectPath = [self newPathForRoundedRect:frame radius:self.frame.size.height/2];
//    
//    [[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.7] set];
//    
//    CGContextAddPath(context, roundedRectPath);
//    CGContextFillPath(context);
//    
//    CGPathRelease(roundedRectPath);
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    //theLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
//    
//    [UIView animateWithDuration:0.0 animations:^{
//        self.layer.backgroundColor = [UIColor colorWithRed:(25.0 / 255.0) green:(220.0 / 255.0) blue:(110.0 / 255.0) alpha: 1].CGColor;
//    } completion:NULL];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [UIView animateWithDuration:0.0 animations:^{
//        self.layer.backgroundColor = [UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.6].CGColor;
//    } completion:NULL];
//}

@end
