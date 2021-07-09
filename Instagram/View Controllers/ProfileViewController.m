//
//  ProfileViewController.m
//  Instagram
//
//  Created by Elizabeth Ke on 7/9/21.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "PostCollectionViewCell.h"
#import "Post.h"
#import "DetailsViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSMutableArray *posts;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ProfileViewController

CGFloat itemSideLength;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!self.user) {
        self.user = [User getUserWithId:PFUser.currentUser.objectId];
    }
    
    // set outlet values
    [self.user.photo getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        [self.photoImageView setImage:[UIImage imageWithData:imageData]];
    }];
    self.usernameLabel.text = self.user.username;
    
    // query posts
    [self queryPosts:60];
    
    // set up collection view
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;

    CGFloat photosPerLine = 3;
    itemSideLength = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (photosPerLine - 1)) / photosPerLine;

    layout.itemSize = CGSizeMake(itemSideLength, itemSideLength);
    layout.estimatedItemSize = CGSizeMake(itemSideLength, itemSideLength);

    self.photoImageView.layer.borderColor = [UIColor systemGray4Color].CGColor;
    
}

- (void)queryPosts:(int)limit {
    NSLog(@"queried: %i", limit);
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = limit;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // only keep posts with correct author
            self.posts = [NSMutableArray new];
            for (Post *post in posts) {
                if ([post.author.objectId isEqualToString:self.user.objectId]) {
                    [self.posts addObject:post];
                }
            }
            [self.collectionView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    
    Post *post = self.posts[indexPath.item];
    [post.image getDataInBackgroundWithBlock:^(NSData * _Nullable imageData, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:imageData];
        image = [self resizeImage:image withSize:CGSizeMake(itemSideLength-1, itemSideLength-1)];
        [cell.photoImageView setImage:image];
    }];
    
    return cell;
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.post = self.posts[indexPath.item];
}


@end
