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
    [self.post.author[@"photo"] getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        [self.authorPhotoImageView setImage:[UIImage imageWithData:imageData]];
    }];
    self.captionLabel.text = self.post.caption;
    self.authorLabel.text = self.post.author.username;
    self.timeAgoLabel.text = self.post.createdAt.shortTimeAgoSinceNow;
    self.likesCountLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:@" likes"];
    
    if ([self.post.usersWhoLiked containsObject:PFUser.currentUser.objectId]) {
        [self updateLikeButtonToLiked];
    } else {
        [self updateLikeButtonToUnliked];
    }
}

- (IBAction)likePost:(id)sender {
    if (![self.post.usersWhoLiked containsObject:PFUser.currentUser.objectId]) {
        NSLog(@"Liking post");
        self.post.usersWhoLiked = [self.post.usersWhoLiked arrayByAddingObject:PFUser.currentUser.objectId];
        self.post.likeCount = @([self.post.likeCount intValue] + 1);
        [self.post saveInBackground];
        
        self.likesCountLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:@" likes"];
        [self updateLikeButtonToLiked];
    } else {
        NSLog(@"Unliking post");
        NSMutableArray *mutableCopy = [self.post.usersWhoLiked mutableCopy];
        [mutableCopy removeObject:PFUser.currentUser.objectId];
        self.post.usersWhoLiked = (NSArray *)mutableCopy;
        self.post.likeCount = @([self.post.likeCount intValue] - 1);
        [self.post saveInBackground];
        
        self.likesCountLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:@" likes"];
        [self updateLikeButtonToUnliked];
    }
}

- (void)updateLikeButtonToLiked {
    UIImage *image = [UIImage systemImageNamed:@"heart.fill" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
    [self.likeButton setImage:image forState:UIControlStateNormal];
    [self.likeButton setTintColor:[UIColor redColor]];
}

- (void)updateLikeButtonToUnliked {
    UIImage *image = [UIImage systemImageNamed:@"heart" withConfiguration:[UIImageSymbolConfiguration configurationWithScale:(UIImageSymbolScaleLarge)]];
    [self.likeButton setImage:image forState:UIControlStateNormal];
    [self.likeButton setTintColor:[UIColor blackColor]];
}


@end
