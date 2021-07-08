//
//  PostCell.m
//  Instagram
//
//  Created by jose1009 on 7/7/21.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setPost:(Post *)post{
    _post = post;
    
    //    [post.author[@"profileImage"] getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
    //            if (!error) {
    //                cell.profileImage.image = [UIImage imageWithData:data];
    //            }
    //        }];
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
            self.profileImage.clipsToBounds = YES;
    
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImage.image = [UIImage imageWithData:data];
        }
    }];
    
    self.descriptionLabel.text = post.caption;
    self.usernameLabel.text = post.author.username;
    NSString *commentCountString = [post.commentCount stringValue];
    [self.commentButton setTitle:commentCountString forState:UIControlStateNormal];
    NSString *likeCountString = [post.likeCount stringValue];
    [self.favoriteButton setTitle:likeCountString forState:UIControlStateNormal];
    
    NSString *createdAtOriginalString = self.timestampLabel.text = [NSString stringWithFormat:@"%@", post.createdAt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss z";
    // Convert String to Date
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
    
    if ([post.likeCount intValue] >= 1) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart.fill"] forState:UIControlStateNormal];
    }
    else if ([post.likeCount intValue] == 0) {
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
    }
}

- (IBAction)didTapFavorite:(id)sender {
    
    if(self.favoriteButton.selected){
        self.favoriteButton.selected = false;
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart"] forState: UIControlStateNormal];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] - 1)];
        [self.post saveInBackground];
        
    } else if(!self.favoriteButton.selected) {
        self.favoriteButton.selected = true;
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart.fill"] forState: UIControlStateNormal];
        self.post.likeCount = [NSNumber numberWithInteger:([self.post.likeCount intValue] + 1)];
        [self.post saveInBackground];
    }
    NSString *numString = [NSString stringWithFormat:@"%@", self.post.likeCount];
    [sender setTitle:numString forState:UIControlStateNormal];
    
    
    //    if ([self.post.likeCount intValue] == 0) {
    //
    //        NSNumber *number = self.post.likeCount;
    //        NSString *numString;
    //        int value = [number intValue];
    //        number = [NSNumber numberWithInt:value + 1];
    //        numString = [NSString stringWithFormat:@"%@", number];
    //        [sender setTitle:numString forState:UIControlStateNormal];
    //        [self.favoriteButton setImage:[UIImage imageNamed:@"heart.fill"] forState: UIControlStateNormal];
    //        [self.post setValue:number forKey:@"likeCount"];
    //        [self.post saveInBackground];
    //    }
    //
    //     else if ([self.post.likeCount intValue] >= 1) {
    //
    //         NSNumber *number = [NSNumber numberWithInt:[self.post.likeCount intValue]];
    //         NSString *numString;
    //         int value = [self.post.likeCount intValue];
    //         number = [NSNumber numberWithInt:value - 1];
    //         numString = [NSString stringWithFormat:@"%@", number];
    //         [sender setTitle:numString forState:UIControlStateNormal];
    //         [self.favoriteButton setImage:[UIImage imageNamed:@"heart"] forState: UIControlStateNormal];
    //         [self.post setValue:number forKey:@"likeCount"];
    //         [self.post saveInBackground];
    //     }
}

@end
