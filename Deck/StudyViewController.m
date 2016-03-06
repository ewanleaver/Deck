//
//  Background.m
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "StudyViewController.h"
#import "Deck.h"
#import "Character.h"
#import "Card.h"

@interface StudyViewController ()

@property (nonatomic, strong) UIImageView *studyProgressBar;
@property (nonatomic, strong) UIView *progressBar;
@property (nonatomic, strong) UIView *correctBar;

@end

@implementation StudyViewController

@synthesize deckStudying;
@synthesize nextCardNo;

@synthesize deckEmptyLabel;
@synthesize keepStudyingButton;

int totalCardCount;

int activeCardCount;

int correctCardCount;
int incorrectCardCount;

float studiedRatio = 0;
float correctRatio = 0;

UILabel *activeCardCountLabel;

UILabel *correctLabel;
UILabel *incorrectLabel;

NSArray *kanjiArray;

NSMutableArray *inputDeckArray;

NSMutableArray *charsToStudy;
NSMutableArray *visibleCards;

int maxAllowedVisibleCards;

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define BAR_OFFSET 20

#define BAR_MAX_WIDTH (SCREEN_WIDTH - BAR_OFFSET*2)
#define BAR_HEIGHT 18

#define ACTIVE_CARD_COLOUR [UIColor whiteColor]
#define BORDER_COLOUR [UIColor colorWithRed:(210.0 / 255.0) green:(210.0 / 255.0) blue:(210.0 / 255.0) alpha: 1].CGColor
#define BORDER_WIDTH 3
#define CORNER_RADIUS 25


- (id)initWithDeck:(Deck *)d {
    NSLog(@"[StudyView] Studying deck '%@': %@ cards.",d.name,d.numToStudy);
    
    
    self = [super initWithNibName:nil bundle:nil];
    deckStudying = d;
    
    // Set background
    //UIImage *image = [UIImage imageNamed:@"Study Background.png"];
    self.view.backgroundColor = [UIColor colorWithRed:(205.0/255.0) green:(20.0/255.0) blue:(52.0/255.0) alpha:1];//[UIColor colorWithPatternImage:image];
    
    // Initially no cards active
    totalCardCount = 0;
    activeCardCount = 0;
    correctCardCount = 0;
    incorrectCardCount = 0;
    
    maxAllowedVisibleCards = 3;
    
    UIColor *activeCountColor = [UIColor colorWithRed:(160.0 / 255.0) green:(8.0 / 255.0) blue:(40.0 / 255.0) alpha: 1];
    
    activeCardCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 40, 22, 80, 25)];
    activeCardCountLabel.text = [NSString stringWithFormat:@"%d", activeCardCount];
    activeCardCountLabel.textAlignment = NSTextAlignmentCenter;
    [activeCardCountLabel setTextColor:activeCountColor];
    [activeCardCountLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 25.0f]];
    [self.view addSubview:activeCardCountLabel];
    
    self.studyProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(BAR_OFFSET, SCREEN_HEIGHT-37, BAR_MAX_WIDTH, BAR_HEIGHT)];
    [self.view addSubview:self.studyProgressBar];
    [self drawProgressBar];
    
    return self;
    
}

//- (id)initWithDeckOld:(NSMutableArray *)inputDeck {
//
//    self = [super initWithNibName:nil bundle:nil];
//
//    inputDeckArray = inputDeck;
//
//    // Custom initialization
//    //    UIColor *backColor = [UIColor colorWithRed:(80.0 / 255.0) green:(80.0 / 255.0) blue:(130.0 / 255.0) alpha: 1];
//    //    self.view.backgroundColor = backColor;
//    UIImage *image = [UIImage imageNamed:@"Study Background.png"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
//
//    // Initially no cards active
//    totalCardCount = 0;
//    activeCardCount = 0;
//    correctCardCount = 0;
//    incorrectCardCount = 0;
//
//    [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15,25,100,100) cornerRadius:15];
//
//    //kanjiArray = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"零", @"江", @"里", @"菜", @"駒"];
//
////    UILabel *incorrectDescLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height - 20, 80, 15)];
////    incorrectDescLabel.text = [NSString stringWithFormat:@"Incorrect"];
////    incorrectDescLabel.textAlignment = NSTextAlignmentCenter;
////    myColor = [UIColor colorWithRed:(235.0 / 255.0) green:(10.0 / 255.0) blue:(65.0 / 255.0) alpha: 1];
////    [incorrectDescLabel setTextColor:myColor];
////    [incorrectDescLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 15.0f]];
////    [self.view addSubview:incorrectDescLabel];
////
////    incorrectLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height - 48, 80, 25)];
////    incorrectLabel.text = [NSString stringWithFormat:@"%d", incorrectCardCount];
////    incorrectLabel.textAlignment = NSTextAlignmentCenter;
////    myColor = [UIColor colorWithRed:(235.0 / 255.0) green:(10.0 / 255.0) blue:(65.0 / 255.0) alpha: 1];
////    [incorrectLabel setTextColor:myColor];
////    [incorrectLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 30.0f]];
////    [self.view addSubview:incorrectLabel];
////
////    UILabel *correctDescLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 20, [UIScreen mainScreen].bounds.size.height - 20, 80, 15)];
////    correctDescLabel.text = [NSString stringWithFormat:@"Correct"];
////    correctDescLabel.textAlignment = NSTextAlignmentCenter;
////    myColor = [UIColor colorWithRed:(200.0 / 255.0) green:(200.0 / 255.0) blue:(200.0 / 255.0) alpha: 1];
////    [correctDescLabel setTextColor:myColor];
////    [correctDescLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 15.0f]];
////    [self.view addSubview:correctDescLabel];
////
////    correctLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 20, [UIScreen mainScreen].bounds.size.height - 48, 80, 25)];
////    correctLabel.text = [NSString stringWithFormat:@"%d", correctCardCount];
////    correctLabel.textAlignment = NSTextAlignmentCenter;
////    myColor = [UIColor colorWithRed:(200.0 / 255.0) green:(200.0 / 255.0) blue:(200.0 / 255.0) alpha: 1];
////    [correctLabel setTextColor:myColor];
////    [correctLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 25.0f]];
////    [self.view addSubview:correctLabel];
//
//    UIColor *activeCountColor = [UIColor colorWithRed:(160.0 / 255.0) green:(8.0 / 255.0) blue:(40.0 / 255.0) alpha: 1];
//
//    activeCardCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 22, 40, 25)];
//    activeCardCountLabel.text = [NSString stringWithFormat:@"%d", activeCardCount];
//    activeCardCountLabel.textAlignment = NSTextAlignmentCenter;
//    [activeCardCountLabel setTextColor:activeCountColor];
//    [activeCardCountLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 25.0f]];
//    [self.view addSubview:activeCardCountLabel];
//
//    studyProgressBar = [[UIImageView alloc] initWithFrame:CGRectMake(BAR_OFFSET,SCREEN_HEIGHT-37,BAR_WIDTH,BAR_HEIGHT)];
//    [self.view addSubview:studyProgressBar];
//    [self drawProgressBar];
//
//    return self;
//
//}


- (void)drawCardForChar:(Character*)c {
    
    Card *cardView = [[Card alloc] initCard:c fresh:NO];
    
    cardView.backgroundColor = ACTIVE_CARD_COLOUR;
    cardView.layer.borderColor = BORDER_COLOUR;
    cardView.layer.borderWidth = BORDER_WIDTH;
    cardView.layer.cornerRadius = CORNER_RADIUS;
    cardView.layer.masksToBounds = YES;
    
    [self.view addSubview:cardView];
    [visibleCards addObject:cardView];
    
    //cardView.layer.zPosition = -1;
    [self.view sendSubviewToBack:cardView];
}

- (void)shuffleCard:(Card*)cardView {
    NSLog(@"[StudyView] Shuffling card.");
    
    // Calc new position for card
    
    float low_bound = 2;
    float range = 10;

    int newPos = arc4random_uniform(range) + low_bound;

    if (newPos > [charsToStudy count] - 1) {
        newPos = (int)[charsToStudy count] - 1;
    }
    
    NSLog(@"[StudyView] Shuffling card to position %d of %d.",newPos,(int)[charsToStudy count]-1);
    
    NSLog(@"[StudyView] DEBUG. %d active cards, %lu cards in Deck:",activeCardCount,(unsigned long)[charsToStudy count]);
    
    // CAREFUL: Removing a character will remove all instances of that kanji!
    [charsToStudy removeObject:cardView.c];
    [charsToStudy insertObject:cardView.c atIndex:newPos];
    
    if ([charsToStudy count] > maxAllowedVisibleCards) {
        [visibleCards removeObject:cardView];
        [cardView removeFromSuperview];
    }
    
    // Print out all cards in deck
    for (int i = 0; i < [charsToStudy count]; i++) {
        Character *tempChar = [charsToStudy objectAtIndex:i];
        NSLog(@"[StudyView] Card at position %d: %@",i,tempChar.literal);
    }
    
    [self maintainDeck];
}

- (void)moveCardToBack:(Card*)cardView {
    NSLog(@"[StudyView] Moving card to back of deck.");
    NSLog(@"[StudyView] Shuffling card to position %d of %d.",(int)[charsToStudy count]-1,(int)[charsToStudy count]-1);
    
    NSLog(@"[StudyView] DEBUG. %d active cards, %lu cards in Deck:",activeCardCount,(unsigned long)[charsToStudy count]);
    
    // CAREFUL: Removing a character will remove all instances of that kanji!
    [charsToStudy removeObject:cardView.c];
    [charsToStudy insertObject:cardView.c atIndex:[charsToStudy count]];
    
    if ([charsToStudy count] > maxAllowedVisibleCards) {
        [visibleCards removeObject:cardView];
        [cardView removeFromSuperview];
    }
    
    // Print out all cards in deck
    for (int i = 0; i < [charsToStudy count]; i++) {
        Character *tempChar = [charsToStudy objectAtIndex:i];
        NSLog(@"[StudyView] Card at position %d: %@",i,tempChar.literal);
    }
    
    [self maintainDeck];
}

- (void)moveBackCardToFront {
    
    // Get id of back card
    Character *backChar = [charsToStudy lastObject];
    Card *backCard;
    
    // Try to find back card in currently visible cards
    for (int i = 0; i < [visibleCards count]; i++) {
        if ([charsToStudy objectAtIndex:i] == backChar) {
            backCard = [visibleCards objectAtIndex:i];
        }
    }
    
    // If not found (if not visible), draw a new one and locate within the visible cards
    if (backCard == nil) {
        [self drawCardForChar:backChar];
        
        for (int i = 0; i < [visibleCards count]; i++) {
            if ([visibleCards objectAtIndex:i] == backCard) {
                backCard = [visibleCards objectAtIndex:i];
            }
        }
    }
    
    // Move card to the front of the visible cards
    [visibleCards removeObject:backCard];
    [visibleCards insertObject:backCard atIndex:0];
    
    // Remove and insert character at front of deck
    [charsToStudy removeObject:backChar];
    [charsToStudy insertObject:backChar atIndex:0];
    
    // Animate the back card
    [UIView animateWithDuration:0.25f
                          delay:0
                        options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                     animations:^{[backCard setCenter:CGPointMake(-137, backCard.frame.size.height/2 + 55)]; }
                     completion:^(BOOL fin) { [self.view bringSubviewToFront:backCard];
                         
        [UIView animateWithDuration:0.2f
                              delay:0
                            options:(UIViewAnimationOptions) UIViewAnimationCurveEaseInOut
                         animations:^{[backCard setCenter:CGPointMake(160, backCard.frame.size.height/2 + 55)]; }
                         completion:^(BOOL fin) { }  ]; }  ];
    
    [self maintainDeck];

}

- (void)dismissTopCard:(Card*)cardView {
    
    // Remove both from deck array, and from array of visible cards.
    [charsToStudy removeObject:cardView.c];
    [visibleCards removeObject:cardView];
    
    // Remove view.
    [cardView removeFromSuperview];
    
    // Print out all cards in deck
    for (int i = 0; i < [charsToStudy count]; i++) {
        Character *tempChar = [charsToStudy objectAtIndex:i];
        NSLog(@"[StudyView] Card at position %d: %@",i,tempChar.literal);
    }
    
    [self maintainDeck];
}

- (void)maintainDeck {
    
    // NOTE:
    // charsToStudy tracks all CHARACTERS
    // visibleCards tracks top ~3 CARDS
    
    // Deal with case that there are more cards visible than permitted (otherwise could build up)
    if ([visibleCards count] > maxAllowedVisibleCards) {
        Card *cardView = [visibleCards objectAtIndex:[visibleCards count]-1]; // Remove the last card
        [visibleCards removeObject:cardView];
        [cardView removeFromSuperview];
    }
    
    if ((activeCardCount > 1) && ([visibleCards count] < maxAllowedVisibleCards)) {
        while (([visibleCards count] < activeCardCount) && ([visibleCards count] < maxAllowedVisibleCards)) {
            
            Character *nextChar = [charsToStudy objectAtIndex:[visibleCards count]];
            
            NSLog(@"[StudyView] Drawing card: %@",nextChar.literal);
            [self drawCardForChar:nextChar]; // Draw the card at the next deck position
        }
        
        // Always bring the top card to the front afterwards.
        Card *cardView = [visibleCards objectAtIndex:0];
        [self.view bringSubviewToFront:cardView];
    }
    
//    [self.view sendSubviewToBack:deckEmptyLabel];
//    [self.view sendSubviewToBack:keepStudyingButton];
    
    activeCardCountLabel.text = [NSString stringWithFormat:@"%d", activeCardCount];
    
    NSLog(@"[StudyView] Deck maintenance complete. %lu visible cards.", (unsigned long)[visibleCards count]);
    NSLog(@"[StudyView] %d active cards",activeCardCount);
}

- (void)handleCorrectCard:(Card*)cardView willExitDeck:(BOOL)willExitDeck {
    
    if (willExitDeck) {
        
        // Only track perfectly remembered cards.
        if (cardView.repQuality == 5) {
            correctCardCount++;
        }
        
        activeCardCount--;
        activeCardCountLabel.text = [NSString stringWithFormat:@"%d", activeCardCount];
        
        correctRatio = (float)correctCardCount/totalCardCount;
        studiedRatio = (float)(totalCardCount - activeCardCount)/totalCardCount;
        
        // Redraw study progress bar with new study stats
        [self animateProgressBar];

        [self dismissTopCard:cardView];
        
    } else {
        
        NSLog(@"[StudyView] CORRECT card shuffle. Kanji: %@ Score: %d",cardView.c.literal,(cardView.tempStudyDetails.numCorrect.intValue - cardView.tempStudyDetails.numIncorrect.intValue));
        
        [self shuffleCard:cardView];
        
    }

}

- (void)handleIncorrectCard:(Card*)cardView {
    
    NSLog(@"[StudyView] INCORRECT card shuffle. Kanji: %@ Score: %d",cardView.c.literal,(cardView.tempStudyDetails.numCorrect.intValue - cardView.tempStudyDetails.numIncorrect.intValue));
    
    [self shuffleCard:cardView];

}

- (int)getActiveCardCount {
    return activeCardCount;
}

- (void)decActiveCardCount {
    activeCardCount--;
}

- (void)drawProgressBar {
    
    //
    // 1. Draw bar outline
    //
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, BAR_MAX_WIDTH, BAR_HEIGHT) cornerRadius:BAR_HEIGHT/2];
    
    CAShapeLayer *barOutlineLayer = [[CAShapeLayer alloc] init];
    barOutlineLayer.strokeColor = [[UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 0.7] CGColor];
    barOutlineLayer.lineWidth = 2.0;
    barOutlineLayer.fillColor = nil;//[[UIColor whiteColor] CGColor];//[[UIColor colorWithRed:(25.0 / 255.0) green:(95.0 / 255.0) blue:(235.0 / 255.0) alpha: 1] CGColor];
    barOutlineLayer.lineJoin = kCALineJoinBevel;
    barOutlineLayer.path = path.CGPath;
    
    [self.studyProgressBar.layer addSublayer:barOutlineLayer];
    
    //
    // 2. Draw study progress bar
    //
    self.progressBar = [[UIImageView alloc] initWithFrame:CGRectMake(BAR_OFFSET + 2, SCREEN_HEIGHT - 35, BAR_HEIGHT - 4, BAR_HEIGHT - 4)];
    self.progressBar.backgroundColor = [UIColor colorWithRed:(235.0 / 255.0) green:(10.0 / 255.0) blue:(55.0 / 255.0) alpha: 0.7];
    self.progressBar.layer.cornerRadius = self.progressBar.frame.size.height/2;
    [self.view addSubview:self.progressBar];
    
    //
    // 3. Draw correct progress bar
    //
    self.correctBar = [[UIImageView alloc] initWithFrame:CGRectMake(BAR_OFFSET + 2, SCREEN_HEIGHT - 35, BAR_HEIGHT - 4, BAR_HEIGHT - 4)];
    self.correctBar.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha: 0.7];
    self.correctBar.layer.cornerRadius = self.correctBar.frame.size.height/2;
    [self.view addSubview:self.correctBar];
    NSLog(@"CORRECTBAR: %f, %f, %f, %f", self.correctBar.frame.origin.x, self.correctBar.frame.origin.y, self.correctBar.frame.size.width, self.correctBar.frame.size.height);
}

- (void)animateProgressBar {
    
    // TODO: Animate the endcircle appearing!
    
    //
    // 1. Animate study progress bar
    //
    int progressBarWidth = studiedRatio*(BAR_MAX_WIDTH-4);
    if (studiedRatio*(BAR_MAX_WIDTH-4) < BAR_HEIGHT) {
        progressBarWidth = BAR_HEIGHT-4;
    }
    
    CGRect newProgressBarFrame = self.progressBar.frame;
    newProgressBarFrame.size.width = progressBarWidth;
//    newProgressBarFrame.origin.x = BAR_OFFSET + 2;
    
    POPBasicAnimation *animProgessBounds = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animProgessBounds.toValue = [NSValue valueWithCGRect:newProgressBarFrame];
    animProgessBounds.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.progressBar pop_addAnimation:animProgessBounds forKey:@"animProgessBounds"];
    
    POPBasicAnimation *animProgessPos = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animProgessPos.toValue = [NSValue valueWithCGPoint:CGPointMake(BAR_OFFSET + 2 + progressBarWidth/2, BAR_OFFSET + 2 + progressBarWidth/2)];
    animProgessPos.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.progressBar pop_addAnimation:animProgessPos forKey:@"animProgessPos"];

    //
    // 2. Animate correct progress bar
    //
    int correctBarWidth = correctRatio*(BAR_MAX_WIDTH-4);
    if (correctRatio*(BAR_MAX_WIDTH-4) < BAR_HEIGHT) {
        correctBarWidth = BAR_HEIGHT-4;
    }
    
    CGRect newCorrectBarFrame = self.correctBar.frame;
    newCorrectBarFrame.size.width = correctBarWidth;
//    newCorrectBarFrame.origin.x = BAR_OFFSET + 2;
    
    POPBasicAnimation *animCorrectBounds = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBounds];
    animCorrectBounds.toValue = [NSValue valueWithCGRect:newCorrectBarFrame];
    animCorrectBounds.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.correctBar pop_addAnimation:animCorrectBounds forKey:@"animCorrectBounds"];
//    NSLog(@"CORRECTBAR: %f, %f, %f, %f", self.correctBar.frame.origin.x, self.correctBar.frame.origin.y, self.correctBar.frame.size.width, self.correctBar.frame.size.height);
    
    POPBasicAnimation *animCorrectPos = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    animCorrectPos.toValue = [NSValue valueWithCGPoint:CGPointMake(BAR_OFFSET + 2 + correctBarWidth/2, BAR_OFFSET + 2 + correctBarWidth/2)];
    animCorrectPos.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.correctBar pop_addAnimation:animCorrectPos forKey:@"animCorrectPos"];
//    NSLog(@"CORRECTBAR: %f, %f, %f, %f", self.correctBar.frame.origin.x, self.correctBar.frame.origin.y, self.correctBar.frame.size.width, self.correctBar.frame.size.height);
}

- (void)prepDeck {
    
    // Initially no cards active
//    totalCardCount = 0;
//    activeCardCount = 0;
    correctCardCount = 0;
    incorrectCardCount = 0;
    
    nextCardNo = 1;
    
    charsToStudy = [[NSMutableArray alloc] initWithArray:[deckStudying.cardsInDeck allObjects]];
    visibleCards = [[NSMutableArray alloc] init];
    
    totalCardCount = (int)[deckStudying.cardsInDeck count];
    activeCardCount = (int)[deckStudying.cardsInDeck count];
    
    NSLog(@"[StudyView] Initially %d cards active.",activeCardCount);
    
    [self maintainDeck];
    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    UIColor *myColor = [UIColor colorWithRed:(80.0 / 255.0) green:(80.0 / 255.0) blue:(130.0 / 255.0) alpha: 1];
//    self.view.backgroundColor = myColor;
//}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewWillAppear:(BOOL)animated {
    
    // Prepare the deck of cards for display
    [self prepDeck];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

-(IBAction)StopStudy:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)AddCard:(id)sender {
    
    Card *cardView = [[Card alloc] initCard:[charsToStudy objectAtIndex:nextCardNo] fresh:YES];
    
    cardView.backgroundColor = ACTIVE_CARD_COLOUR;
    cardView.layer.borderColor = BORDER_COLOUR;
    cardView.layer.borderWidth = BORDER_WIDTH;
    cardView.layer.cornerRadius = CORNER_RADIUS;
    cardView.layer.masksToBounds = YES;
    
    [self.view addSubview:cardView];
    
    totalCardCount++;
    activeCardCount++;
    activeCardCountLabel.text = [NSString stringWithFormat:@"%d", activeCardCount];
    
    [charsToStudy insertObject:[NSNumber numberWithInt:nextCardNo] atIndex:0]; // Track the card number in the deck (place on the top of the deck)
    [visibleCards insertObject:cardView atIndex:0];
    
    [self maintainDeck]; // Perform maintenance on visible cards
    
    nextCardNo++;
    
}

@end
