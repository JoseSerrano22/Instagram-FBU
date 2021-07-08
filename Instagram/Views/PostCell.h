//
//  PostCell.h
//  Instagram
//
//  Created by jose1009 on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "DateTools.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@property (strong, nonatomic) Post *post;

-(void)setPost:(Post *)post;

@end

NS_ASSUME_NONNULL_END
