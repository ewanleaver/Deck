//
//  Background.h
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Character.h"
#import "Card.h"

@interface StudyViewController : UIViewController

- (IBAction)StopStudy:(id)sender;
- (IBAction)AddCard:(id)sender;
//- (IBAction)AddTen:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *deckEmptyLabel;
@property (weak, nonatomic) IBOutlet UIButton *keepStudyingButton;

@property (nonatomic) Deck* deckStudying;
@property (nonatomic) int nextCardNo;

@property UIImageView *studyProgressBar;

- (id) initWithDeck: (NSMutableArray *)inputDeck;

- (int) getActiveCardCount;
- (void) decActiveCardCount;

- (void) handleCorrectCard: (Card*)cardView willExitDeck:(BOOL)willExitDeck;
- (void) handleIncorrectCard: (Card*)cardView;

- (void) dismissTopCard: (Card*)cardView;
- (void) shuffleCard: (Card*)cardView;
- (void) moveCardToBack: (Card*)cardView;
- (void) moveBackCardToFront;
- (void) maintainDeck;

@end
