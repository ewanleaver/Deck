//
//  MenuViewController.h
//  deck
//
//  Created by Ewan Leaver on 08/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"
#import "StudyButton.h"

@interface HomeViewController : UIViewController

@property (nonatomic, strong) Home *home;
@property (nonatomic, strong) NSSet *myDecks;
@property (nonatomic, strong) NSArray *myDecksArray;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet StudyButton *studyButton;

- (IBAction)changePage;
- (IBAction)StartStudy:(id)sender;
- (IBAction)studyButtonTouch:(id)sender;
- (IBAction)studyButtonRelease:(id)sender;

@end
