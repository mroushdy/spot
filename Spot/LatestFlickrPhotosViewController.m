//
//  LatestFlickrPhotosViewController.m
//  Spot
//
//  Created by Marwan on 6/13/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import "LatestFlickrPhotosViewController.h"
#import "FlickrFetcher.h"

@interface LatestFlickrPhotosViewController ()

@end

@implementation LatestFlickrPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.photos = [FlickrFetcher latestGeoreferencedPhotos];
}


@end
