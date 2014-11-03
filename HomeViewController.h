//
//  MenuViewController.h
//  deck
//
//  Created by Ewan Leaver on 08/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"
#import "RoundedButton.h"

@interface HomeViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic,strong) Home* home;
@property (nonatomic,strong) NSSet* myDecks;
@property (nonatomic,strong) NSArray* myDecksArray;

@property (nonatomic, retain) UIView *titleBar;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) RoundedButton *studyButton;

- (void)changePage;
- (void)StartStudy:(id)sender;
- (void)studyButtonTouched:(id)sender;
- (void)studyButtonReleased:(id)sender;

@end
