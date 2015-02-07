//
//  HPTPhotoViewController.m
//  HPTPhotosViewer
//
//  Created by Malolan on 2/1/15.
//  Copyright (c) 2015 Haptrix. All rights reserved.
//

#import "HPTPhotoViewController.h"

#import "HPTZoomTransition.h"

@interface HPTPhotoViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;

@end

@implementation HPTPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoView.image = self.image;
    [self initZoom];
    [self updateConstraints];
    
    [self setupGestureRecognizers];
}

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

- (void)setupGestureRecognizers {
    UITapGestureRecognizer *doubleTapperPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDoubleTapped:)];
    doubleTapperPhoto.numberOfTapsRequired = 2;
    doubleTapperPhoto.delegate = self;
    [self.scrollView addGestureRecognizer:doubleTapperPhoto];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShowNavigation)];
    [singleTap requireGestureRecognizerToFail:doubleTapperPhoto];
    [self.scrollView addGestureRecognizer:singleTap];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoView;
}

#pragma mark - Gesture Recognizer Actions

- (void)imageDoubleTapped:(UITapGestureRecognizer *)sender {
    
    CGPoint rawLocation = [sender locationInView:sender.view];
    CGPoint point = [self.photoView convertPoint:rawLocation fromView:sender.view];
    CGRect targetZoomRect;
    UIEdgeInsets targetInsets;
    if (self.scrollView.zoomScale == 1.0f) {
        CGFloat zoomWidth = self.view.bounds.size.width / 2.0f;
        CGFloat zoomHeight = self.view.bounds.size.height / 2.0f;
        targetZoomRect = CGRectMake(point.x - (zoomWidth/2.0f), point.y - (zoomHeight/2.0f), zoomWidth, zoomHeight);
    } else {
        CGFloat zoomWidth = self.view.bounds.size.width * self.scrollView.zoomScale;
        CGFloat zoomHeight = self.view.bounds.size.height * self.scrollView.zoomScale;
        targetZoomRect = CGRectMake(point.x - (zoomWidth/2.0f), point.y - (zoomHeight/2.0f), zoomWidth, zoomHeight);
    }
    self.view.userInteractionEnabled = NO;
    
    [CATransaction begin];
    __weak typeof(self)weakSelf = self;
    [CATransaction setCompletionBlock:^{
        weakSelf.scrollView.contentInset = targetInsets;
        weakSelf.view.userInteractionEnabled = YES;
    }];
    [self.scrollView zoomToRect:targetZoomRect animated:YES];
    [CATransaction commit];
}

- (void)hideShowNavigation {
    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden];
    if ([self.scrollView.backgroundColor isEqual:[UIColor blackColor]]) {
        self.scrollView.backgroundColor = [UIColor whiteColor];
    } else {
        self.scrollView.backgroundColor = [UIColor blackColor];
    }
}

- (void) initZoom {    
    CGFloat minZoom = MIN(self.view.bounds.size.width / self.photoView.image.size.width,
                        self.view.bounds.size.height / self.photoView.image.size.height);
    
    if (minZoom > 1) minZoom = 1;
    
    self.scrollView.minimumZoomScale = minZoom;
    
    self.scrollView.zoomScale = minZoom;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateConstraints];
}

- (void) updateConstraints {
    CGFloat imageWidth = self.photoView.image.size.width;
    CGFloat imageHeight = self.photoView.image.size.height;
    
    CGFloat viewWidth = self.view.bounds.size.width;
    CGFloat viewHeight = self.scrollView.bounds.size.height;
    
    // center image if it is smaller than screen
    CGFloat hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
    if (hPadding < 0) hPadding = 0;
    
    CGFloat vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
    if (vPadding < 0) vPadding = 0;
    
    self.constraintLeft.constant = hPadding;
    self.constraintRight.constant = hPadding;
    
    self.constraintTop.constant = vPadding;
    self.constraintBottom.constant = vPadding;
    
    // Makes zoom out animation smooth and starting from the right point not from (0, 0)
    [self.view layoutIfNeeded];
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {

    HPTZoomTransition *transition = [HPTZoomTransition new];
    return transition;
}

@end
