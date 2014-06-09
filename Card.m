//
//  Card.m
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#define MY_DELEGATE (AppDelegate*)[[UIApplication sharedApplication] delegate]

#import "Card.h"
#import "StudyViewController.h"
#import "Kanji.h"
#import "Character.h"

@implementation Card

@synthesize managedObjectContext;
@synthesize characters;

@synthesize cardNum;

NSArray* kanjiArray;

int screenWidth;
int screenHeight;

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

- (id)initCard:(CGRect)frame :(int)cardNumInput
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        screenWidth = [UIScreen mainScreen].bounds.size.width;
        screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        kanjiArray = @[@"零", @"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"江", @"里", @"菜", @"駒"];
        
        cardNum = cardNumInput;
        // Reference to Background view controller
        //StudyBackground* controller = (StudyBackground*) [[self superview] nextResponder];
        
        CGRect newFrame = self.frame;
        newFrame.size.width = 290;
        newFrame.size.height = [UIScreen mainScreen].bounds.size.height - 70;
        //newFrame.size.height = 400;
        [self setFrame:newFrame];
        
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width / 2) + (self.frame.origin.x) - 75, 35, 150, 30)];
//        title.text = @"Sample Card";
//        [title setTextColor:[UIColor darkGrayColor]];
//        [title setBackgroundColor:[UIColor clearColor]];
//        [title setFont:[UIFont fontWithName: @"Trebuchet MS" size: 22.0f]];
        //[title setCenter:CGPointMake((self.frame.size.width / 2) + (self.frame.origin.x), 35)];
        //[self addSubview:title];
        
        //NSLog([controller selectKanji:2]);
        id delegate = [[UIApplication sharedApplication] delegate];
        
        self.managedObjectContext = [delegate managedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Character" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        self.characters = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        Character *character = [characters objectAtIndex:cardNum];
        //cell.textLabel.text = character.literal;
        
        UILabel *kanjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        kanjiLabel.text = character.literal;//kanjiArray[cardNum%15];
        [kanjiLabel setTextColor:[UIColor darkGrayColor]];
        [kanjiLabel setBackgroundColor:[UIColor clearColor]];
        [kanjiLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 100.0f]];
        //[title setCenter:CGPointMake((self.frame.size.width / 2) + (self.frame.origin.x), 35)];
        [self addSubview:kanjiLabel];
        
        UILabel *pinyinLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 80, 100, 20)];
        pinyinLabel.text = @"Pinyin:";
        [pinyinLabel setTextColor:[UIColor lightGrayColor]];
        [pinyinLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 15.0f]];
        [self addSubview:pinyinLabel];
        
        UILabel *pinyinReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 80, 100, 20)];
        pinyinReadingLabel.text = character.reading_pin;//@"yi1";
        [pinyinReadingLabel setTextColor:[UIColor darkGrayColor]];
        [pinyinReadingLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 17.0f]];
        [self addSubview:pinyinReadingLabel];
        
        /*UILabel *onLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 310, 100, 20)];
        onLabel.text = @"On'yomi:";
        [onLabel setTextColor:[UIColor lightGrayColor]];
        [onLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 17.0f]];
        [self addSubview:onLabel];*/
        
        UILabel *onReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 200, 20)];
        onReadingLabel.text = character.reading_on;//@"イチ, イツ";
        [onReadingLabel setTextColor:[UIColor colorWithRed:(170.0 / 255.0) green:(80.0 / 255.0) blue:(80.0 / 255.0) alpha: 1]];
        [onReadingLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
        [self addSubview:onReadingLabel];
        
        /*UILabel *kunLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 340, 100, 20)];
        kunLabel.text = @"Kun'yomi:";
        [kunLabel setTextColor:[UIColor lightGrayColor]];
        [kunLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 17.0f]];
        [self addSubview:kunLabel];*/
        
        UILabel *kunReadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 200, 50, 150, 20)];
        kunReadingLabel.text = character.reading_kun;//@"ひと, ひと.つ";
        [kunReadingLabel setTextColor:[UIColor colorWithRed:(80.0 / 255.0) green:(80.0 / 255.0) blue:(170.0 / 255.0) alpha: 1]];
        [kunReadingLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 18.0f]];
        [self addSubview:kunReadingLabel];
        
//        UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
//        [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
//        [dismissButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        [dismissButton.titleLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 14.0f]];
//        [dismissButton addTarget:self
//                          action: @selector(buttonClicked:)
//                forControlEvents: UIControlEventTouchDown];
//        [self addSubview:dismissButton];

        UILabel *jlptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenHeight - 110, 60, 30)];
        
        NSLog(@"JLPT: %@", character.jlpt);
        if (![character.jlpt  isEqual: @"null"]) {
            NSString *jlptString = jlptString = [@"N" stringByAppendingString:character.jlpt];
            jlptLabel.text = jlptString;
        };
        [jlptLabel setTextColor:[UIColor lightGrayColor]];
        [jlptLabel setBackgroundColor:[UIColor clearColor]];
        [jlptLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
        [self addSubview:jlptLabel];
        
        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, screenHeight - 110, 60, 30)];
        countLabel.text = [NSString stringWithFormat:@"#%d", cardNum];
        countLabel.textAlignment = NSTextAlignmentRight;
        [countLabel setTextColor:[UIColor lightGrayColor]];
        [countLabel setBackgroundColor:[UIColor clearColor]];
        [countLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 30.0f]];
        
        //[countLabel setCenter:CGPointMake(200, (self.frame.size.height / 2))];
        [self addSubview:countLabel];
        
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(160, 305)]; }
                         completion:^(BOOL fin) {}];
        
        //[UIView animateWithDuration:0.7f animations:^{[self setCenter:CGPointMake(160, -200)]; }];
        
        Kanji *test = [Kanji alloc];
        
        test.character = @"一";
        //kanjiLabel.text = test.character;
    }
    
    

    
    
    
    [self addGestureRecognisers];
    
    return self;
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
    [controller decCardsActive];
    
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

- (void)handleSwipeUpFrom:(UIGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{[self setCenter:CGPointMake(160, -screenHeight*0.5)]; }
                     completion:^(BOOL fin) { [self removeFromSuperview]; }  ];
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    [controller decCardsActive];
    
    [controller cardRight];
    
}

- (void)handleSwipeDownFrom:(UIGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{[self setCenter:CGPointMake(160, screenHeight*1.5)]; }
                     completion:^(BOOL fin) { [self removeFromSuperview]; }  ];
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    [controller decCardsActive];
    
    [controller cardWrong];
}

- (void)handleSwipeRightFrom:(UIGestureRecognizer*)recognizer {
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Background *backgrd = self.superclass;
    //[[backgrd decCardsActive];
     
    // ((Background *)parentViewController)
    
    //Background *controller = (Background*)self.superclass; //window.rootViewController;
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    //NSLog([NSString stringWithFormat:@"Animating shuffle with %d active cards.", [controller getCardsActive]]);
    
    if ([controller getCardsActive] > 1) {
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(457, 300)]; }
                         completion:^(BOOL fin) { [self.superview sendSubviewToBack:self ]; [UIView animateWithDuration:0.2f
                                                                                                                  delay:0
                                                                                                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                                                                                             animations:^{[self setCenter:CGPointMake(160, 305)]; }
                                                                                                             completion:^(BOOL fin) { }  ]; }  ];
    };

    
}

- (void)handleSwipeLeftFrom:(UIGestureRecognizer*)recognizer {
    
    StudyViewController* controller = (StudyViewController*) [[self superview] nextResponder];
    
    if ([controller getCardsActive] > 1) {
        
        [UIView animateWithDuration:0.25f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[self setCenter:CGPointMake(-137, 300)]; }
                         completion:^(BOOL fin) { [self.superview sendSubviewToBack:self ]; [UIView animateWithDuration:0.2f
                                                                                                                  delay:0
                                                                                                                options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                                                                                                             animations:^{[self setCenter:CGPointMake(160, 305)]; }
                                                                                                             completion:^(BOOL fin) { }  ]; }  ];
    };
    
    
}

- (void)addGestureRecognisers {

    // Create and initialize a swipe gesture
    //UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
    //                                         initWithTarget:self action:@selector(respondToTapGesture:)];
    UISwipeGestureRecognizer* swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer* swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDownFrom:)];
    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftFrom:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // Add the tap gesture recognizer to the view
    [self addGestureRecognizer:swipeUpGestureRecognizer];
    [self addGestureRecognizer:swipeDownGestureRecognizer];
    [self addGestureRecognizer:swipeRightGestureRecognizer];
    [self addGestureRecognizer:swipeLeftGestureRecognizer];
    
    //NSLog(@"Added Gesture Recognisers");
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
