//
//  MenuViewController.m
//  deck
//
//  Created by Ewan Leaver on 08/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "HomeViewController.h"
#import "StudyViewController.h"
#import "KanjiListViewController.h"
#import "HomePanel.h"
#import "Bubble.h"
#import "StudyButton.h"

#import "Home.h"
#import "Deck.h"
#import "Character.h"

@interface HomeViewController ()

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSArray *panels;
@property (nonatomic, strong) NSMutableArray *decksForPages;
@property (nonatomic, assign) int numPanels;

@property (nonatomic, assign) bool pageControlBeingUsed;
@property (nonatomic, assign) bool studyComplete;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.delegate managedObjectContext];
    
    [self preparePanels];
    //[self prepareSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * self.numPanels, self.scrollView.frame.size.height);
    
    self.pageControlBeingUsed = NO;
}

- (void)preparePanels {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Home" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // SHOULD retrieve the home object
    NSError *error;
    NSLog(@"Number of home objects... %lu",(unsigned long)[[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] count]);
    self.home = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] firstObject];
    self.myDecks = self.home.availableDecks; // Points to NSSet of decks (property of Deck Entity)
    
    // Sort decks by name and store in NSArray
    self.myDecksArray = [self.myDecks sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]]];
    
    for (int i = 0; i < [self.myDecks count]; i++) {
        HomePanel *panel;
        
        Deck *d = [self.myDecksArray objectAtIndex:i];
        NSLog(@"Deck %i name: %@, %@ cards.",i,d.name,d.numToStudy);
        
//        NSArray *cardsInDeck = [d.cardsInDeck allObjects];
//        NSLog(@"%lu cards in deck, %d to Study",(unsigned long)[cardsInDeck count],[d.numToStudy intValue]);
        
        panel = [[HomePanel alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, 240) deck:d];
        [[panel titleLabel] setText:d.name];
        [[panel totalCountLabel] setText:[NSString stringWithFormat:@"%@",d.numToStudy]];
        
        [self.scrollView addSubview:panel];
    }
    
    self.panels = [self.scrollView subviews];
    self.numPanels = (int)[self.panels count];
    
    if ([self.myDecks count] != [self.panels count]) {
        NSLog(@"WARNING! Number of decks does not match number of panels.");
    }
    
    // Check if intial deck has no cards left to study
    if ([[self.panels objectAtIndex:0] unstudiedCount] == 0) {
        self.studyComplete = YES;
        self.studyButton.userInteractionEnabled = NO;
    } else {
        self.studyComplete = NO;
        self.studyButton.userInteractionEnabled = YES;
    }
}

- (void)prepareSubviews {
    // THIS METHOD IS OLD AND NOT USED ANYMORE
    // SEE preparePanels
    self.decksForPages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.numPanels; i++) {
        
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        //UIView *subview = [[UIView alloc] initWithFrame:frame];
        //subview.backgroundColor = [colors objectAtIndex:i];
        
        NSString *title;
        int numToStudy = 0;
        int cardsTotal = 0;
        UIColor *bubbleColor;
        
        HomePanel *panel;
        
        // Colour storage
//        [UIColor colorWithRed:(85.0 / 255.0) green:(150.0 / 255.0) blue:(255.0 / 255.0) alpha: 1];
//        [UIColor colorWithRed:(85.0 / 255.0) green:(230.0 / 255.0) blue:(155.0 / 255.0) alpha: 1];
//        [UIColor colorWithRed:(255.0 / 255.0) green:(160.0 / 255.0) blue:(100.0 / 255.0) alpha: 1];
//        [UIColor colorWithRed:(200.0 / 255.0) green:(140.0 / 255.0) blue:(255.0 / 255.0) alpha: 1];
        
        // Create deck for current page:
        NSMutableArray *deckArray = [[NSMutableArray alloc] init];
        
        if (i == 0) {
            title = @"Review";
            bubbleColor = [UIColor colorWithRed:65/255. green:142/255. blue:255/255. alpha:1.0];

            for (int k=0; k<0; k++) {
                [deckArray addObject:[NSNumber numberWithInt:k]];
            }
            numToStudy = 0;

        } else if (i == 1) {
            title = @"JLPT N3";
            bubbleColor = [UIColor colorWithRed:(100.0 / 255.0) green:(240.0 / 255.0) blue:(120.0 / 255.0) alpha: 1.0];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Character" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"jlpt == %@", @"3"]];
            [fetchRequest setEntity:entity];
            
            NSError *error;
            NSMutableArray *results = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            
            Character *ch;
            
            for (int k=0; k<[results count]; k++) {
                ch = [results objectAtIndex:k];
                
                [deckArray addObject:[NSNumber numberWithInt:ch.id_num.intValue]];
            }
            numToStudy = 56;
            
        } else if (i == 2) {
            title = @"JLPT N2";
            bubbleColor = [UIColor colorWithRed:(255.0 / 255.0) green:(139.0 / 255.0) blue:(88.0 / 255.0) alpha: 1];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Character" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"jlpt == %@", @"2"]];
            [fetchRequest setEntity:entity];
            
            NSError *error;
            NSMutableArray *results = [NSMutableArray arrayWithArray:[self.managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            
            Character *ch;
            
            for (int k=0; k<[results count]; k++) {
                ch = [results objectAtIndex:k];
                
                [deckArray addObject:[NSNumber numberWithInt:ch.id_num.intValue]];
            }
            numToStudy = 237;
            
        } else if (i == 3) {
            title = @"Hardcore Kanji";
            bubbleColor = [UIColor colorWithRed:(255.0 / 255.0) green:(83.0 / 255.0) blue:(91.0 / 255.0) alpha: 1];

            for (int k=1000; k<1005; k++) {
                [deckArray addObject:[NSNumber numberWithInt:k]];
            }
            numToStudy = 5;
            
//            for (int k=1000; k<1056; k++) {
//                [deckArray addObject:[NSNumber numberWithInt:k]];
//            }
//            numToStudy = 56;
            
        } else {
            title = @"Null";
            bubbleColor = [UIColor blackColor];
            
            for (int k=0; k<1; k++) {
                [deckArray addObject:[NSNumber numberWithInt:k]];
            }
            numToStudy = 1;
        }
        
        // Place deck at appropriate page
        [self.decksForPages insertObject:deckArray atIndex:i];
        cardsTotal = (int)[deckArray count];
        NSLog(@"Deck %d: %d cards.",i,cardsTotal);
        
        panel = [[HomePanel alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width * i, 0, self.scrollView.frame.size.width, 240) colour:bubbleColor numUnstudied:numToStudy numTotal:cardsTotal];
        [[panel titleLabel] setText:title];
//        [panel setCardCount:cardsTotal];
//        [panel setToStudyCount:numToStudy];
        [[panel totalCountLabel] setText:[NSString stringWithFormat:@"%d",numToStudy]];
        
        //[subview addSubview:panel];
        
        [self.scrollView addSubview:panel];
        
    }
    
    self.panels = [self.scrollView subviews];
    
    if ([self.decksForPages count] != [self.panels count]) {
        NSLog(@"WARNING! Not enough decks for the number of present pages.");
    }
    
    if ([[self.panels objectAtIndex:0] unstudiedCount] == 0) {
        self.studyComplete = YES;
        self.studyButton.userInteractionEnabled = NO;
    } else {
        self.studyComplete = NO;
        self.studyButton.userInteractionEnabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // YAY. Now page control correctly displays available decks.
    self.pageControl.numberOfPages = self.numPanels;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
//    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(3, 3)];
    scaleAnimation.springBounciness = 20.f;

    HomePanel *currentView = self.scrollView.subviews[self.pageControl.currentPage];
    [currentView.bubble pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    
    // Animate a comment showing praise
    if ([[self.panels objectAtIndex:0] unstudiedCount] == 0) {
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if ([[self.panels objectAtIndex:page] unstudiedCount] == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.2].CGColor];
            } completion:NULL];
            
            [NSThread sleepForTimeInterval:0.1f];
            [[self.panels objectAtIndex:page] showComment];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    if (page < 0) {
        page = 0;
    } else if (page >= self.numPanels) {
        page = self.numPanels - 1;
    }
    
    if ([[self.panels objectAtIndex:page] unstudiedCount] == 0) {
        self.studyComplete = YES;
        self.studyButton.userInteractionEnabled = NO;
    } else {
        self.studyComplete = NO;
        self.studyButton.userInteractionEnabled = YES;
    }
    
    if (self.studyComplete) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.2].CGColor];
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
    
    // Fade out any comments
    if ([[self.panels objectAtIndex:page] unstudiedCount] == 0) {
        [[self.panels objectAtIndex:page] hideComment];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageControlBeingUsed = NO;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0) {
        page = 0;
    } else if (page > self.numPanels) {
        page = self.numPanels - 1;
    }
    
    // Animate a comment showing praise
    if ([[self.panels objectAtIndex:page] unstudiedCount] == 0) {
        [[self.panels objectAtIndex:page] showComment];
    }
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    self.pageControlBeingUsed = YES; // To prevent flashing
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

#pragma mark - IBActions

-(IBAction)StartStudy:(id)sender {
    
    // Get current page
    //CGFloat pageWidth = self.scrollView.frame.size.width;
    //int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    // Initiate StudyViewController with the appropriate deck to study
    StudyViewController *BackgroundView = [[StudyViewController alloc] initWithDeck:[self.myDecksArray objectAtIndex:self.pageControl.currentPage]];
    [self presentViewController:BackgroundView animated:YES completion:nil];
    
    //        [self performSegueWithIdentifier:@"showStudyView" sender:self];
    
    //        UIStoryboard *storyboard = self.storyboard;
    //        StudyViewController *controller = [storyboard
    //                                        instantiateViewControllerWithIdentifier:@"studyViewController"];
    //        [self.navigationController pushViewController:controller animated:YES];
    
}

- (IBAction)studyButtonTouch:(id)sender {
    if (!self.studyComplete) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(150.0 / 255.0) blue:(80.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
}

- (IBAction)studyButtonRelease:(id)sender {
    if (!self.studyComplete) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
}


@end
