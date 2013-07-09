//
//  FlickrPhotoTVC.m
//  Shutterbug
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "FlickrPhotoTVC.h"
#import "FlickrFetcher.h"
#import "ImageCacheManager.h"

@implementation FlickrPhotoTVC

#define DATE_KEY @"Date_Selected"
#define ALL_PHOTOS_KEY @"PhotoHistory_All"

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    NSSortDescriptor *sortByPhotoName = [NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_TITLE ascending:YES];
    NSSortDescriptor *sortByPhotoSubtitle = [NSSortDescriptor sortDescriptorWithKey:FLICKR_PHOTO_DESCRIPTION ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortByPhotoName, sortByPhotoSubtitle, nil];
    self.photos = [self.photos sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    FlickrPhotoFormat imageFormat = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? FlickrPhotoFormatOriginal : FlickrPhotoFormatLarge;
                    NSURL *url = [FlickrFetcher urlForPhoto:self.photos[indexPath.row] format:imageFormat];
                    NSString *photoID = self.photos[indexPath.row][@"id"];
                    if (![ImageCacheManager imageInCache:photoID]) {
                        [ImageCacheManager cacheImageFromUrl:url withFilename:photoID];
                    } else {
                        url = [ImageCacheManager urlForImage:photoID];
                    }
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    [segue.destinationViewController setTitle:[self titleForRow:indexPath.row]];
                    [self saveToHistory:indexPath];
                }
            }
        }
    }
}

- (NSDictionary *)removeOldestPhotoFromDictionary:(NSMutableDictionary *)dictionary
{
    NSArray *photos = [dictionary allValues];
    NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:DATE_KEY ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
    NSMutableArray *sortedPhotos = [[photos sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    [sortedPhotos removeObjectAtIndex:sortedPhotos.count - 1];
    
    NSMutableArray *photoIDs = [[NSMutableArray alloc] init];
    for (NSDictionary *photo in sortedPhotos) {
        [photoIDs addObject:photo[@"id"]];
    }
    return [NSDictionary dictionaryWithObjects:sortedPhotos forKeys:photoIDs];
}

- (void)saveToHistory:(NSIndexPath *)indexPath
{
    NSMutableDictionary *mutablePhotoHistoryFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_PHOTOS_KEY] mutableCopy];
    if (!mutablePhotoHistoryFromUserDefaults) mutablePhotoHistoryFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    NSString *photoID = [NSString stringWithFormat:@"%@", self.photos[indexPath.row][FLICKR_PHOTO_ID]];
        
    if ([mutablePhotoHistoryFromUserDefaults objectForKey:photoID]) {
        [mutablePhotoHistoryFromUserDefaults removeObjectForKey:photoID];
    } else if ([mutablePhotoHistoryFromUserDefaults count] >= 10) {
        mutablePhotoHistoryFromUserDefaults = [[self removeOldestPhotoFromDictionary:mutablePhotoHistoryFromUserDefaults] mutableCopy];
    }
    
    NSMutableDictionary *photo = [self.photos[indexPath.row] mutableCopy];
    photo[DATE_KEY] = [NSDate date];
    mutablePhotoHistoryFromUserDefaults[photoID] = photo;
    [[NSUserDefaults standardUserDefaults] setObject:mutablePhotoHistoryFromUserDefaults forKey:ALL_PHOTOS_KEY];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self.photos[row][FLICKR_PHOTO_TITLE] description]; // description because could be NSNull
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [[self.photos[row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION] description]; // description because could be NSNull
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
