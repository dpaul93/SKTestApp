//
//  TestDTO.m
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "TestDTO.h"

@implementation TestDTO

#pragma mark - Setters

-(void)setWeatherToken:(NSString *)weatherToken {
    if(weatherToken) {
        [self addValue:weatherToken key:@"APPID"];
    }
}

@end
