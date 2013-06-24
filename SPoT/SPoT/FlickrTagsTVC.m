//
//  FlickrTagsTVC.m
//  SPoT
//
//  Created by Ben Andrews on 23/06/2013.
//  Copyright (c) 2013 Ben Andrews. All rights reserved.
//

#import "FlickrTagsTVC.h"
#import "FlickrFetcher.h"
#import "FlickrPhotoTVC.h"

@interface FlickrTagsTVC ()
@property (strong, nonatomic) NSArray *orderedTags;
@end

@implementation FlickrTagsTVC

- (void)setTags:(NSDictionary *)tags
{
    _tags = tags;
    self.orderedTags = [tags allKeys];
    [self.tableView reloadData];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Photo List"]) {
                NSString *tag = [[self titleForRow:indexPath.row] lowercaseString];
                [segue.destinationViewController setTitle:[tag capitalizedString]];
                NSArray *photos = [self.tags objectForKey:tag];
                [segue.destinationViewController setPhotos:photos];
            }
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tags count];
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [[self.orderedTags objectAtIndex:row] capitalizedString];
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    NSUInteger numPhotos = [[self.tags objectForKey:[self.orderedTags objectAtIndex:row]] count];
    return [NSString stringWithFormat:@"%d photos", numPhotos];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Flickr Tag";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}

@end
