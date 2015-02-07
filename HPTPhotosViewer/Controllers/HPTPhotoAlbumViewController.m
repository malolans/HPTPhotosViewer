//
//  HPTPhotoAlbumViewController.m
//  HPTPhotosViewer
//
//  Created by Malolan on 1/30/15.
//  Copyright (c) 2015 Haptrix. All rights reserved.
//

#import "HPTPhotoAlbumViewController.h"

#import "HPTPhotoCell.h"
#import "HPTMoreCell.h"

#import "HPTPhotosCollectionViewController.h"

@interface HPTPhotoAlbumViewController ()

@property (nonatomic, strong) NSMutableArray *photoAlbumArray;

@end

static NSString *const reuseIdentifierCell = @"PhotoCell";
static NSString *const reuseIdentifierMore = @"MoreCell";
static NSString *const reuseIdentifierSection = @"SectionHeader";
static NSInteger const maxPhotoCount = 3;

@implementation HPTPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoAlbumArray = [NSMutableArray array];
    
    for (NSUInteger count = 0; count < 3; count++) {
        NSMutableArray *photosArray = [NSMutableArray array];
        for (NSUInteger photoCount = 0; photoCount < 7; photoCount++) {
            NSString *fileName = [NSString stringWithFormat:@"%ld%ld.jpg", count, photoCount];
            UIImage *tempImage = [UIImage imageNamed:fileName];
            if (tempImage) {
                [photosArray addObject:tempImage];
            }
            else {
                break;
            }
        }
        [self.photoAlbumArray addObject:photosArray];
    }
    
    [self setupLayout];
}

- (void)setupLayout {
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat gutter = 10.0f;
    CGFloat spacing = 10.0f;
    
    CGFloat size = (width - (2 * gutter) - ((maxPhotoCount - 1) * spacing)) / maxPhotoCount;
    
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;

    layout.minimumInteritemSpacing = spacing;
    layout.itemSize = CGSizeMake(size, size);
    layout.sectionInset = UIEdgeInsetsMake(5.0f, gutter, 10.0f, gutter);
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (NSInteger)[self.photoAlbumArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *photosArray = (NSArray *)(self.photoAlbumArray[(NSUInteger)section]);
    NSInteger photoCount = (NSInteger)[photosArray count];
    if (photoCount > maxPhotoCount) {
        return maxPhotoCount;
    }
    else {
        return photoCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *photosArray = (NSArray *)(self.photoAlbumArray[(NSUInteger)indexPath.section]);
    
    if (indexPath.row == (maxPhotoCount - 1) && [photosArray count] > maxPhotoCount) {
        HPTMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierMore forIndexPath:indexPath];
        cell.moreLabel.text = [NSString stringWithFormat:@"+%li More", [photosArray count] - maxPhotoCount];
        
        return cell;
    }
    else {
        UIImage *photo = (UIImage *)photosArray[(NSUInteger)indexPath.row];
        HPTPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifierCell forIndexPath:indexPath];
        cell.imagePC.image = photo;
        
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierSection forIndexPath:indexPath];
    
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HPTPhotosCollectionViewController *destinationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotosVC"];
    
    NSMutableArray *photosArray = (NSMutableArray *)self.photoAlbumArray[(NSUInteger)indexPath.section];
    destinationVC.photosArray = photosArray;
    
    [self.navigationController pushViewController:destinationVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HPTPhotoCell *cell = (HPTPhotoCell *)sender;
    HPTPhotosCollectionViewController *destinationVC = (HPTPhotosCollectionViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    NSMutableArray *photosArray = (NSMutableArray *)self.photoAlbumArray[(NSUInteger)indexPath.section];
    destinationVC.photosArray = photosArray;
}

@end
