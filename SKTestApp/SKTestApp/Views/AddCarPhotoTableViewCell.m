//
//  AddCarPhotoTableViewCell.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 10.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "AddCarPhotoTableViewCell.h"
#import "AddCarPhotoCollectionViewCell.h"

static NSInteger const kCellSize = 84.0f;

@interface AddCarPhotoTableViewCell() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@end

@implementation AddCarPhotoTableViewCell

#pragma mark - Initialization

-(void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Actions

- (IBAction)nextButtonPressed:(id)sender {
    NSInteger x = self.photoCollectionView.contentOffset.x / kCellSize + 1;
    if(x <= self.images.count) {
        CGFloat xOffset = x * kCellSize + x * 10.0f;
        if(xOffset != self.photoCollectionView.contentOffset.x) {
            [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:x inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        }
    }
}

- (IBAction)backButtonPressed:(id)sender {
    NSInteger x = self.photoCollectionView.contentOffset.x / kCellSize;
    CGFloat xOffset = x * kCellSize + x * 10.0f;
    if(xOffset == self.photoCollectionView.contentOffset.x) {
        if(x == 0) {
            return;
        } else {
            --x;
        }
    }
    [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:x inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

#pragma mark - UICollectionView Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count + 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AddCarPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AddCarPhotoCollectionViewCell class]) forIndexPath:indexPath];
    
    UIImage *cellImage = indexPath.row >= self.images.count ? [UIImage imageNamed:@"addIcon"] : self.images[indexPath.row];
    cell.photoImageView.image = cellImage;
    
    return cell;
}

#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row >= self.images.count) {
        if(self.didPressAddPhotoCell) {
            self.didPressAddPhotoCell(self);
        }
    } else {
        
    }
}

#pragma mark - UICollectionViewDelegate Flow Layout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kCellSize, kCellSize);
}

#pragma mark - Setters

-(void)setImages:(NSArray *)images {
    _images = images;
    [self.photoCollectionView reloadData];
    [self.photoCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:images.count inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}

@end
