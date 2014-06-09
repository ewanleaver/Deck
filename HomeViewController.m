//
//  MenuViewController.m
//  deck
//
//  Created by Ewan Leaver on 08/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import "HomeViewController.h"
#import "StudyViewController.h"
#import "ListViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

-(IBAction)StartStudy:(id)sender {
    StudyViewController *BackgroundView = [[StudyViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:BackgroundView animated:YES completion:nil];
}



@synthesize managedObjectContext;

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
    //[[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    
    
    //self.managedObjectContext = [delegate managedObjectContext];
    
//    id delegate = [[UIApplication sharedApplication] delegate];
//    
//    ListViewController *controller;// = (MasterViewController *)navigationController.topViewController;
//    controller.managedObjectContext = [delegate managedObjectContext];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
