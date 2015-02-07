//
//  HPTPhotosViewController.h
//  HPTPhotosViewer
//
//  Created by Malolan on 2/3/15.
//  Copyright (c) 2015 Haptrix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPTPhotosCollectionViewController : UICollectionViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, weak) UIImageView *animatingImageView;

@end
