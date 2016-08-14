//
//  CarImagesModel+CoreDataProperties.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 10.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CarImagesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CarImagesModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *imagePath;
@property (nullable, nonatomic, retain) NSSet<CarModel *> *car;

@end

@interface CarImagesModel (CoreDataGeneratedAccessors)

- (void)addCarObject:(CarModel *)value;
- (void)removeCarObject:(CarModel *)value;
- (void)addCar:(NSSet<CarModel *> *)values;
- (void)removeCar:(NSSet<CarModel *> *)values;

@end

NS_ASSUME_NONNULL_END
