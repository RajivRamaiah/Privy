//
//  SearchViewController.m
//  Privy
//
//  Created by Kellen Pierson on 10/26/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCollectionViewCell.h"
#import "SearchFriendProfileViewController.h"
#import "SearchNonFriendProfileViewController.h"
#import "User.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL searchConducted;
@property NSArray *filteredSearchResults;
@property NSArray *users;
@property NSArray *images;
@property UIRefreshControl *refreshControl;
@property User *currentUser;

@property SearchCollectionViewCell *selectedCell;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentUser = [User currentUser];
    self.users = [NSArray new];
    self.searchConducted = NO;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;


}

-(void) refreshControlAction{
    [self.refreshControl beginRefreshing];
    PFQuery *userQuery = [User query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.users = objects;
        NSLog(@"Success user find");
        [self.collectionView reloadData];
    }];
    [self.refreshControl endRefreshing];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchBar.text.length > 0){
        self.searchConducted = YES;
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"username contains [c] %@ OR fullname contains [c] %@", searchBar.text, searchBar.text];
        self.filteredSearchResults = [self.users filteredArrayUsingPredicate:resultPredicate];
        [self.collectionView reloadData];
    }

}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length == 0){
        [self.collectionView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchConducted = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
    [self.collectionView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated{
    PFQuery *userQuery = [User query];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.users = objects;
        NSLog(@"Success user find");
        [self.collectionView reloadData];
    }];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.searchConducted){
        return self.filteredSearchResults.count;
    }
    else
        return self.users.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoverCell" forIndexPath:indexPath];

    if (self.searchConducted){
        User *user = [self.filteredSearchResults objectAtIndex:indexPath.row];
        cell.user = user;

    } else {
        User *user = [self.users objectAtIndex:indexPath.row];
        cell.user = user;
    }

    [cell loadCell];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    SearchCollectionViewCell *cell = (SearchCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedCell = cell;

    PFRelation *friendsRelation = [self.currentUser friendsRelation];
    PFQuery *query = [friendsRelation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSArray *friends = objects;
        if ([friends containsObject:cell.user]){
            [self performSegueWithIdentifier:@"Friend" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
        }
        else{
            [self performSegueWithIdentifier:@"NonFriend" sender:[self.collectionView cellForItemAtIndexPath:indexPath]];
        }
    }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"NonFriend"]){
        SearchNonFriendProfileViewController *snfpvc = segue.destinationViewController;
        snfpvc.user = self.selectedCell.user;
    }
    else if ([segue.identifier isEqualToString:@"Friend"]){
        SearchFriendProfileViewController *sfpvc = segue.destinationViewController;
        sfpvc.user = self.selectedCell.user;
    }
}
-(IBAction)backFromNonFriend:(UIStoryboardSegue *)sender{


}

-(IBAction)backFromFriend:(UIStoryboardSegue *)sender{

}

@end
