//
//  ImageViewController.m
//  Spot
//
//  Created by Marwan on 6/13/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import "ImageViewController.h"
#import "activityIndicator.h"
#import "FlickrCache.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

- (void) setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

- (UIView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}

- (void)resetImage
{
    if (self.scrollView) {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        if (!self.imageURL) return;
        [self.spinner startAnimating];
        
        NSURL *imageURL = self.imageURL;
        dispatch_queue_t imageFetchQ = dispatch_queue_create("image fetcher", NULL);
        dispatch_async(imageFetchQ, ^{
            
            //check to see if image is cached and if not get it then cache it
            NSData *imageData;
            NSURL *cachedURL = [FlickrCache cachedURLforURL:imageURL];
            if (cachedURL) {
                imageData = [[NSData alloc] initWithContentsOfURL:cachedURL];
            } else {
                [activityIndicator showActivityIndicator];
                imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                [activityIndicator hideActivityIndicator];
            }
            [FlickrCache cacheData:imageData forURL:self.imageURL];
            
            
            if(self.imageURL == imageURL) {
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                dispatch_async(dispatch_get_main_queue(), ^ {
                    if(image) {
                        self.scrollView.zoomScale = 1.0;
                        self.scrollView.contentSize = image.size;
                        self.imageView.image = image;
                        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                        [self setImageScale];
                    }
                    [self.spinner stopAnimating];
                });
            }
        });
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)setImageScale
{
    double wScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    double hScale = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale = 0.2;
    self.scrollView.maximumZoomScale = 5;
    self.scrollView.delegate = self;
    [self resetImage];
}



@end
