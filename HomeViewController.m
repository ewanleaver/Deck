//
//  MenuViewController.m
//  deck
//
//  Created by Ewan Leaver on 08/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "HomeViewController.h"
#import "ContainerViewController.h"
#import "StudyViewController.h"
#import "KanjiListViewController.h"
#import "HomePanel.h"
#import "Bubble.h"
#import "StudyButton.h"

#import "Home.h"
#import "Deck.h"
#import "Character.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize managedObjectContext;

@synthesize home;
@synthesize myDecks;
@synthesize myDecksArray;

@synthesize scrollView;
@synthesize pageControl;
@synthesize studyButton;

bool pageControlBeingUsed;
bool studyComplete;

NSArray *panels;

NSMutableArray *decksForPages;

int numPanels;

-(void)StartStudy:(id)sender {
    
    // Initiate StudyViewController with the appropriate deck to study
    StudyViewController *studyView = [[StudyViewController alloc] initWithDeck:[myDecksArray objectAtIndex:pageControl.currentPage]];
    
    ContainerViewController* rootView = (ContainerViewController*)self.parentViewController;
    
    if ([rootView.delegate respondsToSelector:@selector (containerViewController:didSelectViewController:)]) {
        [rootView.delegate containerViewController:rootView didSelectViewController:studyView];
    }

    //[(ContainerViewController*)self.parentViewController setSelectedViewController:studyView];
    
}

//-(void)StartStudy:(id)sender {
//    
//    // Get current page
//    //    CGFloat pageWidth = self.scrollView.frame.size.width;
//    //    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//    
//    // Initiate StudyViewController with the appropriate deck to study
//    StudyViewController *BackgroundView = [[StudyViewController alloc] initWithDeck:[myDecksArray objectAtIndex:pageControl.currentPage]];
//    [self presentViewController:BackgroundView animated:YES completion:nil];
//    
//    //        [self performSegueWithIdentifier:@"showStudyView" sender:self];
//    
//    //        UIStoryboard *storyboard = self.storyboard;
//    //        StudyViewController *controller = [storyboard
//    //                                        instantiateViewControllerWithIdentifier:@"studyViewController"];
//    //        [self.navigationController pushViewController:controller animated:YES];
//    
//}

- (void)studyButtonTouched:(id)sender {
    if (!studyComplete) {
        [UIView animateWithDuration:0.1 animations:^{
            [studyButton.layer setBackgroundColor:[UIColor colorWithRed:(20.0 / 255.0) green:(150.0 / 255.0) blue:(80.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
}

- (void)studyButtonReleased:(id)sender {
    if (!studyComplete) {
        [UIView animateWithDuration:0.1 animations:^{
            [studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 84, 320, 340)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 531, 80, 37)];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(255.0/255.0) green:(15.0/255.0) blue:(40.0/255.0) alpha:1.0];
    [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    studyButton = [[StudyButton alloc] initWithFrame:CGRectMake(100, 450, 120, 42)];
    [studyButton addTarget:self action:@selector(studyButtonTouched:) forControlEvents:UIControlEventTouchDown];
    [studyButton addTarget:self action:@selector(studyButtonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [studyButton addTarget:self action:@selector(studyButtonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    [studyButton addTarget:self action:@selector(StartStudy:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:studyButton];
    
    [self preparePanels];
    //[self prepareSubviews];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * numPanels, self.scrollView.frame.size.height);
    
    pageControlBeingUsed = NO;
}

- (void)preparePanels {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Home" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // SHOULD retrieve the home object
    NSError *error;
    NSLog(@"Number of home objects... %lu",(unsigned long)[[managedObjectContext executeFetchRequest:fetchRequest error:&error] count]);
    self.home = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] firstObject];
    self.myDecks = home.availableDecks; // Points to NSSet of decks
    
    myDecksArray = [myDecks sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO]]];
    
    for (int i = 0; i < [myDecks count]; i++) {
        
        HomePanel *panel;
        
        Deck *d = [myDecksArray objectAtIndex:i];
        NSLog(@"Deck %i name: %@, %@ cards.",i,d.name,d.numToStudy);
        
//        NSArray *cardsInDeck = [d.cardsInDeck allObjects];
//        NSLog(@"%lu cards in deck, %d to Study",(unsigned long)[cardsInDeck count],[d.numToStudy intValue]);
        
        panel = [[HomePanel alloc] initWithFrameAndDeck:CGRectMake(self.scrollView.frame.size.width * i, 0, 320, 240) deck:d];
        [[panel titleLabel] setText:d.name];
        [[panel cardLabel] setText:[NSString stringWithFormat:@"%@",d.numToStudy]];
        
        [self.scrollView addSubview:panel];

    }
    
    panels = [scrollView subviews];
    numPanels = (int)[panels count];
    
    if ([myDecks count] != [panels count]) {
        NSLog(@"WARNING! There has been a terrible terrible mistake somewhere.");
    }
    
    if ([[panels objectAtIndex:0] toStudyCount] == 0) {
        studyComplete = YES;
        studyButton.userInteractionEnabled = NO;
    } else {
        studyComplete = NO;
        studyButton.userInteractionEnabled = YES;
    }
    
}

- (void)prepareSubviews {
    
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
            
            id delegate = [[UIApplication sharedApplication] delegate];
            self.managedObjectContext = [delegate managedObjectContext];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Character" inManagedObjectContext:managedObjectContext];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"jlpt == %@", @"3"]];
            [fetchRequest setEntity:entity];
            
            NSError *error;
            NSMutableArray *results = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            
            Character *ch;
            
            for (int k=0; k<[results count]; k++) {
                ch = [results objectAtIndex:k];
                
                [deckArray addObject:[NSNumber numberWithInt:ch.id_num.intValue]];
            }
            numToStudy = 56;
            
        } else if (i == 2) {
            title = @"JLPT N2";
            bubbleColor = [UIColor colorWithRed:(255.0 / 255.0) green:(139.0 / 255.0) blue:(88.0 / 255.0) alpha: 1];
            
            id delegate = [[UIApplication sharedApplication] delegate];
            self.managedObjectContext = [delegate managedObjectContext];
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
                                           entityForName:@"Character" inManagedObjectContext:managedObjectContext];
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"jlpt == %@", @"2"]];
            [fetchRequest setEntity:entity];
            
            NSError *error;
            NSMutableArray *results = [NSMutableArray arrayWithArray:[managedObjectContext executeFetchRequest:fetchRequest error:&error]];
            
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
        
        panel = [[HomePanel alloc] initWithFrameAndColour:CGRectMake(self.scrollView.frame.size.width * i, 0, 320, 240) colour:bubbleColor numToStudy:numToStudy numTotal:cardsTotal];
        [[panel titleLabel] setText:title];
//        [panel setCardCount:cardsTotal];
//        [panel setToStudyCount:numToStudy];
        [[panel cardLabel] setText:[NSString stringWithFormat:@"%d",numToStudy]];
        
        //[subview addSubview:panel];
        
        [self.scrollView addSubview:panel];
        
    }
    
    panels = [scrollView subviews];
    
    if ([decksForPages count] != [panels count]) {
        NSLog(@"WARNING! Not enough decks for the number of present pages.");
    }
    
    if ([[panels objectAtIndex:0] toStudyCount] == 0) {
        studyComplete = YES;
        studyButton.userInteractionEnabled = NO;
    } else {
        studyComplete = NO;
        studyButton.userInteractionEnabled = YES;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    // YAY. Now page control correctly displays available decks.
    self.pageControl.numberOfPages = numPanels;
    
    // Animate a comment showing praise
    if ([[panels objectAtIndex:0] toStudyCount] == 0) {
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        if ([[panels objectAtIndex:page] toStudyCount] == 0) {
            [UIView animateWithDuration:0.2 animations:^{
                [studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.2].CGColor];
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
    pageControl.currentPage = page;
    
    if (page < 0) {
        page = 0;
    } else if (page >= numPanels) {
        page = numPanels - 1;
    }
    
    if ([[panels objectAtIndex:page] toStudyCount] == 0) {
        studyComplete = YES;
        studyButton.userInteractionEnabled = NO;
    } else {
        studyComplete = NO;
        studyButton.userInteractionEnabled = YES;
    }
    
    if (studyComplete) {
        [UIView animateWithDuration:0.2 animations:^{
            [studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 0.2].CGColor];
        } completion:NULL];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [studyButton.layer setBackgroundColor:[UIColor colorWithRed:(35.0 / 255.0) green:(220.0 / 255.0) blue:(120.0 / 255.0) alpha: 1.0].CGColor];
        } completion:NULL];
    }
    
    // Fade out any comments
    if ([[panels objectAtIndex:page] toStudyCount] == 0) {
        [[panels objectAtIndex:page] hideComment];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    if (page < 0) {
        page = 0;
    } else if (page > numPanels) {
        page = numPanels - 1;
    }
    
    // Animate a comment showing praise
    if ([[panels objectAtIndex:page] toStudyCount] == 0) {
        [[panels objectAtIndex:page] showComment];
    }
}

- (void)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlBeingUsed = YES; // To prevent flashing
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

@end
