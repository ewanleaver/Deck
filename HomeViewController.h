//
//  MenuViewController.h
//  deck
//
//  Created by Ewan Leaver on 08/06/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

- (IBAction)StartStudy:(id)sender;

@end
