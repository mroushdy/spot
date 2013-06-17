//
//  recentPhotos.h
//  Spot
//
//  Created by Marwan on 6/17/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recentPhotos : NSObject
+ (NSArray *)allPhotos;
+ (void) addPhoto:(NSDictionary *)photo;
@end
