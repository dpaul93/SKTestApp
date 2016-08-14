//
//  CarModel.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "CarModel.h"
#import "CarEngineModel.h"
#import "WebServiceConstants.h"

NSString * const kCarID = @"carID";
NSString * const kCarDescription = @"carDescription";
NSString * const kCarName = @"carName";
NSString * const kCarPrice = @"carPrice";
NSString * const kCarCondition = @"carCondition";
NSString * const kCarEngine = @"carEngine";
NSString * const kCarImages = @"carImages";
NSString * const kCarTransmission = @"carTransmission";

@implementation CarModel

-(void)updateWithJSON:(NSDictionary *)data {
    self.carID = isNULL(data[kCarID]);
    self.carName = isNULL(data[kCarName]);
    self.carPrice = isNULL(data[kCarPrice]);
    self.carDescription = isNULL(data[kCarDescription]);
    self.carEngine = isNULL(data[kCarEngine]);
    self.carCondition = isNULL(data[kCarCondition]);
    self.carTransmission = isNULL(data[kCarTransmission]);
    self.carImages = isNULL(data[kCarImages]);
}

@end
