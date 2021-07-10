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

@property (strong, nonatomic) NSMutableArray *posts;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *bioLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self _fetchPosts];
    
    PFUser *currentUser = PFUser.currentUser;
    [currentUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.usernameLabel.text = [currentUser username];
        PFFileObject *image = currentUser[@"profile_image"];
        NSURL *url = [NSURL URLWithString:image.url];
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
    
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];

    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {

            self.posts = (NSMutableArray *) posts;
            NSLog(@"Posts assigned to array");
            
            NSInteger numOfPost = self.posts.count;
            self.numberOfPostLabel.text = [NSString stringWithFormat:@"%ld", (long)numOfPost];
            
            PFUser *currentUser = PFUser.currentUser;
            [currentUser fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                self.usernameLabel.text = [currentUser username];
                PFFileObject *image = currentUser[@"profile_image"];
                NSURL *url = [NSURL URLWithString:image.url];
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
    PostCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    cell.post = self.posts[indexPath.item];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

@end
