//
//  HPTPhotosViewController.m
//  HPTPhotosViewer
//
//  Created by Malolan on 2/3/15.
//  Copyright (c) 2015 Haptrix. All rights reserved.
//

#import "HPTPhotosCollectionViewController.h"

#import "HPTPhotoCell.h"

#import "HPTPhotoViewController.h"

#import "HPTZoomTransition.h"

@interface HPTPhotosCollectionViewController ()

@end

static NSString * const reuseIdentifier = @"PhotoCell";

@implementation HPTPhotosCollectionViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.delegate == self) {
        self.navigationController.delegate = nil;
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (NSInteger)[self.photosArray count];
}

- (HPTPhotoCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HPTPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImage *photo = (UIImage *)self.photosArray[(NSUInteger)indexPath.row];
    
    cell.imagePC.image = photo;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HPTPhotoCell *cell = (HPTPhotoCell *)sender;
    HPTPhotoViewController *destinationVC = (HPTPhotoViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    UIImage *image = (UIImage *)self.photosArray[(NSUInteger)indexPath.row];
    destinationVC.image = image;
    self.animatingImageView = cell.imagePC;
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if ([toVC isKindOfClass:[HPTPhotoViewController class]]) {
        HPTZoomTransition *transition = [HPTZoomTransition new];
        transition.isZoomingIn = YES;
        return transition;
    } else {
        return nil;
    }
}

@end
