//
//  DetailsViewController.m
//  Instagram
//
//  Created by Elizabeth Ke on 7/7/21.
//

#import "DetailsViewController.h"
#import "Post.h"
#import "DateTools.h"
#import "UITextView+Placeholder.h"
#import "CommentCell.h"

@interface DetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIButton *postCommentButton;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
    
    self.commentTableView.dataSource = self;
    self.commentTableView.delegate = self;
    
    self.commentView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
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
        NSLog(@"Liked post");
        self.post.usersWhoLiked = [self.post.usersWhoLiked arrayByAddingObject:PFUser.currentUser.objectId];
        self.post.likeCount = @([self.post.likeCount intValue] + 1);
        [self.post saveInBackground];
        
        self.likesCountLabel.text = [[self.post.likeCount stringValue] stringByAppendingString:@" likes"];
        [self updateLikeButtonToLiked];
    } else {
        NSLog(@"Unliked post");
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

- (IBAction)commentPost:(id)sender {
    if ([self.commentTextView.text isEqualToString:@""]) {
        NSLog(@"Cannot post empty comment");
    } else {
        NSLog(@"Posted comment");
        NSDictionary *comment = [[NSDictionary alloc] initWithObjectsAndKeys:self.commentTextView.text, @"text", PFUser.currentUser.username, @"username", PFUser.currentUser.objectId, @"user_id", nil];
        self.post.comments = [[[NSArray alloc] initWithObjects:comment, nil] arrayByAddingObjectsFromArray:self.post.comments];
        self.post.commentCount = @([self.post.commentCount intValue] + 1);
        [self.post saveInBackground];
        
        // TODO: update UI
        self.commentTextView.text = @"";
        [self.commentTableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.post.commentCount integerValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [self.commentTableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    NSDictionary *comment = self.post.comments[indexPath.row];
    cell.usernameLabel.text = comment[@"username"];
    cell.commentTextLabel.text = comment[@"text"];
    return cell;
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
