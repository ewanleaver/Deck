//
//  MasterViewController.h
//  Deck
//
//  Created by Ewan Leaver on 21/04/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController {
    
    IBOutlet UISwitch *readingSwitch;
    
}


@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (nonatomic, strong) NSArray *characters;

extern bool readingsToggled;

@end
