//
//  CardViewController.m
//  deck
//
//  Created by Ewan Leaver on 7/4/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "CardViewController.h"
#import "Card.h"

@interface CardViewController ()

@end

@implementation CardViewController

@synthesize managedObjectContext;
@synthesize character; // Contains the cards character

@synthesize selfCardNum;

@synthesize frontView;

int screenWidth;
int screenHeight;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (id)initCard:(CGRect)frame cardNum:(int)inputCardNum isFresh:(BOOL)fresh
//{
//
//    frontView = [[Card alloc] initCard:frame :inputCardNum fresh:fresh];
//    
//    NSLog(@"I'm here now everybody, everything is cool.");
//    
//    UIColor *activeCardColour = [UIColor colorWithRed:(230.0 / 255.0) green:(230.0 / 255.0) blue:(230.0 / 255.0) alpha: 1];
//    UIColor *borderColour = [UIColor colorWithRed:(190.0 / 255.0) green:(190.0 / 255.0) blue:(190.0 / 255.0) alpha: 1];
//    
//    frontView.backgroundColor = activeCardColour;
//    frontView.layer.cornerRadius = 20.0;
//    frontView.layer.masksToBounds = YES;
//    frontView.layer.borderColor = borderColour.CGColor;
//    frontView.layer.borderWidth = 2;
//    
////    // Not used:
////    screenWidth = [UIScreen mainScreen].bounds.size.width;
////    screenHeight = [UIScreen mainScreen].bounds.size.height;
////    
////    selfCardNum = inputCardNum;
////    
////    // Reference to Background view controller
////    //StudyBackground* controller = (StudyBackground*) [[self superview] nextResponder];
////    
////    CGRect cardFrame;
////    cardFrame.size.width = 290;
////    cardFrame.size.height = 458;
////    //[self setFrame:newFrame];
////
////    // Fetch card's character
////    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
////    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Character" inManagedObjectContext:managedObjectContext];
////    
////    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id_num == %d", selfCardNum]];
////    [fetchRequest setEntity:entity];
////    
////    NSError *error;
////    self.character = [[managedObjectContext executeFetchRequest:fetchRequest error:&error] firstObject];
////    
////    NSLog(@"Requesting card #%d - %@ (ID: %@)",selfCardNum,character.literal,character.id_num);
////    
////    CardFront *cardFront = [[CardFront alloc] initCard:cardFrame cardNum:selfCardNum isFresh:fresh];
////
//    
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self setView:frontView];
    [self.view addSubview:frontView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
