//
//  DTOWrapper.m
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "DTOWrapper.h"
#import "TestDTO.h"
#import "TestWebService.h"

@implementation DTOWrapper

+(BaseDTO *)getWeatherDTOWithLongitude:(CGFloat)longitude latitude:(CGFloat)latitude {
    TestDTO *testDTO = [TestDTO initWithBlock:^(TestDTO *dto) {
        dto.requestType = BaseDTORequestGET;
        dto.urlEndpoint = @"data/2.5/weather";
        
        [dto addValue:@(latitude) key:@"lat"];
        [dto addValue:@(longitude) key:@"lon"];
        dto.weatherToken = kWeatherAPIKey;
    }];

    return testDTO;
}

@end
