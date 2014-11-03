//
//  ContainerViewController.h
//  deck
//
//  Created by Ewan Leaver on 03/11/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

@import UIKit;
@import Foundation;

@interface ContainerViewController : UIViewController

/// The view controllers currently managed by the container view controller.
@property (nonatomic, copy, readonly) NSArray *viewControllers;

/// The currently selected and visible child view controller.
@property (nonatomic, assign) UIViewController *selectedViewController;

/** Designated initializer.
 @note The view controllers array cannot be changed after initialization.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end
