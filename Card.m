//
//  Card.m
//  Deck
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//
//  kanjiArray = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"江", @"里", @"菜", @"駒"];
//

#import "Card.h"
#import "StudyViewController.h"
#import "Character.h"
#import "StudyDetails.h"
#import "TempStudyDetails.h"

@interface Card ()

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, weak) StudyViewController *controller;

@end

@implementation Card

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define CARD_WIDTH (SCREEN_WIDTH - CARD_MARGIN_HORIZONTAL * 2)
#define CARD_HEIGHT (SCREEN_HEIGHT - (CARD_MARGIN_TOP + CARD_MARGIN_BOTTOM))

#define CARD_MARGIN_HORIZONTAL 15
#define CARD_MARGIN_TOP 55
#define CARD_MARGIN_BOTTOM 55

#define CARD_ANIMATION_DURATION 0.5f


#define CONTENT_OFFSET_LEFT 15
#define CONTENT_OFFSET_TOP 15

#define FRONT_KANJI_SIZE 150
#define KANJI_SIZE 100

#define READING_BOX_LEFT 0
#define READING_BOX_TOP CONTENT_OFFSET_TOP + KANJI_SIZE + 11
#define READING_BOX_WIDTH CARD_WIDTH
#define READING_BOX_HEIGHT 90

#define READING_HEIGHT 25
#define READING_OFFSET_LEFT 10
#define READING_OFFSET_TOP 5
#define READING_GAP 5

#define MEANING_BOX_TOP READING_BOX_TOP + READING_BOX_HEIGHT + 10

#define MEANING_HEIGHT 25
#define MEANING_GAP 8
#define MEANING_SPACING (MEANING_HEIGHT + MEANING_GAP)
#define MEANING_BUBBLE_WIDTH 20

#define JLPT_BUBBLE_SIZE 35
#define JLPT_BUBBLE_OFFSET 9.1

#define CARD_NUM_LABEL_PADDING 15

#define VERBOSE 0

bool frontShowing;

#pragma mark - Init and Drawing

- (id)initCard:(Character*)inputChar fresh:(BOOL)fresh
{
    // Card Dimensions
    CGRect cardFrame = CGRectMake(CARD_MARGIN_HORIZONTAL, CARD_MARGIN_TOP, CARD_WIDTH, CARD_HEIGHT);
    
    self = [super initWithFrame:cardFrame];
    if (self) {
        
        self.delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [self.delegate managedObjectContext];
        
        self.controller = (StudyViewController*) [[self superview] nextResponder];
        
        // May eventually have the option of showing two sides to a card
        frontShowing = true;
        
        [self setFrame:cardFrame];
        
        self.c = inputChar;
        self.studyDetails = self.c.studyDetails;
        // tempStudyDetails are the study details for the current session (yes?)
        self.tempStudyDetails = self.studyDetails.tempStudyDetails;

        if (self.tempStudyDetails.isStudying.boolValue == false) {
            [self.tempStudyDetails setIsStudying:[NSNumber numberWithBool:true]];
            self.tempStudyDetails.numIncorrect = @0;
            self.tempStudyDetails.numCorrect = @0;
        } else {
            NSLog(@"[Card] CARD IS ALREADY BEING STUDIED");
        }
        
        // Just to prevent madness....
        //[tempStudyDetails setIsStudying:[NSNumber numberWithBool:false]];
        
        // Logging
        if (VERBOSE) {
            NSLog(@"[Card] Card Num: %@", self.c.id_num);
            NSLog(@"[Card] Studying?: %@", self.c.studyDetails.tempStudyDetails.isStudying);
            NSLog(@"[Card] Num Correct?: %@", self.c.studyDetails.tempStudyDetails.numCorrect);
            NSLog(@"[Card] Num Incorrect?: %@", self.c.studyDetails.tempStudyDetails.numIncorrect);
        }
        
        // Unpack the character's arrays
        
        NSMutableArray *readings_pin = [NSKeyedUnarchiver unarchiveObjectWithData: self.c.reading_pin];
        NSMutableArray *readings_kun = [NSKeyedUnarchiver unarchiveObjectWithData: self.c.reading_kun];
        NSMutableArray *readings_on = [NSKeyedUnarchiver unarchiveObjectWithData: self.c.reading_on];
        NSMutableArray *meanings = [NSKeyedUnarchiver unarchiveObjectWithData: self.c.meaning];
        
        // Init Readings View
        
        self.readingsView = [[UIImageView alloc] initWithFrame:CGRectMake(READING_BOX_LEFT, READING_BOX_TOP, READING_BOX_WIDTH, READING_BOX_HEIGHT)];
        [self addSubview:self.readingsView];
        
        //
        // Prepare Card Labels
        //
        
        UILabel *kanjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_OFFSET_LEFT, CONTENT_OFFSET_TOP, KANJI_SIZE, KANJI_SIZE)];
        kanjiLabel.text = self.c.literal;
        [kanjiLabel setTextColor:[UIColor darkGrayColor]];
        [kanjiLabel setBackgroundColor:[UIColor clearColor]];
        [kanjiLabel setFont:[UIFont systemFontOfSize:KANJI_SIZE weight:UIFontWeightThin]];
        [self addSubview:kanjiLabel];
        
        UILabel *pinyinLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_OFFSET_LEFT, CONTENT_OFFSET_TOP + 175, 100, 20)];
        pinyinLabel.text = @"Pinyin:";
        [pinyinLabel setTextColor:[UIColor lightGrayColor]];
        [pinyinLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [self addSubview:pinyinLabel];
        
        UILabel *pinyinReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_OFFSET_LEFT + 55, CONTENT_OFFSET_TOP + 175, 215, 20)];
        pinyinReadingLabel.text = [readings_pin firstObject];//@"yi1";
        [pinyinReadingLabel setTextColor:[UIColor darkGrayColor]];
        [pinyinReadingLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self addSubview:pinyinReadingLabel];
        
        
        [self drawOnReadingLabels:readings_on];
        [self drawKunReadingLabels:readings_kun];
        
        [self drawMeaningLabels:meanings];


        
        //
        // Other informative labels
        //
        if (![self.c.jlpt isEqual: @"null"]) {
            UILabel *jlptLabel = [[UILabel alloc] initWithFrame:CGRectMake(JLPT_BUBBLE_OFFSET, CARD_HEIGHT - 40.8, JLPT_BUBBLE_SIZE, 30)];
            
            NSString *jlptString = jlptString = [@"N" stringByAppendingString:self.c.jlpt];
            jlptLabel.text = jlptString;
            jlptLabel.textColor = [UIColor colorWithRed:(170.0 / 255.0) green:(170.0 / 255.0) blue:(170.0 / 255.0) alpha: 1];
            jlptLabel.font = [UIFont systemFontOfSize:20.0f];
            jlptLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:jlptLabel];
        };

        
        UILabel *cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CARD_WIDTH - (90 + CARD_NUM_LABEL_PADDING/2), CONTENT_OFFSET_TOP - 5, 80, 25)];
        cardNumLabel.text = [NSString stringWithFormat:@"# %@", self.c.id_num];
        cardNumLabel.textAlignment = NSTextAlignmentRight;
        cardNumLabel.textColor = [UIColor lightGrayColor];
        cardNumLabel.font = [UIFont systemFontOfSize:20.0f];
        
        // 1. Create bezier path to draw
        int width = [self widthOfString:cardNumLabel.text withFont:cardNumLabel.font] + CARD_NUM_LABEL_PADDING;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CARD_WIDTH - (width + 10), CONTENT_OFFSET_TOP - 5, width, 25) cornerRadius:12.5];
        
        // 2. Create a shape layer for above created path.
        CAShapeLayer *cardNumBubble = [[CAShapeLayer alloc] init];
        cardNumBubble.fillColor = [[UIColor colorWithRed:(235.0 / 255.0) green:(235.0 / 255.0) blue:(235.0 / 255.0) alpha: 1] CGColor];
        cardNumBubble.path = path.CGPath;
        [self.layer addSublayer:cardNumBubble];
        [self addSubview:cardNumLabel];

        
        [self setupFrontView];
        
        if (fresh) {
            [UIView animateWithDuration:0.25f
                                  delay:0
                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                             animations:^{[self setCenter:CGPointMake(160, CARD_HEIGHT/2 + 56)]; }
                             completion:^(BOOL fin) {}];
        }
        //[UIView animateWithDuration:0.7f animations:^{[self setCenter:CGPointMake(160, -200)]; }];
    }
    
    [self addGestureRecognisers];
    
    return self;
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}



//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//
//        CGRect newFrame = self.frame;
//
//        newFrame.size.width = 290;
//        newFrame.size.height = 400;
//        [self setFrame:newFrame];
//
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 150, 30)];
//        title.text = @"Sample Card";
//        [title setTextColor:[UIColor darkGrayColor]];
//        [title setBackgroundColor:[UIColor clearColor]];
//        [title setFont:[UIFont fontWithName: @"Trebuchet MS" size: 22.0f]];
//        [self addSubview:title];
//
//
//        UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
//        [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
//        [dismissButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [dismissButton.titleLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
//        [dismissButton addTarget:self
//                          action: @selector(buttonClicked:)
//                forControlEvents: UIControlEventTouchDown];
//        [self addSubview:dismissButton];
//
//        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 180, 100, 50)];
//        countLabel.text = [NSString stringWithFormat:@"#%d", cardNum];
//        [countLabel setTextColor:[UIColor lightGrayColor]];
//        [countLabel setBackgroundColor:[UIColor clearColor]];
//        [countLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 48.0f]];
//        [self addSubview:countLabel];
//
//
//        [UIView animateWithDuration:0.22f
//                              delay:0
//                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
//                         animations:^{[self setCenter:CGPointMake(160, 260)]; }
//                         completion:^(BOOL fin) {NSLog(@"[Card] done");}   ];
//
//        //[UIView animateWithDuration:0.7f animations:^{[self setCenter:CGPointMake(160, -200)]; }];
//    }
//    return self;
//}

- (void) setupFrontView {
    
    CGRect frame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT);
    self.frontView = [[UIView alloc] initWithFrame:frame];
    [self.frontView setBackgroundColor:[UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 1]];
    
    UILabel *frontKanjiLabel = [[UILabel alloc] initWithFrame:CGRectMake((CARD_WIDTH - FRONT_KANJI_SIZE)/2, (CARD_HEIGHT - FRONT_KANJI_SIZE)/2, FRONT_KANJI_SIZE, FRONT_KANJI_SIZE)];
    frontKanjiLabel.text = self.c.literal;
    [frontKanjiLabel setTextColor:[UIColor darkGrayColor]];
    [frontKanjiLabel setBackgroundColor:[UIColor clearColor]];
    [frontKanjiLabel setFont:[UIFont systemFontOfSize:FRONT_KANJI_SIZE weight:UIFontWeightThin]];
    [self.frontView addSubview:frontKanjiLabel];
    
    [self addSubview:self.frontView];
}

- (void) drawOnReadingLabels:(NSMutableArray *)readings_on {
    
    // Calc remaining space left to draw within:
    int currPos = READING_BOX_LEFT + READING_OFFSET_LEFT;
    int remainingSpace = CARD_WIDTH - currPos;
    
    for (int i = 0; i < [readings_on count]; i++) {

        NSString *currentReading = [readings_on objectAtIndex:i];
        
        UILabel *onReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(currPos + 5, READING_BOX_TOP + 7.5, 270, 20)];
        onReadingLabel.text = currentReading;//@"イチ, イツ";
        onReadingLabel.textColor = [UIColor whiteColor];
        onReadingLabel.font = [UIFont systemFontOfSize:18.0f];
        // No attributed text processing in On readings
        
        int labelWidth = [self widthOfString:onReadingLabel.text withFont:onReadingLabel.font] + 10;
        int newRemSpace = remainingSpace - (labelWidth + READING_GAP); // Calc how much drawing space is still available
        
        if (newRemSpace < 0) {
            NSLog(@"[Card] No more space available for drawing On-yomi readings.");
            break;
        } else {
            remainingSpace = newRemSpace;
        }
        
        // 1. Create bezier path to draw
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(currPos, READING_OFFSET_TOP, labelWidth, READING_HEIGHT) cornerRadius:READING_HEIGHT/2];
        
        // 2. Create a shape layer for above created path.
        CAShapeLayer *readingLayer = [[CAShapeLayer alloc] init];
        readingLayer.strokeColor = [[UIColor colorWithRed:(75.0 / 255.0) green:(135.0 / 255.0) blue:(245.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineWidth = 2.0;
        readingLayer.fillColor = [[UIColor colorWithRed:(25.0 / 255.0) green:(95.0 / 255.0) blue:(235.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineJoin = kCALineJoinBevel;
        readingLayer.path = path.CGPath;
        
        [self.readingsView.layer addSublayer:readingLayer];
        
        [self addSubview:onReadingLabel];
        
        currPos = currPos + labelWidth + READING_GAP;
    }
}

- (void) drawKunReadingLabels:(NSMutableArray *)readings_kun {
    
    // Calc remaining space left to draw within:
    int currPos = READING_BOX_LEFT + READING_OFFSET_LEFT;
    int remainingSpace = CARD_WIDTH - currPos;
    
    for (int i = 0; i < [readings_kun count]; i++) {
        
        NSString *currentReading = [readings_kun objectAtIndex:i];
            
        UILabel *kunReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(currPos + 5, READING_BOX_TOP + 40, 270, 20)];
        kunReadingLabel.text = currentReading;//@"ひと, ひと.つ";
        kunReadingLabel.textColor = [UIColor whiteColor];
        kunReadingLabel.font = [UIFont systemFontOfSize:18.0f];
        
        // Kun-readings only: format text for reading-endings
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]
                                                     initWithString:[currentReading stringByReplacingOccurrencesOfString:@"." withString:@""]];
        
        NSRange range = [[readings_kun objectAtIndex:i] rangeOfString:@"."];
        if (range.location != NSNotFound) {
            // Need to remove period and format reading-endings
            //NSLog(@"[Card] Period at: %lu, length of string: %lu", (unsigned long)range.location, (unsigned long)[[readings_kun objectAtIndex:i] length]);
            
            [kunReadingLabel setTextColor:[UIColor colorWithRed:(255.0 / 255.0) green:(145.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
            
            [attributedText addAttribute:NSForegroundColorAttributeName
                         value:[UIColor whiteColor]
                         range:NSMakeRange(0, range.location)];
            [kunReadingLabel setAttributedText: attributedText];
        }
        
        int labelWidth = [self widthOfString:kunReadingLabel.text withFont:kunReadingLabel.font] + 10;
        int newRemSpace = remainingSpace - (labelWidth + READING_GAP); // Calc how much drawing space is still available
        
        if (newRemSpace < 0) {
            NSLog(@"[Card] No more space available for drawing Kun-yomi readings.");
            break;
        } else {
            remainingSpace = newRemSpace;
        }
        
        // 1. Create bezier path to draw
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(currPos, 37.5, labelWidth, READING_HEIGHT) cornerRadius:READING_HEIGHT/2];
        
        // 2. Create a shape layer for above created path.
        CAShapeLayer *readingLayer = [[CAShapeLayer alloc] init];
        readingLayer.strokeColor = [[UIColor colorWithRed:(250.0 / 255.0) green:(90.0 / 255.0) blue:(160.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineWidth = 2.0;
        readingLayer.fillColor = [[UIColor colorWithRed:(235.0 / 255.0) green:(25.0 / 255.0) blue:(95.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineJoin = kCALineJoinBevel;
        readingLayer.path = path.CGPath;
        
        [self.readingsView.layer addSublayer:readingLayer];
        
        [self addSubview:kunReadingLabel];
        
        currPos = currPos + labelWidth + READING_GAP;
    }
}

- (void)drawMeaningLabels:(NSMutableArray *)meanings {
    
    for (int i = 0; i < [meanings count]; i++) {
        
        if (i < 6) {
            
            // 1. Create bezier path to draw
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(CONTENT_OFFSET_LEFT , MEANING_BOX_TOP + i*MEANING_SPACING, MEANING_BUBBLE_WIDTH, MEANING_HEIGHT) cornerRadius:5];
            
            // 2. Create a shape layer for above created path.
            CAShapeLayer *meaningCountBubble = [[CAShapeLayer alloc] init];
            meaningCountBubble.fillColor = [[UIColor colorWithRed:(235.0 / 255.0) green:(235.0 / 255.0) blue:(235.0 / 255.0) alpha: 1] CGColor];
            meaningCountBubble.path = path.CGPath;
            [self.layer addSublayer:meaningCountBubble];
            
            UILabel *meaningCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_OFFSET_LEFT, MEANING_BOX_TOP + i*MEANING_SPACING, MEANING_BUBBLE_WIDTH, MEANING_HEIGHT)];
            meaningCountLabel.text = [NSString stringWithFormat:@"%d", i+1];
            meaningCountLabel.textAlignment = NSTextAlignmentCenter;
            meaningCountLabel.textColor = [UIColor lightGrayColor];
            [self addSubview:meaningCountLabel];
            
            UILabel *meaningLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENT_OFFSET_LEFT + MEANING_BUBBLE_WIDTH + 5, MEANING_BOX_TOP + i*MEANING_SPACING, 270, MEANING_HEIGHT)];
            meaningLabel.text = [meanings objectAtIndex:i];
            meaningLabel.textColor = [UIColor darkGrayColor];
            meaningLabel.font = [UIFont systemFontOfSize: 20.0f];
            [self addSubview:meaningLabel];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(225.0 / 255.0) green:(225.0 / 255.0) blue:(225.0 / 255.0) alpha: 1].CGColor);
    
    CGRect rectangle = CGRectMake(READING_BOX_LEFT, READING_BOX_TOP, READING_BOX_WIDTH, READING_BOX_HEIGHT);
    CGContextAddRect(context, rectangle);
    
    CGContextStrokePath(context);
    
    CGContextAddRect(context, rectangle);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(245.0 / 255.0) green:(245.0 / 255.0) blue:(245.0 / 255.0) alpha: 1].CGColor);
    CGContextFillPath(context);
    
    // Draw bubble for JLPT level
    
    CGContextSetLineWidth(context, 2.0);
    self.transform = CGAffineTransformIdentity;
    rectangle = CGRectMake(JLPT_BUBBLE_OFFSET, CARD_HEIGHT - (JLPT_BUBBLE_OFFSET + 34.1), JLPT_BUBBLE_SIZE, JLPT_BUBBLE_SIZE);
    CGContextAddEllipseInRect(context, rectangle);
    //CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(230.0 / 255.0) green:(230.0 / 255.0) blue:(230.0 / 255.0) alpha: 1].CGColor);
    CGContextFillPath(context);
    
}


//- (void) buttonClicked: (id)sender
//{
//    [UIView animateWithDuration:0.25f
//                          delay:0
//                        options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
//                     animations:^{[self setCenter:CGPointMake(160, -200)]; }
//                     completion:^(BOOL fin) { [self removeFromSuperview]; }  ];
//    
//    // Decrease the number of tracked active cards
//    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
//    [controller decActiveCardCount];
//    
//}

//// Respond to a swipe gesture
//- (IBAction)showGestureForSwipeRecognizer:(UISwipeGestureRecognizer *)recognizer {
//    // Get the location of the gesture
//    CGPoint location = [recognizer locationInView:self];
//    
//    // Display an image view at that location
//    [self drawImageForGestureRecognizer:recognizer atPoint:location];
//    
//    // If gesture is a left swipe, specify an end location
//    // to the left of the current location
//    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
//        location.y -= 220.0;
//    } else {
//        location.y += 220.0;
//    }
//    
//    // Animate the image view in the direction of the swipe as it fades out
//    [UIView animateWithDuration:0.5 animations:^{
//        self.imageView.alpha = 0.0;
//        self.imageView.center = location;
//    }];
//}


#pragma mark - SRS Logic

// Calc time until next repetition, attempt to exit card from deck
- (void)calcNextRepetition {
    
    // Set to current date
    self.studyDetails.lastStudied = [[NSDate alloc] init];
    
    // Next interval number (first reschedule is interval 1)
    self.studyDetails.intervalNum = [NSNumber numberWithInt:[self.studyDetails.intervalNum intValue] + 1];
    
    // Calc inter-repetition interval after the n-th repetition (in days)
    if ([self.studyDetails.intervalNum intValue] == 1) {
        self.studyDetails.interval = [NSNumber numberWithInt:1];
    } else if ([self.studyDetails.intervalNum intValue] == 2) {
        self.studyDetails.interval = [NSNumber numberWithInt:6];
    } else {
        // Rounding up any fractions
        self.studyDetails.interval = [NSNumber numberWithInt:ceil([self.studyDetails.interval intValue] * [self.studyDetails.eFactor intValue])];
    }
    
    if (self.repQuality > 3) {
        // EF':=EF+(0.1-(5-q)*(0.08+(5-q)*0.02))
        double newFactor = [self.studyDetails.eFactor intValue] + (0.1 - (5 - self.repQuality) * (0.08 + (5 - self.repQuality) * 0.02));
        
        if (newFactor < 1.3) {
            newFactor = 1.3;
        }
        
        self.studyDetails.eFactor = [NSNumber numberWithDouble:newFactor];
        
    } else {
        
        // Repetition quality was too low.
        // Start repetitions anew, as if newly memorised.
        
        self.studyDetails.intervalNum = 0;
        self.studyDetails.interval = 0;
        self.studyDetails.quality = nil;
        self.studyDetails.eFactor = [NSNumber numberWithDouble:2.5]; // Default value
    }

    
    // Save all new values to context
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
}

- (void)gradeCard:(BOOL)isCorrect {
    
    CGPoint destPoint;
    NSString *animName;
    BOOL autoReverses = false;
    
    if (isCorrect) {
        // Card marked correct
        
        if ((self.tempStudyDetails.numCorrect.intValue - self.tempStudyDetails.numIncorrect.intValue) < 2) {
            // Haven't reached correct treshold. Keep studying.
            
            destPoint = CGPointMake(-SCREEN_HEIGHT*0.4, -SCREEN_HEIGHT*0.4);
            animName = @"popCorrectCard";
            autoReverses = true;
            
            self.tempStudyDetails.numCorrect = [NSNumber numberWithInt:([self.tempStudyDetails.numCorrect intValue] + 1)];
            
        } else {
            // Third correct call, can attempt to exit card

            // q (repQuality)
            //
            // 5 = perfect
            // 4 = 1 wrong
            // 3 = 2 wrong
            // 2 = 3 wrong
            // 1 = 4 wrong
            // 0 = anything less
            
            self.repQuality = 5 - self.tempStudyDetails.numIncorrect.intValue;
            
            if (self.repQuality < 0) {
                // Ensure q lies between 0 and 5.
                self.repQuality = 0;
            }
            
            //studyDetails.quality = [NSNumber numberWithInt:repQuality];   //<<- Unnecessary?
            
            // Calc number of days until next study interation.
            // Note: Need to keep studying card today if q < 4
            [self calcNextRepetition];
            
            if (self.repQuality >= 4) {
                // Card was well enough remembered that it can be removed from the deck. Animate and dismiss card.
                
                destPoint = CGPointMake(-SCREEN_HEIGHT/2, -SCREEN_HEIGHT/2);
                animName = @"popCorrectCardDone";

                // First reset all short-term study stats.
                [self.tempStudyDetails setIsStudying:[NSNumber numberWithBool:false]];
                self.tempStudyDetails.numIncorrect = @0;
                self.tempStudyDetails.numCorrect = @0;
                
                NSError *error = nil;
                [self.managedObjectContext save:&error];
                
            } else {
                // After each repetition session of a given day repeat again all items that scored below four in the quality assessment.
                // Continue the repetitions until all of these items score at least four.
                
                destPoint = CGPointMake(-SCREEN_HEIGHT*0.4, -SCREEN_HEIGHT*0.4);
                animName = @"popCorrectCard";
                autoReverses = true;
                
                NSLog(@"[Card] Study quality was below 4 for card %d. Restarting short-term study.", self.cardNum);
                
                self.tempStudyDetails.numCorrect = @0;
                self.tempStudyDetails.numIncorrect = @0;
            }
        }
        
    } else {
        // Card was marked incorrect
        
        self.tempStudyDetails.numIncorrect = [NSNumber numberWithInt:([self.tempStudyDetails.numIncorrect intValue] + 1)];
        
        // SENDING TO BACK DOESN'T CORRECTLY UPDATE DECK TRACKERS!!!
        
        // Reinsert at back of back (currently - need to insert nearer the front.)
        destPoint = CGPointMake(SCREEN_HEIGHT*1.4, SCREEN_HEIGHT*1.4);
        animName = @"popIncorrectCard";
        autoReverses = true;
    }
    
    // Create and perform animation
    POPBasicAnimation *popMoveCard = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    popMoveCard.toValue = [NSValue valueWithCGPoint:destPoint];
    popMoveCard.autoreverses = autoReverses;
    popMoveCard.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    popMoveCard.delegate = self;
    popMoveCard.name = animName;
    popMoveCard.duration = CARD_ANIMATION_DURATION/2;
    [self pop_addAnimation:popMoveCard forKey:animName];
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
}



#pragma mark - Gesture Recognisers

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    
    // Card is marked as correct
    [self gradeCard:true];

}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    
    // Card is marked as incorrect
    [self gradeCard:false];
    
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    if ([controller getActiveCardCount] > 1) {
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(457, CARD_HEIGHT/2 + 55)]; }
                         completion:^(BOOL fin) { [self.superview sendSubviewToBack:self ]; [UIView animateWithDuration:0.2f
                                                                                                                  delay:0
                                                                                                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                                                                                             animations:^{[self setCenter:CGPointMake(160, CARD_HEIGHT/2 + 55)]; }
                                                                                                             completion:^(BOOL fin) { [controller moveCardToBack:self]; }  ]; }  ];
    };
    
}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    if ([controller getActiveCardCount] > 1) {
        // THIS IS BROKEN
        //[controller moveBackCardToFront];
    }
    
//    if ([controller getCardsActive] > 1) {
//        
//        [UIView animateWithDuration:0.25f
//                              delay:0
//                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
//                         animations:^{[self setCenter:CGPointMake(-137, self.frame.size.height/2 + 58)]; }
//                         completion:^(BOOL fin) { [self.superview sendSubviewToBack:self ]; [UIView animateWithDuration:0.2f
//                                                                                                                  delay:0
//                                                                                                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
//                                                                                                             animations:^{[self setCenter:CGPointMake(160, self.frame.size.height/2 + 58)]; }
//                                                                                                             completion:^(BOOL fin) { [controller shuffleCard:self]; }  ]; }  ];
//    };
    
}

- (void)handleTap:(UIGestureRecognizer*)recognizer {
    
    if (frontShowing) {
        [self.frontView setHidden:YES];
    } else {
        [self.frontView setHidden:NO];
    };
    
    frontShowing = !frontShowing;
    
}

//- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
//{
//    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
//    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
//    
//    NSLog(@"[Card] %f,%f,%f,%f",xDistance,yDistance,[gestureRecognizer velocityInView:self].x,[gestureRecognizer velocityInView:self].y);
//    
//    CGFloat velocityY = -1*[gestureRecognizer velocityInView:self].y;
//    NSTimeInterval duration = CARD_HEIGHT / velocityY;
//    
//    CGFloat draggedDistX, draggedDistY, distRemainingY;
//    
//    CGFloat xDestination;
//    
//    draggedDistY = -(self.center.y - self.originalPoint.y)/2; // Need to convert to points
//    draggedDistX = (self.center.x - self.originalPoint.x)/2;
//    distRemainingY = SCREEN_HEIGHT*0.5 - draggedDistY;
//    
//    xDestination = ((SCREEN_HEIGHT*0.5/draggedDistY) * draggedDistX) + SCREEN_WIDTH*0.5;
//    
//    //NSLog(@"[Card] %f",duration);
//    
//    switch (gestureRecognizer.state) {
//        case UIGestureRecognizerStateBegan:{
//            self.originalPoint = self.center;
//            break;
//        };
//        case UIGestureRecognizerStateChanged:{
//            CGFloat rotationStrength = MIN(xDistance / 320, 1);
//            CGFloat rotationAngle = (CGFloat) (2*M_PI * rotationStrength / 64);
//            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
//            CGFloat scale = MAX(scaleStrength, 0.93);
//            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
//            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
//            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
//            self.transform = scaleTransform;
//            
//            NSLog(@"[Card] Y Dist: %f, Y Rem: %f, X Dest: %f",draggedDistY,distRemainingY,xDestination);
//            
//            break;
//        };
//        case UIGestureRecognizerStateEnded: {
//            
//            if (duration > 0.25 || velocityY > 150) {
//                duration = 0.25;
//            }
//            
//            if (yDistance < -150) {
//                
//                StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
//                
//                [controller handleCorrectCard:self willExitDeck:false];
//                
//                [gestureRecognizer velocityInView:self];
//                
//                NSLog(@"[Card] Y Dist: %f, Y Rem: %f, X Dest: %f",draggedDistY,distRemainingY,xDestination);
//                
//                [UIView animateWithDuration:duration
//                                      delay:0
//                                    options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
//                                 animations:^{[self setCenter:CGPointMake(xDestination, -SCREEN_HEIGHT*0.5)]; }
//                                 completion:^(BOOL fin) { [controller dismissTopCard:self]; }  ];
//                
//            } else if (yDistance > 150) {
//                
//                StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
//                
//                [controller handleIncorrectCard:self];
//                
//                [UIView animateWithDuration:duration
//                                      delay:0
//                                    options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
//                                 animations:^{[self setCenter:CGPointMake(160, SCREEN_HEIGHT*1.5)]; }
//                                 completion:^(BOOL fin) { [controller dismissTopCard:self]; }  ];
//                
//            } else {
//                [self resetViewPositionAndTransformations];
//            }
//            
//            break;
//        };
//        case UIGestureRecognizerStatePossible:break;
//        case UIGestureRecognizerStateCancelled:break;
//        case UIGestureRecognizerStateFailed:break;
//    }
//}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = self.originalPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                     }];
}

- (void)addGestureRecognisers {

    // Create and initialize recognisers for tap and drag gestures

    //UIPanGestureRecognizer* panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
//    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
//    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
//    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    // Add the tap gesture recognizer to the view
//    [self addGestureRecognizer:panGestureRecognizer];
    
    [self addGestureRecognizer:swipeUpGestureRecognizer];
    [self addGestureRecognizer:swipeDownGestureRecognizer];
//    [self addGestureRecognizer:swipeRightGestureRecognizer];
//    [self addGestureRecognizer:swipeLeftGestureRecognizer];
    
    [self addGestureRecognizer:tapGestureRecognizer];
    
}

#pragma mark - POP Delegate

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    
    StudyViewController *controller = (StudyViewController*) [[self superview] nextResponder];

    if ([anim.name isEqualToString:@"popCorrectCard"]) {
        NSLog(@"Type: 1");
        if (finished) {
            // Original position
            [controller handleCorrectCard:self willExitDeck:false];
        } else {
            // Mid-transition
            [self.superview sendSubviewToBack:self];
        }
        
    } else if ([anim.name isEqualToString:@"popCorrectCardDone"]) {
        NSLog(@"Type: 2");
        [controller handleCorrectCard:self willExitDeck:true];
        
    } else if ([anim.name isEqualToString:@"popIncorrectCard"]) {
        NSLog(@"Type: 3");
        if (finished) {
            // Original position
            [controller handleIncorrectCard:self];
        } else {
            // Mid-transition
            [self.superview sendSubviewToBack:self];
        }
    }
};

@end
