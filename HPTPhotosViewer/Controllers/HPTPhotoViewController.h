//
//  HPTPhotoViewController.h
//  HPTPhotosViewer
//
//  Created by Malolan on 2/1/15.
//  Copyright (c) 2015 Haptrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPTPhotoViewController : UIViewController <UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIImage *image;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;

@end
