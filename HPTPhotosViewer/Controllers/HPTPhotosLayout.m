//
//  HPTAlbumLayout.m
//  HPTPhotosViewer
//
//  Created by Malolan on 1/30/15.
//  Copyright (c) 2015 Haptrix. All rights reserved.
//

#import "HPTPhotosLayout.h"

#import "JBSpacer.h"

@implementation HPTPhotosLayout

- (void)prepareLayout {
    self.itemSize = CGSizeMake(100.0f, 100.0f);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 1.0f;
    self.minimumLineSpacing = 1.0f;
    
    CGFloat itemSize = 105.0f;
    CGFloat minimumGutter = 1.0f;
    CGFloat availableSize = self.collectionView.bounds.size.width;
    
    JBSpacer *spacer = [JBSpacer spacer];
    
    BOOL success = [spacer findBestSpacingWithOptions:@[[JBSpacerOption optionWithItemSize:itemSize
                                                                             minimumGutter:minimumGutter
                                                                       gutterToMarginRatio:0.0f
                                                                             availableSize:availableSize
                                                                  distributeExtraToMargins:YES],
                                                        [JBSpacerOption optionWithItemSize:itemSize
                                                                             minimumGutter:minimumGutter
                                                                       gutterToMarginRatio:1.0f
                                                                             availableSize:availableSize
                                                                  distributeExtraToMargins:YES]]];
    
    if (success) {
        
        [spacer applySpacingToCollectionViewFlowLayout:(UICollectionViewFlowLayout *)self];
    }
}

@end
