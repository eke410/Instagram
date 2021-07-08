//
//  DetailsViewController.m
//  Instagram
//
//  Created by Elizabeth Ke on 7/7/21.
//

#import "DetailsViewController.h"
#import "Post.h"
#import "DateTools.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
}

- (void)refreshData {
    [self.post.image getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        [self.photoImageView setImage:[UIImage imageWithData:imageData]];
    }];
    self.captionLabel.text = self.post.caption;
    self.authorLabel.text = self.post.author.username;
    self.createdAtLabel.text = [self.post.createdAt formattedDateWithFormat:@"MMMM d, yyyy · h:mm a"];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
