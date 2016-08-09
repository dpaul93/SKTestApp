//
//  WeatherModel.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "WeatherModel.h"
#import "WebServiceConstants.h"

@implementation WeatherModel

#pragma mark - Initialization

-(instancetype)initWithJSON:(id)json {
    if(self = [super init]) {
        NSArray *weatherData = isNULL(json[@"weather"]);
        if(weatherData.count) {
            NSDictionary *currentData = weatherData.firstObject;
            self.weatherMain = isNULL(currentData[@"main"]);
            self.weatherDescription = isNULL(currentData[@"description"]);
            NSString *iconUrl = isNULL(currentData[@"icon"]);
            if(iconUrl) {
                self.weatherIconURL = [NSString stringWithFormat:@"%@.png", iconUrl];
            }
        }
        self.weatherCityName = isNULL(json[@"name"]);
        NSNumber *temp = isNULL(json[@"temp"]);
        self.weatherTemperature = @(temp.floatValue - 273.0f); // Convert Kelvin to Celsius.
    }
    
    return self;
}

-(void)updateWithModel:(WeatherModel *)model {
    self.weatherTemperature = model.weatherTemperature;
    self.weatherCityName = model.weatherCityName;
    self.weatherIconURL = model.weatherIconURL;
    self.weatherDescription = model.weatherDescription;
    self.weatherMain = model.weatherMain;
}

@end
