//
//  Background.h
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyViewController : UIViewController

- (IBAction)StopStudy:(id)sender;
- (IBAction)AddCard:(id)sender;

@property (nonatomic) int cardCount;

- (int) getCardsActive;
- (void) decCardsActive;

- (void) cardRight;
- (void) cardWrong;

- (NSString *) selectKanji:(int)index;

@end
