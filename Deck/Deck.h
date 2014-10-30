//
//  Deck.h
//  deck
//
//  Created by Ewan Leaver on 30/10/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Character;

@interface Deck : NSManagedObject

@property (nonatomic, retain) id bubbleColour;
@property (nonatomic, retain) id deckContents;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * numToStudy;
@property (nonatomic, retain) NSSet *cards;
@end

@interface Deck (CoreDataGeneratedAccessors)

- (void)addCardsObject:(Character *)value;
- (void)removeCardsObject:(Character *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

@end
