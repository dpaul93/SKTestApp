//
//  CarModel+CoreDataProperties.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 12.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CarModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *carDescription;
@property (nullable, nonatomic, retain) NSString *carName;
@property (nullable, nonatomic, retain) NSString *carPrice;
@property (nullable, nonatomic, retain) NSNumber *carID;
@property (nullable, nonatomic, retain) CarConditionModel *carCondition;
@property (nullable, nonatomic, retain) CarEngineModel *carEngine;
@property (nullable, nonatomic, retain) NSSet<CarImagesModel *> *carImages;
@property (nullable, nonatomic, retain) CarTransmissionModel *carTransmission;

@end

@interface CarModel (CoreDataGeneratedAccessors)

- (void)addCarImagesObject:(CarImagesModel *)value;
- (void)removeCarImagesObject:(CarImagesModel *)value;
- (void)addCarImages:(NSSet<CarImagesModel *> *)values;
- (void)removeCarImages:(NSSet<CarImagesModel *> *)values;

@end

NS_ASSUME_NONNULL_END
