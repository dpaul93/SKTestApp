//
//  WeatherModel+CoreDataProperties.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WeatherModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *weatherIconURL;
@property (nullable, nonatomic, retain) NSString *weatherDescription;
@property (nullable, nonatomic, retain) NSString *weatherMain;
@property (nullable, nonatomic, retain) NSString *weatherCityName;
@property (nullable, nonatomic, retain) NSNumber *weatherTemperature;

@end

NS_ASSUME_NONNULL_END
