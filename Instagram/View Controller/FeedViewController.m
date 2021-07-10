//
//  FeedViewController.m
//  Instagram
//
//  Created by jose1009 on 7/6/21.
//

#import "FeedViewController.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "AppDelegate.h"
#import "Post.h"
#import "PostCell.h"
#import "DetailsViewController.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *const posts;
@property (weak, nonatomic) IBOutlet UITableView *const tableView;
@property (nonatomic, strong) UIRefreshControl *const refreshControl;
@property (nonatomic) BOOL isMoreDataLoading;
@property (nonatomic) int skipCount;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _fetchPosts];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.skipCount = 2;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(_fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

#pragma mark - Private

- (IBAction)_logOutDidTap:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        UIStoryboard *const storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *const loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [[UIApplication sharedApplication].keyWindow setRootViewController: loginViewController];
        NSLog(@"Logged out!");
    }];
}

- (void)_fetchPosts {
    PFQuery *const postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.posts = (NSMutableArray *) posts;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)_loadMoreData {
    PFQuery *const query = [PFQuery queryWithClassName:@"Post"];
    
    query.limit = 20 * self.skipCount;
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            
            self.isMoreDataLoading = false;
            self.posts = (NSMutableArray *) posts;
            NSLog(@"Posts added to array");
            [self.tableView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    self.skipCount++;
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            [self _loadMoreData];
        }
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCell *const cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    Post *const post = self.posts[indexPath.row];
    cell.post = post;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detailsSegue"]){
        PostCell *const tappedCell = sender;
        NSIndexPath *const indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *const post = self.posts[indexPath.row];
        UINavigationController *const nav = [segue destinationViewController];
        DetailsViewController *const detailsViewController = (DetailsViewController *)[nav topViewController];
        detailsViewController.post = post;
    }
}

@end
