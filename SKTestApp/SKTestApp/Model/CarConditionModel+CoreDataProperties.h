//
//  CarConditionModel+CoreDataProperties.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CarConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarConditionModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) NSSet<CarModel *> *car;

@end

@interface CarConditionModel (CoreDataGeneratedAccessors)

- (void)addCarObject:(CarModel *)value;
- (void)removeCarObject:(CarModel *)value;
- (void)addCar:(NSSet<CarModel *> *)values;
- (void)removeCar:(NSSet<CarModel *> *)values;

@end

NS_ASSUME_NONNULL_END
