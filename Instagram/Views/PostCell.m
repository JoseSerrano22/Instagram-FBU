//
//  PostCell.m
//  Instagram
//
//  Created by jose1009 on 7/7/21.
//

#import "PostCell.h"

@implementation PostCell

-(void)setPost:(Post *)post{
    _post = post;
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    PFUser *const postAuthor = self.post.author;
    [postAuthor fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        PFFileObject *const image = postAuthor[@"profile_image"];
        NSURL *const url = [NSURL URLWithString:image.url];
        [self.profileImage setImageWithURL:url];
    }];

    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImage.image = [UIImage imageWithData:data];
        }
    }];
    
    self.descriptionLabel.text = post.caption;
    self.usernameLabel.text = post.author.username;
    
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    self.commentCountLabel.text = [NSString stringWithFormat:@"%@", self.post.commentCount];
    self.favoriteButton.selected = [self.post.likedByUsername containsObject:PFUser.currentUser.objectId];
    
    NSString *const createdAtOriginalString = self.timestampLabel.text = [NSString stringWithFormat:@"%@", post.createdAt];
    NSDateFormatter *const formatter = [[NSDateFormatter alloc] init];

    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";

    NSDate *const date = [formatter dateFromString:createdAtOriginalString];
    NSDate *const now = [NSDate date];
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
