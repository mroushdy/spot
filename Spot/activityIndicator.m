//
//  activityIndicator.m
//  Spot
//
//  Created by Marwan on 6/18/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import "activityIndicator.h"
#include <libkern/OSAtomic.h>

@implementation activityIndicator


+(void)showActivityIndicator
{
    [self setNetworkActivityIndicatorVisible:TRUE];
}

+(void)hideActivityIndicator
{
    [self setNetworkActivityIndicatorVisible:FALSE];
}

+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible //Not the best thread safe implementation could also potentially use locks or osmutableadd
{
    static volatile int32_t NumberOfCallsToSetVisible = 0;
    int32_t newValue = OSAtomicAdd32((setVisible ? +1 : -1), &NumberOfCallsToSetVisible);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(newValue > 0)];
}

@end
