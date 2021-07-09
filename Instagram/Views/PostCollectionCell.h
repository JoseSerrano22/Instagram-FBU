//
//  PostCollectionCell.h
//  Instagram
//
//  Created by jose1009 on 7/9/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCollectionCell : UICollectionViewCell
@property (nonatomic, strong) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

-(void)setPost:(Post *)post;
@end

NS_ASSUME_NONNULL_END
