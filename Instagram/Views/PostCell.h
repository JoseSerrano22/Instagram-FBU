//
//  PostCell.h
//  Instagram
//
//  Created by jose1009 on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "Parse/Parse.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *const profileImage;
@property (weak, nonatomic) IBOutlet UILabel *const usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *const timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *const postImage;
@property (weak, nonatomic) IBOutlet UIButton *const favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *const commentButton;
@property (weak, nonatomic) IBOutlet UILabel *const descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *const favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *const commentCountLabel;

@property (strong, nonatomic) Post *post;

-(void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
