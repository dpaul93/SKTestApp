//
//  TestWebService.m
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "TestWebService.h"
#import <UIImageView+AFNetworking.h>

NSString * const kWeatherAPIKey = @"4211cf075d8fa33f1b94c4e51f263b19";

static NSString * const kBaseURL = @"http://api.openweathermap.org/";

@implementation TestWebService

#pragma mark - Overrides

+(NSString *)baseURL {
    return kBaseURL;
}

-(Class)baseParseClass {
    return [TestResponseInfo class];
}

#pragma mark - Image loading

+(void)loadImageWithString:(NSString *)urlString forImageView:(UIImageView *)imageView {
    [imageView cancelImageDownloadTask];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    __weak typeof(imageView) __weakImageView = imageView;
    [imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __weakImageView.image = image;
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
    }];
}

@end
