//
//  TestWebService.h
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "WebService.h"
#import "WebServiceConstants.h"
#import "DTOWrapper.h"
#import "TestDTO.h"
#import "TestResponseInfo.h"

extern NSString * const kWeatherAPIKey;

@interface TestWebService : WebService

+(void)loadImageWithString:(NSString *)urlString forImageView:(UIImageView *)imageView;

@end
