//
//  FlickrCache.h
//  Spot
//
//  Created by Marwan on 6/22/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKRCACHE_MAXSIZE_IPHONE 1024*1024*3
#define FLICKRCACHE_MAXSIZE_IPAD 1024*1024*10
#define FLICKRCACHE_FOLDER @"flickrPhotos"

@interface FlickrCache : NSObject
+ (NSURL *)cachedURLforURL:(NSURL *)url;
+ (void)cacheData:(NSData *)data forURL:(NSURL *)url;
@end
