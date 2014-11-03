//
//  ContainerViewController.h
//  deck
//
//  Created by Ewan Leaver on 03/11/2014.
//  Copyright (c) 2014 Ewan Leaver. All rights reserved.
//

@import UIKit;
@import Foundation;

@protocol ContainerViewControllerDelegate;

@interface ContainerViewController : UIViewController

/// The container view controller delegate receiving the protocol callbacks.
@property (nonatomic, weak) id<ContainerViewControllerDelegate>delegate;

/// The view controllers currently managed by the container view controller.
@property (nonatomic, copy) NSMutableArray *viewControllers;

/// The currently selected and visible child view controller.
@property (nonatomic, assign) UIViewController *selectedViewController;

/** Designated initializer.
 @note The view controllers array cannot be changed after initialization.
 */
- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end

@protocol ContainerViewControllerDelegate <NSObject>
@optional
/** Informs the delegate that the user selected view controller by tapping the corresponding icon.
   @note The method is called regardless of whether the selected view controller changed or not and only as a result of the user tapped a button. The method is not called when the view controller is changed programmatically. This is the same pattern as UITabBarController uses.
   */
- (void)containerViewController:(ContainerViewController *)containerViewController didSelectViewController:(UIViewController *)viewController;

/// Called on the delegate to obtain a UIViewControllerAnimatedTransitioning object which can be used to animate a non-interactive transition.
- (id <UIViewControllerAnimatedTransitioning>)containerViewController:(ContainerViewController *)containerViewController animationControllerForTransitionFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController;
@end
