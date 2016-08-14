//
//  NSObject+LogProperties.m
//  SKTestApp
//
//  Created by Pavlo Deynega on 09.08.16.
//  Copyright © 2016 Pavlo Deynega. All rights reserved.
//

#import "NSObject+LogProperties.h"
#import <objc/runtime.h>

@implementation NSObject (LogProperties)

- (NSString*)logString {
    NSMutableString *log = [NSMutableString new];
    [log appendFormat:@"\n---------- Properties for object %@", self];
    
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
        for (NSUInteger i = 0; i < numberOfProperties; i++) {
            objc_property_t property = propertyArray[i];
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            [log appendFormat:@"\nProperty %@ Value: %@", name, [self valueForKey:name]];
        }
        free(propertyArray);
    }
    return log;
}

@end
