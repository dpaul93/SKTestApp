//
//  MainPageCarTableViewCell.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "MainPageCarTableViewCell.h"

@implementation MainPageCarTableViewCell

-(void)prepareForReuse {
    [super prepareForReuse];
    self.carImageView.image = nil;
    self.carNameLabel.text = nil;
    self.carPriceLabel.text = nil;
}

@end
