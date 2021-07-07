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
