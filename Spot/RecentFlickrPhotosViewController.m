//
//  RecentFlickrPhotosViewController.m
//  Spot
//
//  Created by Marwan on 6/17/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import "RecentFlickrPhotosViewController.h"
#import "recentPhotos.h"

@interface RecentFlickrPhotosViewController ()

@end

@implementation RecentFlickrPhotosViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	self.photos = [recentPhotos allPhotos];
}

@end
