//
//  UIImage+ImageWithPath.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 12.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "UIImage+ImageWithPath.h"
#import <UIKit/UIKit.h>

@implementation UIImage (ImageWithPath)

+(UIImage *)imageWithPath:(NSString *)path {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:path];
    NSLog(@"%@", filePath);
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return nil;
    }
    UIImage *fetchImage = [UIImage imageWithContentsOfFile:filePath];
    return fetchImage;
}

@end
