//
//  Background.h
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface StudyViewController : UIViewController

- (IBAction)StopStudy:(id)sender;
- (IBAction)AddCard:(id)sender;
//- (IBAction)AddTen:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *deckEmptyLabel;
@property (weak, nonatomic) IBOutlet UIButton *keepStudyingButton;

@property (nonatomic) int nextCardNo;

@property UIImageView *studyProgressBar;

- (id) initWithDeck: (NSMutableArray *)inputDeck;

- (int) getActiveCardCount;
- (void) decActiveCardCount;

- (void) handleCorrectCard;
- (void) handleIncorrectCard;

- (void) dismissTopCard: (Card*)cardView;
- (void) shuffleCard: (Card*)cardView;
- (void) shuffleBackCard;
- (void) maintainDeck;

@end
