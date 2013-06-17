//
//  recentPhotos.m
//  Spot
//
//  Created by Marwan on 6/17/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import "recentPhotos.h"
#import "FlickrFetcher.h"

@implementation recentPhotos

#define RECENT_FLICKR_PHOTOS_KEY @"RecentWatchedPhotos_Key"
#define RECENT_FLICKR_PHOTOS_NUMBER 20

+ (NSArray *)allPhotos
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_FLICKR_PHOTOS_KEY];
}

+ (void)addPhoto:(NSDictionary *)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults objectForKey:RECENT_FLICKR_PHOTOS_KEY] mutableCopy];
    
    if (!recents) recents = [NSMutableArray array];
    
    //Try to find the photo in the recents
    NSUInteger key = [recents indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [photo[FLICKR_PHOTO_ID] isEqualToString:obj[FLICKR_PHOTO_ID]];
    }];
    
    if (key != NSNotFound) [recents removeObjectAtIndex:key]; //Delete photo if it already exists
    
    [recents insertObject:photo atIndex:0]; //Insert the photo at the begining of the recents array
    
    while ([recents count] > RECENT_FLICKR_PHOTOS_NUMBER) { //Make sure that recents is not larger than the number specified
        [recents removeLastObject];
    }
    
    [defaults setObject:recents forKey:RECENT_FLICKR_PHOTOS_KEY]; //Save array to NSUserDefaults
    [defaults synchronize];
}

@end
