//
//  SearchViewController.m
//  Privy
//
//  Created by Rajiv Ramaiah on 10/25/15.
//  Copyright © 2015 Rajiv Ramaiah Applications. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchProfileCollectionViewCell.h"
#import "SearchProfileViewController.h"
#import "User.h"
#import <Parse/Parse.h>

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL searchConducted;
@property NSArray *filteredSearchResults;
@property NSArray *users;
@property NSArray *images;
@property NSIndexPath *indexPath;
@property UIRefreshControl *refreshControl;

@end

@implementation SearchViewController

- (void)viewDidLoad {
   [super viewDidLoad];
   self.users = [NSArray new];
   self.searchConducted = NO;
   self.refreshControl = [[UIRefreshControl alloc] init];
   self.refreshControl.tintColor = [UIColor grayColor];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   if (self.searchConducted){
      return self.filteredSearchResults.count;
   }
   else
      return self.users.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   SearchProfileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoverCell" forIndexPath:indexPath];


   if (self.searchConducted){
      User *user = [self.filteredSearchResults objectAtIndex:indexPath.row];
      NSData *data = [user.profilePhoto getData];
      cell.username.text = user.username;
      [cell.username sizeToFit];
      cell.fullName.text = user.fullname;
      [cell.fullName sizeToFit];

      cell.pfImageView.image = [UIImage imageWithData:data];
      
      return cell;
   }
   else{

      User *user = [self.users objectAtIndex:indexPath.row];
      NSData *data = [user.profilePhoto getData];
      cell.username.text = user.username;
      [cell.username sizeToFit];
      cell.fullName.text = user.fullname;
      [cell.fullName sizeToFit];

      cell.pfImageView.image = [UIImage imageWithData:data];
      
      return cell;
   }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   self.indexPath = indexPath;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   SearchProfileViewController *spvc = segue.destinationViewController;
   spvc.user = [self.users objectAtIndex:self.indexPath.row];

}
-(IBAction)back:(UIStoryboardSegue *)sender{
}

@end
