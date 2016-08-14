//
//  CarModel.h
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "CarEngineModel.h"
#import "CarTransmissionModel.h"
#import "CarImagesModel.h"
#import "CarConditionModel.h"

@class CarEngineModel;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kCarID;
extern NSString * const kCarDescription;
extern NSString * const kCarName;
extern NSString * const kCarPrice;
extern NSString * const kCarCondition;
extern NSString * const kCarEngine;
extern NSString * const kCarImages;
extern NSString * const kCarTransmission;

@interface CarModel : NSManagedObject

-(void)updateWithJSON:(NSDictionary*)data;

@end

NS_ASSUME_NONNULL_END

#import "CarModel+CoreDataProperties.h"
