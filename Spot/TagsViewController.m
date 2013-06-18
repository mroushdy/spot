//
//  TagsViewController.m
//  Spot
//
//  Created by Marwan on 6/14/13.
//  Copyright (c) 2013 Marwan. All rights reserved.
//

#import "TagsViewController.h"
#import "FlickrFetcher.h"
#import "activityIndicator.h"

@interface TagsViewController ()
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSDictionary *photosByTag;
@end

@implementation TagsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(loadLatestPhotosFromFlickr) forControlEvents:UIControlEventValueChanged];
    [self loadLatestPhotosFromFlickr];
}

- (void)loadLatestPhotosFromFlickr
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loaderQ = dispatch_queue_create("flickr latest loader", NULL);
    dispatch_async(loaderQ, ^{
        [activityIndicator showActivityIndicator];
        NSArray *latestPhotos = [FlickrFetcher stanfordPhotos];
        [activityIndicator hideActivityIndicator];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photos = latestPhotos;
            [self.refreshControl endRefreshing];
        });
    });
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self updatePhotosByTag];
    [self.tableView reloadData];
}

- (void)updatePhotosByTag
{
    NSMutableDictionary *photosByTag = [NSMutableDictionary dictionary];
    for (NSDictionary *photo in self.photos) {
        for (NSString *tag in [photo[FLICKR_TAGS] componentsSeparatedByString:@" "]) {
            if ([tag isEqualToString:@"cs193pspot"]) continue;
            if ([tag isEqualToString:@"portrait"]) continue;
            if ([tag isEqualToString:@"landscape"]) continue;
            NSMutableArray *photos = [photosByTag objectForKey:tag];
            if (!photos) {
                photos = [NSMutableArray array];
                photosByTag[tag] = photos;
            }
            [photos addObject:photo];
        }
    }
    self.photosByTag = photosByTag;
}

- (NSString *)titleForRow:(NSUInteger)row 
{
    return [[[self.photosByTag allKeys] sortedArrayUsingSelector:@selector(compare:)][row] capitalizedString];
}

- (NSString *)subTitleForRow:(NSUInteger)row withTag:(NSString *)tag
{
    int photoCount = [self.photosByTag[[tag lowercaseString]] count];
    return [NSString stringWithFormat:@"%d photo%@", photoCount, photoCount > 1 ? @"s" : @""];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if(indexPath) {
            if([segue.identifier isEqualToString:@"Show Photos"]) {
                if([segue.destinationViewController respondsToSelector:@selector(photos)]) {
                    
                    NSString *tag = [[self titleForRow:indexPath.row] lowercaseString];
                    NSArray *photos = self.photosByTag[tag];
                    
                    [segue.destinationViewController performSelector:@selector(setPhotos:) withObject:photos];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                }
            }
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photosByTag count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *tag = [self titleForRow:indexPath.row];
    cell.textLabel.text = tag;
    cell.detailTextLabel.text = [self subTitleForRow:indexPath.row withTag:tag];
    
    return cell;
}


@end
