//
//  CarEngineModel+CoreDataProperties.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CarEngineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarEngineModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *engine;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *car;

@end

@interface CarEngineModel (CoreDataGeneratedAccessors)

- (void)addCarObject:(NSManagedObject *)value;
- (void)removeCarObject:(NSManagedObject *)value;
- (void)addCar:(NSSet<NSManagedObject *> *)values;
- (void)removeCar:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
