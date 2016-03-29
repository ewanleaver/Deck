//
//  CardViewController.h
//  deck
//
//  Created by Ewan Leaver on 7/4/14.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"
#import "Card.h"

@interface CardViewController : UIViewController

//- (id)initCard:(CGRect)frame cardNum:(int)inputCardNum isFresh:(BOOL)fresh;

@property (nonatomic, strong) Character *character;

@property int selfCardNum;

@property Card *frontView;

@end
