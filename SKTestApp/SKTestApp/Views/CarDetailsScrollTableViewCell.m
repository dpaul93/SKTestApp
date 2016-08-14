//
//  CarDetailsScrollTableViewCell.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 10.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "CarDetailsScrollTableViewCell.h"

@interface CarDetailsScrollTableViewCell() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *contentImages;

@end

@implementation CarDetailsScrollTableViewCell

#pragma mark - Actions

- (IBAction)pageControlValueChanged:(id)sender {
    NSInteger currentIndex = ((UIPageControl*)sender).currentPage;
    CGRect visibleRect = self.scrollView.frame;
    visibleRect.origin = CGPointMake(self.frame.size.width * currentIndex, 0);
    [self.scrollView scrollRectToVisible:visibleRect animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    if(!self.images.count) {
        return;
    }
    
    [self scrollToImageBack:YES];
}

- (IBAction)nextButtonPressed:(id)sender {
    if(!self.images.count) {
        return;
    }

    [self scrollToImageBack:NO];
}

-(void)scrollToImageBack:(BOOL)back {
    CGFloat xOffset = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds);
    xOffset = back ? --xOffset : ++xOffset;
    BOOL shouldScroll = NO;
    shouldScroll = (back && xOffset >= 0.0f);
    if(!shouldScroll) {
        shouldScroll = (!back && xOffset <= self.images.count - 1);
    }
    if(shouldScroll) {
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.scrollView.contentOffset = CGPointMake(xOffset * CGRectGetWidth(self.bounds), 0.0f);
        } completion:^(BOOL finished) {
            [self.pageControl setCurrentPage:xOffset];
        }];
    }
}

#pragma mark - Setters

-(void)setImages:(NSArray *)images {
    _images = images;

    for (UIView *child in self.scrollView.subviews) {
        [child removeFromSuperview];
    }
    [self.scrollView setContentSize:CGSizeZero];
    
    [self layoutIfNeeded];
    [self.scrollView layoutIfNeeded];
    [self.scrollView setNeedsUpdateConstraints];
    CGSize imageViewSize = self.frame.size;
    CGFloat height = imageViewSize.height;
    
    self.pageControl.numberOfPages = images.count;

    CGSize dummySize = CGSizeMake(self.frame.size.width * images.count, height);
    UIView *dummy = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, dummySize.width, dummySize.height)];
    [dummy setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.scrollView addSubview:dummy];

    for (int i = 0; i < images.count; i++) {
        UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(self.bounds), 0.0f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [currentImageView setContentMode:UIViewContentModeScaleAspectFill];
        [currentImageView setClipsToBounds:YES];
        currentImageView.image = images[i];
        
        [dummy addSubview:currentImageView];
    }
    
    [self.scrollView layoutIfNeeded];
    
    [self.scrollView setContentSize:CGSizeMake(dummySize.width, 1.0f)];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    [self.pageControl setCurrentPage:xOffset];
}

@end
