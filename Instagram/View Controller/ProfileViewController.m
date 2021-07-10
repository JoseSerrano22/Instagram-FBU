//
//  ProfileViewController.m
//  Instagram
//
//  Created by jose1009 on 7/9/21.
//

#import "ProfileViewController.h"
#import "PostCollectionCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "Parse/Parse.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *const posts;
@property (nonatomic, strong) UIRefreshControl *const refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *const collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UILabel *const usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const numberOfPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *const bioLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self _fetchPosts];
    
    PFUser *const currentUser = PFUser.currentUser;
    [currentUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.usernameLabel.text = [currentUser username];
        PFFileObject *const image = currentUser[@"profile_image"];
        NSURL *const url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
        self.usernameLabel.text = [currentUser username];
        self.bioLabel.text = currentUser[@"bio"];
    }];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(_fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)_fetchPosts {
    
    PFQuery *const query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {

            self.posts = (NSMutableArray *) posts;
            NSLog(@"Posts assigned to array");
            
            const NSInteger numOfPost = self.posts.count;
            self.numberOfPostLabel.text = [NSString stringWithFormat:@"%ld", (long)numOfPost];
            
            PFUser *const currentUser = PFUser.currentUser;
            [currentUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                self.usernameLabel.text = [currentUser username];
                PFFileObject *const image = currentUser[@"profile_image"];
                NSURL *const url = [NSURL URLWithString:image.url];
                [self.profileImage setImageWithURL:url];
                self.usernameLabel.text = [currentUser username];
                self.bioLabel.text = currentUser[@"bio"];
                
            }];
            [self.collectionView reloadData];
            
        } else {
            NSLog(@"%@", error.localizedDescription);
            
        }
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - UICollectionViewDelegate

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *const cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    cell.post = self.posts[indexPath.item];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
