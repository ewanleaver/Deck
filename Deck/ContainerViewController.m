//
//  ContainerViewController.m
//  Deck
//
//  Created by Ewan Leaver on 2016/03/13.
//  Copyright © 2016年 Ewan Leaver. All rights reserved.
//

#import "ContainerViewController.h"
#import "Animator.h"

// A private UIViewControllerContextTransitioning class to be provided transitioning delegates.
// @discussion Because we are a custom UIViewController class, with our own containment implementation,
//    we have to provide an object conforming to the UIViewControllerContextTransitioning protocol.
//    The system view controllers use one provided by the framework, which we cannot configure, let alone create.
//    This class will be used even if the developer provides their own transitioning objects.
// @note The only methods that will be called on objects of this class are the ones defined in the UIViewControllerContextTransitioning protocol.
//    The rest is our own private implementation.
@interface PrivateTransitionContext : NSObject //<UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingUp:(BOOL)goingUp; // Designated initializer.

@property (nonatomic, assign, getter=isAnimated) BOOL animated; // Private setter for the animated property.
@property (nonatomic, assign, getter=isInteractive) BOOL interactive; // Private setter for the interactive property.
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete); // A block of code we can set to execute after having received the completeTransition: message.

@end

#pragma mark - Private Transitioning Classes

@interface PrivateTransitionContext ()

@property (nonatomic, strong) NSDictionary *viewControllers;
@property (nonatomic, assign) CGRect disappearingFromRect;
@property (nonatomic, assign) CGRect appearingFromRect;
@property (nonatomic, assign) CGRect disappearingToRect;
@property (nonatomic, assign) CGRect appearingToRect;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

@end

@implementation PrivateTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingUp:(BOOL)goingUp {
    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        self.viewControllers = @{
                                 UITransitionContextFromViewControllerKey:fromViewController,
                                 UITransitionContextToViewControllerKey:toViewController
                                 };
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        CGFloat travelDistance = (goingUp ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width);
        self.disappearingFromRect = self.appearingToRect = self.containerView.bounds;
        self.disappearingToRect = CGRectOffset (self.containerView.bounds, 0, travelDistance);
        self.appearingFromRect = CGRectOffset (self.containerView.bounds, 0, -travelDistance);
    }
    
    return self;
}

@end

#pragma mark - ContainerViewController

@interface ContainerViewController ()

// The view hosting the child view controllers
@property (nonatomic, strong) UIView *privateContainerView;

@end

@implementation ContainerViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    NSParameterAssert ([viewControllers count] > 0);
    if ((self = [super init])) {
        self.viewControllers = viewControllers;
    }
    return self;
}

// Created the view that the view controller manages
- (void)loadView {
    UIView *rootView = [UIView new];
    rootView.backgroundColor = [UIColor blackColor];
    //rootView.opaque = YES;
    
    self.privateContainerView = [UIView new];
    self.privateContainerView.backgroundColor = [UIColor blackColor];
    //self.privateContainerView.opaque = YES;
    
    //[self.privateContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rootView addSubview:self.privateContainerView];
    
    // Container view fills out entire root view
//    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
//    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
//    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
//    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // If we have a selectedViewController use it, otherwise use the first controller in our array
    self.selectedViewController = (self.selectedViewController ?: self.viewControllers[0]);
}

- (void)_transitionToChildViewController:(UIViewController *)toViewController {
    
    UIViewController *fromViewController = ([self.childViewControllers count] > 0 ? self.childViewControllers[0] : nil);
    if (toViewController == fromViewController || ![self isViewLoaded]) {
        return;
    }
    
    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = self.privateContainerView.bounds;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    // If this is the initial presentation, add the new child with no animation.
    if (!fromViewController) {
        [self.privateContainerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        return;
    }
    
    // Animate the transition by calling the animator with our private transition context.
    
    Animator *animator = [[Animator alloc] init];
    
    // Our ViewControllers are vertically aligned, so we need to determine which direction we're transitioning in
    NSUInteger fromIndex = [self.viewControllers indexOfObject:fromViewController];
    NSUInteger toIndex = [self.viewControllers indexOfObject:toViewController];
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingUp:toIndex > fromIndex];
    
    transitionContext.animated = YES;
    transitionContext.interactive = NO;
    transitionContext.completionBlock = ^(BOOL didComplete) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
        //self.privateButtonsView.userInteractionEnabled = YES;
    };
    
    //self.privateButtonsView.userInteractionEnabled = NO; // Prevent user tapping buttons mid-transition, messing up state
    [animator animateTransition:transitionContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


