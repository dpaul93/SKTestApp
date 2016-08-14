//
//  WeatherModel.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "WeatherModel.h"
#import "WebServiceConstants.h"
#import "NSObject+LogProperties.h"

@implementation WeatherModel

#pragma mark - Initialization

-(void)updateWithJSON:(id)json {
    NSArray *weatherData = isNULL(json[@"weather"]);
    if(weatherData.count) {
        NSDictionary *currentData = weatherData.firstObject;
        self.weatherMain = isNULL(currentData[@"main"]);
        self.weatherDescription = isNULL(currentData[@"description"]);
        NSString *iconUrl = isNULL(currentData[@"icon"]);
        if(iconUrl) {
            self.weatherIconURL = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", iconUrl];
        }
    }
    self.weatherCityName = isNULL(json[@"name"]);
    NSDictionary *mainData = isNULL(json[@"main"]);
    if(mainData) {
        NSNumber *temp = isNULL(mainData[@"temp"]);
        if(temp) {
            CGFloat celsius = temp.floatValue - 273.0f; // Convert Kelvin to Celsius.
            self.weatherTemperature = celsius > 0.0f ? [NSString stringWithFormat:@"+%.f", celsius] : [NSString stringWithFormat:@"%f", celsius];
        }
    }
}

-(void)updateWithModel:(WeatherModel *)model {
    self.weatherMain = model.weatherMain;
    self.weatherIconURL = model.weatherIconURL;
    self.weatherCityName = model.weatherCityName;
    self.weatherDescription = model.weatherDescription;
    self.weatherTemperature = model.weatherTemperature;
}

-(NSString *)description {
    return [self logString];
}

@end
