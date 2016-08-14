//
//  CarDetailsViewController.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 10.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "CarDetailsViewController.h"
#import "CarDetailsScrollTableViewCell.h"
#import "MultiLabeledTableViewCell.h"
#import "CarModel.h"
#import "UIImage+ImageWithPath.h"

#import <MagicalRecord/MagicalRecord.h>

typedef NS_ENUM(NSInteger, ShowCarCellType) {
    ShowCarCellTypeScroll,
    ShowCarCellTypeTitleHeader,
    ShowCarCellTypeEngine,
    ShowCarCellTypeCondition,
    ShowCarCellTypeTransmission,
    ShowCarCellTypeDescription,
    ShowCarCellTypeCount
};

static NSString * const kCarDetailsTitleHeaderCell = @"CarDetailsTitleHeaderCell";
static NSString * const kCarDetailsSelectableCell = @"CarDetailsSelectableCell";
static NSString * const kCarDetailsDescriptonCell = @"CarDetailsDescriptonCell";

@interface CarDetailsViewController() <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *carDetailsTableView;

@end

@implementation CarDetailsViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    self.carDetailsTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableView Data Source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ShowCarCellTypeCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == ShowCarCellTypeScroll) {
        return [self prepareShowScrollTableViewCellWithTableView:tableView];
    } else {
        return [self prepareShowMultiLabeledCellWithType:indexPath.row tableView:tableView];
    }
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == ShowCarCellTypeScroll) {
        CarDetailsScrollTableViewCell *scrollCell = (CarDetailsScrollTableViewCell*)cell;
        NSMutableArray *temp = [NSMutableArray new];
        NSArray *imagesModel = [self.car.carImages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"imagePath" ascending:YES]]];
        for (CarImagesModel *imageModel in imagesModel) {
            UIImage *image = [UIImage imageWithPath:imageModel.imagePath];
            if(image) {
                [temp addObject:image];
            }
        }
        scrollCell.images = temp;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForShowRowWithType:indexPath.row tableView:tableView];
}

#pragma mark - Show Car Helpers

-(CGFloat)heightForShowRowWithType:(ShowCarCellType)type tableView:(UITableView*)tableView {
    switch (type) {
        case ShowCarCellTypeScroll: return self.car.carImages.count ? CGRectGetWidth(tableView.bounds) * 0.698f : 0.0f; // Scroll cell height aspect ratio.
        case ShowCarCellTypeEngine:
        case ShowCarCellTypeCondition:
        case ShowCarCellTypeTransmission: return 37.0f;
        case ShowCarCellTypeTitleHeader: return 34.0f;
        case ShowCarCellTypeDescription: {
            CGFloat height = [self heightForText:self.car.carDescription withFont:[UIFont systemFontOfSize:14.0f] andWidth:CGRectGetWidth(tableView.bounds) - 32.0f] + 30.0f;
            return height > 34.0f ? height : 45.0f;
        }
            default: return 0.001f;
    }
}

-(UITableViewCell*)prepareShowScrollTableViewCellWithTableView:(UITableView*)tableView {
    CarDetailsScrollTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CarDetailsScrollTableViewCell class])];
    return cell;
}

-(UITableViewCell*)prepareShowMultiLabeledCellWithType:(ShowCarCellType)type tableView:(UITableView*)tableView {
    MultiLabeledTableViewCell *cell;
    
    switch (type) {
        case ShowCarCellTypeTitleHeader: {
            cell = [tableView dequeueReusableCellWithIdentifier:kCarDetailsTitleHeaderCell];
            cell.leftLabel.text = self.car.carName;
            cell.rightLabel.text = self.car.carPrice;
            break;
        }
        case ShowCarCellTypeCondition: {
            cell = [tableView dequeueReusableCellWithIdentifier:kCarDetailsSelectableCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-condition", nil);
            cell.rightLabel.text = NSLocalizedString(((CarConditionModel*)self.car.carCondition).condition, nil);
            break;
        }
        case ShowCarCellTypeTransmission: {
            cell = [tableView dequeueReusableCellWithIdentifier:kCarDetailsSelectableCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-transmission", nil);
            cell.rightLabel.text = NSLocalizedString(((CarTransmissionModel*)self.car.carTransmission).transmission, nil);
            break;
        }
        case ShowCarCellTypeEngine: {
            cell = [tableView dequeueReusableCellWithIdentifier:kCarDetailsSelectableCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-engine", nil);
            cell.rightLabel.text = NSLocalizedString(((CarEngineModel*)self.car.carEngine).engine, nil);
            break;
        }
        case ShowCarCellTypeDescription: {
            cell = [tableView dequeueReusableCellWithIdentifier:kCarDetailsDescriptonCell];
            cell.leftLabel.text = NSLocalizedString(@"car-cell-description", nil);
            cell.inputTextView.text = self.car.carDescription;
            break;
        }
        default: break;
    }
    
    return cell;
}

-(CGFloat)heightForText:(NSString*)text withFont:(UIFont *)font andWidth:(CGFloat)width {
    CGSize constrainedSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary];
    CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    if (requiredHeight.size.width > width) {
        requiredHeight = CGRectMake(0.0f, 0.0f, width, requiredHeight.size.height);
    }
    return requiredHeight.size.height;
}


@end
