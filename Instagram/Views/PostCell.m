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

- (IBAction)didTapFavorite:(id)sender {
    
    if ([self.post.likeCount intValue] == 0) {
        
        NSNumber *number = self.post.likeCount;
        NSString *numString;
        int value = [number intValue];
        number = [NSNumber numberWithInt:value + 1];
        numString = [NSString stringWithFormat:@"%@", number];
        [sender setTitle:numString forState:UIControlStateNormal];
        [self.favoriteButton setImage:[UIImage imageNamed:@"heart.fill"] forState: UIControlStateNormal];
        [self.post setValue:number forKey:@"likeCount"];
        [self.post saveInBackground];
    }
    
     else if ([self.post.likeCount intValue] >= 1) {

         NSNumber *number = [NSNumber numberWithInt:[self.post.likeCount intValue]];
         NSString *numString;
         int value = [self.post.likeCount intValue];
         number = [NSNumber numberWithInt:value - 1];
         numString = [NSString stringWithFormat:@"%@", number];
         [sender setTitle:numString forState:UIControlStateNormal];
         [self.favoriteButton setImage:[UIImage imageNamed:@"heart"] forState: UIControlStateNormal];
         [self.post setValue:number forKey:@"likeCount"];
         [self.post saveInBackground];
     }
}

@end
