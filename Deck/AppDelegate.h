//
//  AppDelegate.h
//  Deck
//
//  Created by Ewan Leaver on 21/04/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> 

@property (strong, nonatomic) UIWindow *window;

// For the cards...
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// For the decks...
//@property (readonly, strong, nonatomic) NSManagedObjectContext *decksManagedObjectContext;
//@property (readonly, strong, nonatomic) NSManagedObjectModel *decksManagedObjectModel;
//@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *decksPersistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
