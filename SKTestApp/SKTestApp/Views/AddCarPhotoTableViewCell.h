//
//  AddCarPhotoTableViewCell.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 10.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCarPhotoTableViewCell : UITableViewCell <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (copy, nonatomic) void(^didPressAddPhotoCell)(AddCarPhotoTableViewCell *cell);

@property (strong, nonatomic) NSArray *images;

@end
