//
//  AddCarViewController.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 10.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCarViewController : UIViewController

@property (copy, nonatomic) void(^shouldSaveCarValueUpdated)(BOOL shouldSaveCar);

@end
