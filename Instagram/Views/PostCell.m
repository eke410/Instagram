//
//  PostCell.m
//  Instagram
//
//  Created by Elizabeth Ke on 7/6/21.
//

#import "PostCell.h"
#import "DateTools.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshData {
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        [self.photoImageView setImage:[UIImage imageWithData:imageData]];
    }];
    self.captionLabel.text = self.post.caption;
    self.authorLabel.text = self.post.author.username;
    self.timeAgoLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    self.likesCountLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:@" likes"];
}

- (IBAction)likePost:(id)sender {
    NSLog(@"liking post");
    
}


@end
