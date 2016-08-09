//
//  TestResponseInfo.m
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "TestResponseInfo.h"

@implementation TestResponseInfo

@dynamic parsedData;

-(instancetype)initWithJSON:(id)json {
    if(self = [super init]){
        self.responseData = json;
    }
    
    return self;
}

@end
