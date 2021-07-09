//
//  PostCollectionCell.m
//  Instagram
//
//  Created by jose1009 on 7/9/21.
//

#import "PostCollectionCell.h"

@implementation PostCollectionCell

-(void)setPost:(Post *)post{
    _post = post;
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (!error) {
            self.postImageView.image = [UIImage imageWithData:data];
        }
    }];
}

@end
