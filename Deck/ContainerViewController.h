//
//  ContainerViewController.h
//  Deck
//
//  Created by Ewan Leaver on 2016/03/13.
//  Copyright © 2016年 Ewan Leaver. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

// The view controllers currently managed by the container view controller.
@property (nonatomic, copy) NSArray *viewControllers;
// The currently selected and visible child view controller.
@property (nonatomic, assign) UIViewController *selectedViewController;

// Designated initialiser
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end
