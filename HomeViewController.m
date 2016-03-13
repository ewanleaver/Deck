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

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HomeViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

// Want to keep a reference to the current transition context
@property (nonatomic, strong) id <UIViewControllerContextTransitioning> transitionContext;
// Used to determine whether the StudyViewController is being presented or is returning to home
@property (nonatomic, assign) BOOL isPresenting;

@property (nonatomic, assign) CGRect modalHiddenFrame;
@property (nonatomic, assign) CGRect modalPresentedFrame;

@property (nonatomic, assign) CGRect disappearingFromFrame;
@property (nonatomic, assign) CGRect disappearingToFrame;
@property (nonatomic, assign) CGRect appearingFromFrame;
@property (nonatomic, assign) CGRect appearingToFrame;

@end

@implementation HomeViewController

bool pageControlBeingUsed;
bool studyComplete;


// These are class variables?
// Consider making these private variables
NSArray *panels;
NSMutableArray *decksForPages;
int numPanels;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [self.delegate managedObjectContext];
    
    // Do any additional setup after loading the view from its nib.
    //[[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    
//    ListViewController *controller;// = (MasterViewController *)navigationController.topViewController;
//    controller.managedObjectContext = [delegate managedObjectContext];

    
    [self preparePanels];
    //[self prepareSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * numPanels, self.scrollView.frame.size.height);
    
    pageControlBeingUsed = NO;
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
    
    panels = [self.scrollView subviews];
    numPanels = (int)[panels count];
    
    if ([self.myDecks count] != [panels count]) {
        NSLog(@"WARNING! Number of decks does not match number of panels.");
    }
    
    // Check if intial deck has no cards left to study
    if ([[panels objectAtIndex:0] unstudiedCount] == 0) {
        studyComplete = YES;
        self.studyButton.userInteractionEnabled = NO;
    } else {
        studyComplete = NO;
        self.studyButton.userInteractionEnabled = YES;
    }
}

- (void)prepareSubviews {
    // THIS METHOD IS OLD AND NOT USED ANYMORE
    // SEE preparePanels
    decksForPages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < numPanels; i++) {
        
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
        [decksForPages insertObject:deckArray atIndex:i];
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
    
    panels = [self.scrollView subviews];
    
    if ([decksForPages count] != [panels count]) {
        NSLog(@"WARNING! Not enough decks for the number of present pages.");
    }
    
    if ([[panels objectAtIndex:0] unstudiedCount] == 0) {
        studyComplete = YES;
        self.studyButton.userInteractionEnabled = NO;
    } else {
        studyComplete = NO;
        self.studyButton.userInteractionEnabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    // YAY. Now page control correctly displays available decks.
    self.pageControl.numberOfPages = numPanels;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
//    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.7, 0.7)];
//    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(3, 3)];
    scaleAnimation.springBounciness = 20.f;

    HomePanel *currentView = self.scrollView.subviews[self.pageControl.currentPage];
    [currentView.bubble pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    
    // Animate a comment showing praise
    if ([[panels objectAtIndex:0] unstudiedCount] == 0) {
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if ([[panels objectAtIndex:page] unstudiedCount] == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.2].CGColor];
            } completion:NULL];
            
            [NSThread sleepForTimeInterval:0.1f];
            [[panels objectAtIndex:page] showComment];
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
    } else if (page >= numPanels) {
        page = numPanels - 1;
    }
    
    if ([[panels objectAtIndex:page] unstudiedCount] == 0) {
        studyComplete = YES;
        self.studyButton.userInteractionEnabled = NO;
    } else {
        studyComplete = NO;
        self.studyButton.userInteractionEnabled = YES;
    }
    
    if (studyComplete) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.2].CGColor];
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
    
    // Fade out any comments
    if ([[panels objectAtIndex:page] unstudiedCount] == 0) {
        [[panels objectAtIndex:page] hideComment];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0) {
        page = 0;
    } else if (page > numPanels) {
        page = numPanels - 1;
    }
    
    // Animate a comment showing praise
    if ([[panels objectAtIndex:page] unstudiedCount] == 0) {
        [[panels objectAtIndex:page] showComment];
    }
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES; // To prevent flashing
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

#pragma mark - IBActions

// Animate the pressing/depressing of the study button
- (IBAction)studyButtonTouch:(id)sender {
    if (!studyComplete) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(150.0 / 255.0) blue:(80.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
}

- (IBAction)studyButtonRelease:(id)sender {
    if (!studyComplete) {
        [UIView animateWithDuration:0.1 animations:^{
            [self.studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
}

-(IBAction)presentStudyView:(id)sender {
    
    // Initiate StudyViewController with the appropriate deck to study
    StudyViewController *studyViewController = [[StudyViewController alloc] initWithDeck:[self.myDecksArray objectAtIndex:self.pageControl.currentPage]];
    studyViewController.modalPresentationStyle = UIModalPresentationCustom;
    
    // Tell the modal that this ViewController is going to be its transitioningDelegate
    studyViewController.transitioningDelegate = self;
    self.isPresenting = YES;
    [self presentViewController:studyViewController animated:YES completion:^{
        self.isPresenting = NO;
    }];
    
    //        [self performSegueWithIdentifier:@"showStudyView" sender:self];
    
    //        UIStoryboard *storyboard = self.storyboard;
    //        StudyViewController *controller = [storyboard
    //                                        instantiateViewControllerWithIdentifier:@"studyViewController"];
    //        [self.navigationController pushViewController:controller animated:YES];
    
}

#pragma mark - UIViewControllerTransitioningDelegate methods 

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning methods

// This is used for percent driven interactive transitions, as well as for container controllers
// that have companion animations that might need to synchronise with the main animation.
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

// This is where we define the custom animation itself
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    
    // References to the from/toViews
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGFloat travelDistance = self.isPresenting ? -SCREEN_HEIGHT : SCREEN_HEIGHT;
    self.disappearingFromFrame = self.appearingToFrame = [UIScreen mainScreen].bounds;
    self.disappearingToFrame = CGRectOffset([UIScreen mainScreen].bounds, 0, travelDistance);
    self.appearingFromFrame = CGRectOffset([UIScreen mainScreen].bounds, 0, -travelDistance);
    
    self.modalPresentedFrame = [transitionContext containerView].bounds;
    //self.modalHiddenFrame = CGRectOffset(self.modalPresentedFrame, 0, SCREEN_HEIGHT);
    
    //toView.alpha = 0;
    
    UIView *modalView;
    UIView *homeView;
    CGRect modalDestinationFrame;
    CGRect homeDestinationFrame;
    
    if(self.isPresenting) {
        modalView = toView;
        modalDestinationFrame = self.appearingToFrame;
        // Never need to remove this, the animator will do it for us:
        // (But we do need to remember this when presenting, otherwise no modal view will appear)
        [[transitionContext containerView] addSubview:toView];
        toView.frame = self.appearingFromFrame;
        [toView layoutIfNeeded];
    } else {
        modalView = fromView;
        modalDestinationFrame = self.disappearingToFrame;
    }
    
    [self animateWithModalView:modalView destinationFrame:modalDestinationFrame];
}

- (void)animateWithModalView:(UIView *)view destinationFrame:(CGRect)destinationFrame {
    
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext] delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:0 animations:^{
        view.frame = destinationFrame;
        [view layoutIfNeeded];
    } completion:nil];
}

@end
