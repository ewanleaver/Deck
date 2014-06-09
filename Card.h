//
//  Card.h
//  TestPro_iOS
//
//  Created by Ewan Leaver on 13/03/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Card : UIView

-(id)initCard:(CGRect)frame :(int)cardNumInput;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray *characters;

@property int cardNum;

@end
