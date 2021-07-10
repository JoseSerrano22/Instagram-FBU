//
//  DetailsViewController.m
//  Instagram
//
//  Created by jose1009 on 7/8/21.
//
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.post);
    PFUser *user = self.post.author;
    
    self.usernameLabel.text = user.username;
    self.descriptionLabel.text = self.post.caption;
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    PFUser *postAuthor = self.post.author;
    [postAuthor fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *image = postAuthor[@"profile_image"];
        NSURL *url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
    }];
    
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImage.image = [UIImage imageWithData:data];
        }
    }];
    
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", self.post.commentCount];
    self.favoriteButton.selected = [self.post.likedByUsername containsObject:PFUser.currentUser.objectId];
    
    NSString *createdAtOriginalString = self.timestampLabel.text = [NSString stringWithFormat:@"%@", self.post.createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    
    NSDate *date = [formatter dateFromString:createdAtOriginalString];
    NSDate *now = [NSDate date];
    NSInteger timeApart = [now hoursFrom:date];
    
    if (timeApart >= 24) {
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.timestampLabel.text = [formatter stringFromDate:date];
    }
    else {
        self.timestampLabel.text = date.shortTimeAgoSinceNow;
    }
}

#pragma mark - Private
- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_didTapFavorite:(id)sender {
    if(self.favoriteButton.selected){
        self.favoriteButton.selected = false;
        [self.favoriteButton setSelected:NO];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] - 1)];
        [self.post unlike];
        
    } else if(!self.favoriteButton.selected) {
        self.favoriteButton.selected = true;
        [self.favoriteButton setSelected:YES];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] + 1)];
        
        if(!self.post.likedByUsername) {
            self.post.likedByUsername = [NSMutableArray new];
        }
        [self.post like];
    }
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
}

@end
