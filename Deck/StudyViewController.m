//
//  Background.m
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "StudyViewController.h"
#import "Card.h"

@interface StudyViewController ()

@end

@implementation StudyViewController

@synthesize cardCount;

int cardsActive;
int cardsRight;
int cardsWrong;

UILabel *correctLabel;
UILabel *incorrectLabel;

NSArray *kanjiArray;

-(IBAction)StopStudy:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)AddCard:(id)sender {
    //Card *cardView = [[Card alloc] initWithNibName:nil bundle:nil];
    //[self.view addSubview:cardView];
    //[self presentModalViewController:cardView animated:YES];
    
    cardCount++;
    Card *cardView = [[Card alloc] initCard:CGRectMake(15,525,500,500):cardCount];
    
    UIColor *activeCardColour = [UIColor colorWithRed:(230.0 / 255.0) green:(230.0 / 255.0) blue:(230.0 / 255.0) alpha: 1];
    UIColor *borderColour = [UIColor colorWithRed:(190.0 / 255.0) green:(190.0 / 255.0) blue:(190.0 / 255.0) alpha: 1];
    
    cardView.backgroundColor = activeCardColour;
    cardView.layer.cornerRadius = 20.0;
    cardView.layer.masksToBounds = YES;
    cardView.layer.borderColor = borderColour.CGColor;
    cardView.layer.borderWidth = 2;
    
    [self.view addSubview:cardView];
    cardsActive++;
    
}

-(IBAction)RemoveCard:(id)sender {

    //[cardView removeFromSuperview];
}

- (int) getCardsActive {
    return cardsActive;
}
- (void) decCardsActive {
    cardsActive--;
}

- (void) cardRight {
    cardsRight++;
    correctLabel.text = [NSString stringWithFormat:@"%d", cardsRight];
    
}
- (void) cardWrong {
    cardsWrong++;
    incorrectLabel.text = [NSString stringWithFormat:@"%d", cardsWrong];
}

- (NSString *) selectKanji:(int)index {
    return @"酒";
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //UIColor *myColor = [UIColor colorWithRed:(128.0 / 255.0) green:(90.0 / 255.0) blue:(200.0 / 255.0) alpha: 0.5];
        UIColor *myColor = [UIColor colorWithRed:(80.0 / 255.0) green:(80.0 / 255.0) blue:(130.0 / 255.0) alpha: 1];
        self.view.backgroundColor = myColor;
    }
    
    [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15,25,100,100) cornerRadius:15];
    
    //kanjiArray = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"十", @"零", @"江", @"里", @"菜", @"駒"];
    
    correctLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 27, 40, 15)];
    correctLabel.text = [NSString stringWithFormat:@"%d", cardsRight];
    [correctLabel setTextColor:[UIColor greenColor]];
    [correctLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    [self.view addSubview:correctLabel];
    
    incorrectLabel = [[UILabel alloc] initWithFrame:CGRectMake(190, 27, 40, 15)];
    incorrectLabel.text = [NSString stringWithFormat:@"%d", cardsWrong];
    [incorrectLabel setTextColor:[UIColor redColor]];
    [incorrectLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    [self.view addSubview:incorrectLabel];
    
    cardCount = 0;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
