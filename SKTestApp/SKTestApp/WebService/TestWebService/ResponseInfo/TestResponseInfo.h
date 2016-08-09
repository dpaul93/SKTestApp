//
//  TestResponseInfo.h
//
//  Created by Pavlo Deynega on 02.08.16.
//  Copyright © 2016 Paul Deynega. All rights reserved.
//

#import "BaseResponseInfo.h"

@interface TestResponseInfo <__covariant ObjectType> : BaseResponseInfo

@property (nonatomic, strong) ObjectType parsedData;

@end
