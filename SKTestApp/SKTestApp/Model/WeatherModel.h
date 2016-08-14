//
//  WeatherModel.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BaseWebServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherModel : NSManagedObject <BaseWebServiceModelInterface>

-(void)updateWithModel:(WeatherModel*)model;

@end

NS_ASSUME_NONNULL_END

#import "WeatherModel+CoreDataProperties.h"
