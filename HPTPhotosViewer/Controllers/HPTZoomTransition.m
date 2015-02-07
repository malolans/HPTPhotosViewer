//
//  HPTZoomInTransition.m
//  HPTPhotosViewer
//
//  Created by Malolan on 2/7/15.
//  Copyright (c) 2015 Haptrix. All rights reserved.
//

#import "HPTZoomTransition.h"

#import "HPTPhotosCollectionViewController.h"
#import "HPTPhotoViewController.h"

@implementation HPTZoomTransition

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (self.isZoomingIn) {
        [self zoomIntoPhoto:transitionContext];
    } else {
        [self zoomOutofPhoto:transitionContext];
    }

}

- (void)zoomIntoPhoto:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    HPTPhotosCollectionViewController *fromVC = (HPTPhotosCollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    HPTPhotoViewController *toVC = (HPTPhotoViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    
    CGRect imageFrame = [containerView convertRect:fromVC.animatingImageView.frame fromView:fromVC.animatingImageView.superview];
    UIImageView *imageSnapShot = [[UIImageView alloc] initWithFrame:imageFrame];
    imageSnapShot.image = fromVC.animatingImageView.image;
    imageSnapShot.contentMode = fromVC.animatingImageView.contentMode;
    
    fromVC.animatingImageView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.photoView.hidden = YES;
    toVC.view.alpha = 0.0f;
    [containerView addSubview:toVC.view];
    [containerView addSubview:imageSnapShot];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         toVC.view.alpha = 1.0f;
                         CGRect frame = toVC.photoView.frame;
                         imageSnapShot.frame = frame;
                     } completion:^(BOOL finished) {
                         fromVC.animatingImageView.hidden = NO;
                         toVC.photoView.hidden = NO;
                         [imageSnapShot removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

- (void)zoomOutofPhoto:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    HPTPhotoViewController *fromVC = (HPTPhotoViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    HPTPhotosCollectionViewController *toVC = (HPTPhotosCollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    
    CGRect imageFrame = [containerView convertRect:fromVC.photoView.frame fromView:fromVC.photoView.superview];
    UIImageView *imageSnapShot = [[UIImageView alloc] initWithFrame:imageFrame];
    imageSnapShot.image = fromVC.photoView.image;
    imageSnapShot.contentMode = fromVC.photoView.contentMode;
    
    fromVC.photoView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.animatingImageView.hidden = YES;
    toVC.view.alpha = 0.0f;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:imageSnapShot];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         toVC.view.alpha = 1.0f;
                         CGRect frame = [containerView convertRect:toVC.animatingImageView.frame fromView:toVC.animatingImageView.superview];
                         imageSnapShot.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         toVC.animatingImageView.hidden = NO;
                         fromVC.photoView.hidden = NO;
                         [imageSnapShot removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
}

@end
