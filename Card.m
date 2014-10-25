//
//  Card.m
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//
//  kanjiArray = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"江", @"里", @"菜", @"駒"];
//

#define MY_DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]

#import "Card.h"
#import "StudyViewController.h"
#import "Character.h"
#import "StudyDetails.h"

@implementation Card

@synthesize managedObjectContext;
@synthesize characters;

@synthesize cardNum;
@synthesize character;
@synthesize studyDetails;

@synthesize frontView;
@synthesize readingsView;

@synthesize originalPoint;

@synthesize repQuality; // Intra-repetition quality
@synthesize correctCount;
@synthesize incorrectCount;

int screenWidth;
int screenHeight;

#define CARD_WIDTH self.frame.size.width
#define CARD_HEIGHT self.frame.size.height

#define LEFT_OFFSET 15
#define UPPER_OFFSET 15

#define READ_BOX_LEFT 0
#define READ_BOX_UPPER UPPER_OFFSET + 110
#define READ_BOX_WIDTH CARD_WIDTH
#define READ_BOX_HEIGHT 90

#define READING_GAP 5

bool frontShowing;

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
//                         completion:^(BOOL fin) {NSLog(@"done");}   ];
//        
//        //[UIView animateWithDuration:0.7f animations:^{[self setCenter:CGPointMake(160, -200)]; }];
//    }
//    return self;
//}

- (id)initCard:(CGRect)frame :(int)cardNumInput fresh:(BOOL)fresh
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        frontShowing = true;
        
        cardNum = cardNumInput;
        
        correctCount = 0;
        incorrectCount = 0;
        
        // Reference to Background view controller
        //StudyBackground* controller = (StudyBackground*) [[self superview] nextResponder];
        
        
        // Screen dimensions: 320x568
        CGRect newFrame = self.frame;
        newFrame.size.width = 290;
        newFrame.size.height = 458;//[UIScreen mainScreen].bounds.size.height - 110;
        
        [self setFrame:newFrame];
        
        id delegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [delegate managedObjectContext];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Character" inManagedObjectContext:managedObjectContext];

        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id_num == %d", cardNum]];
        [fetchRequest setEntity:entity];
        NSError *error;
        self.characters = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        character = [characters firstObject];
        studyDetails = character.studyDetails;
        NSLog(@"Requesting card #%d - %@ (ID: %@)",cardNum,character.literal,character.id_num);
        
        // Unpack the character's arrays
        
        NSMutableArray *readings_pin = [NSKeyedUnarchiver unarchiveObjectWithData:character.reading_pin];
        NSMutableArray *readings_kun = [NSKeyedUnarchiver unarchiveObjectWithData:character.reading_kun];
        NSMutableArray *readings_on = [NSKeyedUnarchiver unarchiveObjectWithData:character.reading_on];
        NSMutableArray *meanings = [NSKeyedUnarchiver unarchiveObjectWithData:character.meaning];
        
        // Init Readings View
        
        readingsView = [[UIImageView alloc] initWithFrame:CGRectMake(READ_BOX_LEFT,READ_BOX_UPPER,READ_BOX_WIDTH,READ_BOX_HEIGHT)];
        [self addSubview:readingsView];
        
        //
        // Prepare Card Labels
        //
        
        UILabel *kanjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET, UPPER_OFFSET, 100, 100)];
        kanjiLabel.text = character.literal;
        [kanjiLabel setTextColor:[UIColor darkGrayColor]];
        [kanjiLabel setBackgroundColor:[UIColor clearColor]];
        [kanjiLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 100.0f]];
        [self addSubview:kanjiLabel];
        
        UILabel *pinyinLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET, UPPER_OFFSET + 175, 100, 20)];
        pinyinLabel.text = @"Pinyin:";
        [pinyinLabel setTextColor:[UIColor lightGrayColor]];
        [pinyinLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 15.0f]];
        [self addSubview:pinyinLabel];
        
        UILabel *pinyinReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + 55, UPPER_OFFSET + 175, 215, 20)];
        pinyinReadingLabel.text = [readings_pin firstObject];//@"yi1";
        [pinyinReadingLabel setTextColor:[UIColor darkGrayColor]];
        [pinyinReadingLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 17.0f]];
        [self addSubview:pinyinReadingLabel];
        
        [self drawOnReadingLabels:readings_on];
        
        [self drawKunReadingLabels:readings_kun];
        
        // Array to contain all meaning labels
        NSMutableArray *meaningLabels = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [meanings count]; i++) {
            
            if (i < 6) {
                
                UILabel *meaningLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET, UPPER_OFFSET + 205 + i*30, 270, 25)];
                [meaningLabel setTextColor:[UIColor darkGrayColor]];
                
                NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
                                                   initWithString: [NSString stringWithFormat: @"%d. %@", i+1, [meanings objectAtIndex:i]]];
                [text addAttribute:NSForegroundColorAttributeName
                             value:[UIColor lightGrayColor]
                             range:NSMakeRange(0, 2)];
                [meaningLabel setAttributedText: text];
                
                [meaningLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
                [self addSubview:meaningLabel];
                
                // Add label to array
                [meaningLabels addObject:meaningLabel];
                
            }

        }
        
//        UILabel *meaningLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, 270, 25)];
//        meaningLabel.text = [meanings firstObject];
//        [meaningLabel setTextColor:[UIColor darkGrayColor]];
//        [meaningLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
//        [self addSubview:meaningLabel];
        
//        UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
//        [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
//        [dismissButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [dismissButton.titleLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
//        [dismissButton addTarget:self
//                          action: @selector(buttonClicked:)
//                forControlEvents: UIControlEventTouchDown];
//        [self addSubview:dismissButton];

        UILabel *jlptLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_OFFSET + 0.4, self.frame.size.height - 40.8, 60, 30)];
        
        if (![character.jlpt  isEqual: @"null"]) {
            NSString *jlptString = jlptString = [@"N" stringByAppendingString:character.jlpt];
            jlptLabel.text = jlptString;
        };
        [jlptLabel setTextColor:[UIColor colorWithRed:(170.0 / 255.0) green:(170.0 / 255.0) blue:(170.0 / 255.0) alpha: 1]];
        [jlptLabel setBackgroundColor:[UIColor clearColor]];
        [jlptLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
        [self addSubview:jlptLabel];
//        
//        UILabel *cardNumPrefix = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 75, 15, 20, 30)];
//        cardNumPrefix.text = [NSString stringWithFormat:@"#"];
//        [cardNumPrefix setTextColor:[UIColor lightGrayColor]];
//        //[cardNumPrefix setBackgroundColor:[UIColor clearColor]];
//        [cardNumPrefix setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
//        [self addSubview:cardNumPrefix];
        
        UILabel *cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 80, UPPER_OFFSET, 60, 25)];
        cardNumLabel.text = [NSString stringWithFormat:@"# %d", cardNum + 1];
        cardNumLabel.textAlignment = NSTextAlignmentRight;
        [cardNumLabel setTextColor:[UIColor lightGrayColor]];
        [cardNumLabel setBackgroundColor:[UIColor clearColor]];
        [cardNumLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
        [self addSubview:cardNumLabel];
        
        [self setupFrontView];
        
        if (fresh) {
            [UIView animateWithDuration:0.25f
                                  delay:0
                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                             animations:^{[self setCenter:CGPointMake(160, self.frame.size.height/2 + 56)]; }
                             completion:^(BOOL fin) {}];
        }
        
        //[UIView animateWithDuration:0.7f animations:^{[self setCenter:CGPointMake(160, -200)]; }];
        
    }
    
    [self addGestureRecognisers];
    
    return self;
}

- (void) setupFrontView {
    
    CGRect frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    frontView = [[UIView alloc] initWithFrame:frame];
    [frontView setBackgroundColor:[UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 1]];
    
    UILabel *frontKanjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 75, self.frame.size.height/2 - 100, 150, 150)];
    frontKanjiLabel.text = character.literal;
    [frontKanjiLabel setTextColor:[UIColor darkGrayColor]];
    [frontKanjiLabel setBackgroundColor:[UIColor clearColor]];
    [frontKanjiLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 150.0f]];
    [self.frontView addSubview:frontKanjiLabel];
    
    [self addSubview:frontView];
}

- (void) drawOnReadingLabels:(NSMutableArray*)readings_on {
    
    // Card width is 290!
    int remSpace = CARD_WIDTH - 10; // Left Offset
    int currPos = READ_BOX_LEFT + 10;
    
    for (int i = 0; i < [readings_on count]; i++) {
            
        //~28,45,62
        int labelWidth = 12 + (int)[[readings_on objectAtIndex:i] length]*17;
        
        int newRemSpace = remSpace - (labelWidth + READING_GAP); // Calc how much drawing space is still available
        
        if (newRemSpace < 0) {
            NSLog(@"No more space available for drawing On-yomi readings.");
            break;
        } else {
            remSpace = newRemSpace;
        }
        
        // 1. Create bezier path to draw
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(currPos, 5, labelWidth, 25) cornerRadius:12.5];
        
        // 2. Create a shape layer for above created path.
        CAShapeLayer *readingLayer = [[CAShapeLayer alloc] init];
        readingLayer.strokeColor = [[UIColor colorWithRed:(75.0 / 255.0) green:(135.0 / 255.0) blue:(245.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineWidth = 2.0;
        readingLayer.fillColor = [[UIColor colorWithRed:(25.0 / 255.0) green:(95.0 / 255.0) blue:(235.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineJoin = kCALineJoinBevel;
        readingLayer.path = path.CGPath;
        
        [readingsView.layer addSublayer:readingLayer];
        
        UILabel *onReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(currPos + 5, READ_BOX_UPPER + 7.5, 270, 20)];
        onReadingLabel.text = [readings_on objectAtIndex:i];//@"イチ, イツ";
        [onReadingLabel setTextColor:[UIColor whiteColor]];
        
        //[onReadingLabel setTextColor:[UIColor colorWithRed:(120.0 / 255.0) green:(30.0 / 255.0) blue:(30.0 / 255.0) alpha: 1]];
        [onReadingLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
        [self addSubview:onReadingLabel];
        
        currPos = currPos + labelWidth + READING_GAP;
    }
    
}

- (void) drawKunReadingLabels:(NSMutableArray*)readings_kun {
    
    // Card width is 290!
    int remSpace = CARD_WIDTH - 10; // Left Offset
    int currPos = READ_BOX_LEFT + 10;
    
    for (int i = 0; i < [readings_kun count]; i++) {
            
        UILabel *kunReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(currPos + 5, READ_BOX_UPPER + 40, 270, 20)];
        kunReadingLabel.text = [readings_kun objectAtIndex:i];//@"ひと, ひと.つ";
        [kunReadingLabel setTextColor:[UIColor whiteColor]];
        
        NSMutableAttributedString *text = [readings_kun objectAtIndex:i];
        
        NSRange range = [[readings_kun objectAtIndex:i] rangeOfString:@"."];
        if (range.location != NSNotFound) {
            // Need to remove period and format
            //NSLog(@"Period at: %lu, length of string: %lu", (unsigned long)range.location, (unsigned long)[[readings_kun objectAtIndex:i] length]);
            
            [kunReadingLabel setTextColor:[UIColor colorWithRed:(255.0 / 255.0) green:(145.0 / 255.0) blue:(195.0 / 255.0) alpha: 1]];
            
            text = [[NSMutableAttributedString alloc]
                    initWithString:[[readings_kun objectAtIndex:i] stringByReplacingOccurrencesOfString:@"." withString:@""]];
            
            [text addAttribute:NSForegroundColorAttributeName
                         value:[UIColor whiteColor]
                         range:NSMakeRange(0, range.location)];
            [kunReadingLabel setAttributedText: text];
        }
        
        // Check labelSize
        
        //~28,45,62
        int labelWidth = 12 + (int)[text length]*17;
        
        int newRemSpace = remSpace - (labelWidth + READING_GAP); // Calc how much drawing space is still available
        
        if (newRemSpace < 0) {
            NSLog(@"No more space available for drawing Kun-yomi readings.");
            break;
        } else {
            remSpace = newRemSpace;
        }
        
        //[kunReadingLabel setTextColor:[UIColor colorWithRed:(30.0 / 255.0) green:(30.0 / 255.0) blue:(120.0 / 255.0) alpha: 1]];
        [kunReadingLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
        [self addSubview:kunReadingLabel];
        
        
        // 1. Create bezier path to draw
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(currPos, 37.5, labelWidth, 25) cornerRadius:12.5];
        
        // 2. Create a shape layer for above created path.
        CAShapeLayer *readingLayer = [[CAShapeLayer alloc] init];
        readingLayer.strokeColor = [[UIColor colorWithRed:(250.0 / 255.0) green:(90.0 / 255.0) blue:(160.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineWidth = 2.0;
        readingLayer.fillColor = [[UIColor colorWithRed:(235.0 / 255.0) green:(25.0 / 255.0) blue:(95.0 / 255.0) alpha: 1] CGColor];
        readingLayer.lineJoin = kCALineJoinBevel;
        readingLayer.path = path.CGPath;
        
        [readingsView.layer addSublayer:readingLayer];
        
        currPos = currPos + labelWidth + READING_GAP;
        
    }
}


- (void) buttonClicked: (id)sender
{
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{[self setCenter:CGPointMake(160, -200)]; }
                     completion:^(BOOL fin) { [self removeFromSuperview]; }  ];
    
    // Decrease the number of tracked active cards
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    [controller decActiveCardCount];
    
}

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





//
//
// SRS Logic
//
//

// Calc time until next repetition, attempt to exit card from deck
- (void)calcNextRepetition {
    
    // Set to current date
    studyDetails.lastStudied = [[NSDate alloc] init];
    
    // Next interval number (first reschedule is interval 1)
    studyDetails.intervalNum = [NSNumber numberWithInt:[studyDetails.intervalNum intValue] + 1];
    
    // Calc inter-repetition interval after the n-th repetition (in days)
    if ([studyDetails.intervalNum intValue] == 1) {
        studyDetails.interval = [NSNumber numberWithInt:1];
    } else if ([studyDetails.intervalNum intValue] == 2) {
        studyDetails.interval = [NSNumber numberWithInt:6];
    } else {
        // Rounding up any fractions
        studyDetails.interval = [NSNumber numberWithInt:ceil([studyDetails.interval intValue]*[studyDetails.eFactor intValue])];
    }
    
    if (repQuality > 3) {
        // EF':=EF+(0.1-(5-q)*(0.08+(5-q)*0.02))
        double newFactor = [studyDetails.eFactor intValue] + (0.1-(5-repQuality)*(0.08+(5-repQuality)*0.02));
        
        if (newFactor < 1.3) {
            newFactor = 1.3;
        }
        
        studyDetails.eFactor = [NSNumber numberWithDouble:newFactor];
        
    } else {
        
        // Repetition quality was too low.
        // Start repetitions anew, as if newly memorised.
        
        studyDetails.intervalNum = 0;
        studyDetails.interval = 0;
        studyDetails.quality = nil;
        studyDetails.eFactor = [NSNumber numberWithDouble:2.5]; // Default value
    }

    
    // Does this really need to be done often?
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
}

- (void)gradeCard:(BOOL)isCorrect {
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    // q (repQuality)
    //
    // 5 = perfect
    // 4 = 1 wrong
    // 3 = 2 wrong
    // 2 = 3 wrong
    // 1 = 4 wrong
    // 0 = anything less
    
    repQuality = 5 - incorrectCount;
    
    if (repQuality < 0) {
        // Ensure q lies between 0 and 5.
        repQuality = 0;
    }
    
    if (isCorrect) {
        studyDetails.quality = [NSNumber numberWithInt:5];
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(160, -screenHeight*0.5)]; }
                         completion:^(BOOL fin) { [controller dismissTopCard:self]; }  ];
        
    } else {
        studyDetails.quality = [NSNumber numberWithInt:0];
        
        // SENDING TO BACK DOESN'T UPDATE DECK TRACKERS!!!
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(160, screenHeight*1.35)]; }
                         completion:^(BOOL fin) { [self.superview sendSubviewToBack:self ]; [UIView animateWithDuration:0.2f
                                                                                                                  delay:0
                                                                                                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                                                                                             animations:^{[self setCenter:CGPointMake(160, self.frame.size.height/2 + 55)]; }
                                                                                                             completion:^(BOOL fin) { [controller shuffleCard:self]; }  ]; }  ];    }
    
}



//
//
// Gesture recognisers
//
//

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    
    // Card is marked as correct
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    [controller handleCorrectCard];
    
    if ((correctCount - incorrectCount) == 2) {
        // Third correct call, can attempt to exit card
        [self gradeCard:true];
        
        // Animate and dismiss card
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(160, -screenHeight*0.5)]; }
                         completion:^(BOOL fin) { [controller dismissTopCard:self]; }  ];
        
    } else {
        // Keep going
        correctCount++;
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(160, -screenHeight*0.35)]; }
                         completion:^(BOOL fin) { [self.superview sendSubviewToBack:self ];
                             
            [UIView animateWithDuration:0.2f
                                  delay:0
                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                             animations:^{[self setCenter:CGPointMake(160, self.frame.size.height/2 + 55)]; }
                             completion:^(BOOL fin) { [controller shuffleCard:self]; }  ]; }  ];
    }

}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    
    // Card is marked as incorrect
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    [controller handleIncorrectCard];
    
    incorrectCount++;
    
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{[self setCenter:CGPointMake(160, screenHeight*1.5)]; }
                     completion:^(BOOL fin) { [controller dismissTopCard:self]; }  ];

    //[self gradeCard:false];
    
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    if ([controller getActiveCardCount] > 1) {
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(457, self.frame.size.height/2 + 55)]; }
                         completion:^(BOOL fin) { [self.superview sendSubviewToBack:self ]; [UIView animateWithDuration:0.2f
                                                                                                                  delay:0
                                                                                                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                                                                                             animations:^{[self setCenter:CGPointMake(160, self.frame.size.height/2 + 55)]; }
                                                                                                             completion:^(BOOL fin) { [controller shuffleCard:self]; }  ]; }  ];
    };
    
}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    if ([controller getActiveCardCount] > 1) {
        [controller shuffleBackCard];
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
        [frontView setHidden:YES];
    } else {
        [frontView setHidden:NO];
    };
    
    frontShowing = !frontShowing;
    
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    NSLog(@"%f,%f,%f,%f",xDistance,yDistance,[gestureRecognizer velocityInView:self].x,[gestureRecognizer velocityInView:self].y);
    
    CGFloat velocityY = -1*[gestureRecognizer velocityInView:self].y;
    NSTimeInterval duration = CARD_HEIGHT / velocityY;
    
    CGFloat draggedDistX, draggedDistY, distRemainingY;
    
    CGFloat xDestination;
    
    draggedDistY = -(self.center.y - originalPoint.y)/2; // Need to convert to points
    draggedDistX = (self.center.x - originalPoint.x)/2;
    distRemainingY = screenHeight*0.5 - draggedDistY;
    
    xDestination = ((screenHeight*0.5/draggedDistY) * draggedDistX) + screenWidth*0.5;
    
    //NSLog(@"%f",duration);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngle = (CGFloat) (2*M_PI * rotationStrength / 64);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            
            NSLog(@"Y Dist: %f, Y Rem: %f, X Dest: %f",draggedDistY,distRemainingY,xDestination);
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            
            if (duration > 0.25 || velocityY > 150) {
                duration = 0.25;
            }
            
            if (yDistance < -150) {
                
                StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
                
                [controller handleCorrectCard];
                
                [gestureRecognizer velocityInView:self];
                
                NSLog(@"Y Dist: %f, Y Rem: %f, X Dest: %f",draggedDistY,distRemainingY,xDestination);
                
                [UIView animateWithDuration:duration
                                      delay:0
                                    options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                 animations:^{[self setCenter:CGPointMake(xDestination, -screenHeight*0.5)]; }
                                 completion:^(BOOL fin) { [controller dismissTopCard:self]; }  ];
                
            } else if (yDistance > 150) {
                
                StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
                
                [controller handleIncorrectCard];
                
                [UIView animateWithDuration:duration
                                      delay:0
                                    options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                 animations:^{[self setCenter:CGPointMake(160, screenHeight*1.5)]; }
                                 completion:^(BOOL fin) { [controller dismissTopCard:self]; }  ];
                
            } else {
                [self resetViewPositionAndTransformations];
            }
            
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

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
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    // Add the tap gesture recognizer to the view
//    [self addGestureRecognizer:panGestureRecognizer];
    
    [self addGestureRecognizer:swipeUpGestureRecognizer];
    [self addGestureRecognizer:swipeDownGestureRecognizer];
    [self addGestureRecognizer:swipeRightGestureRecognizer];
    [self addGestureRecognizer:swipeLeftGestureRecognizer];
    
    [self addGestureRecognizer:tapGestureRecognizer];
    
}











// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 4.0);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:(225.0 / 255.0) green:(225.0 / 255.0) blue:(225.0 / 255.0) alpha: 1].CGColor);
    
    CGRect rectangle = CGRectMake(READ_BOX_LEFT,READ_BOX_UPPER,READ_BOX_WIDTH,READ_BOX_HEIGHT);
    CGContextAddRect(context, rectangle);
    
    CGContextStrokePath(context);
    
    CGContextAddRect(context, rectangle);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(245.0 / 255.0) green:(245.0 / 255.0) blue:(245.0 / 255.0) alpha: 1].CGColor);
    CGContextFillPath(context);
    
    // Draw bubble for JLPT level
    
    CGContextSetLineWidth(context, 2.0);
    self.transform = CGAffineTransformIdentity;
    rectangle = CGRectMake(9.1,self.frame.size.height - 43.2,35,35);
    CGContextAddEllipseInRect(context, rectangle);
    //CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:(230.0 / 255.0) green:(230.0 / 255.0) blue:(230.0 / 255.0) alpha: 1].CGColor);
    CGContextFillPath(context);
    
}

@end
