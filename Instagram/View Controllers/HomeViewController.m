//
//  HomeViewController.m
//  Instagram
//
//  Created by Elizabeth Ke on 7/6/21.
//

#import "HomeViewController.h"
#import "Parse/Parse.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "PostCell.h"
#import "DetailsViewController.h"
#import "InfiniteScrollActivityView.h"
#import "ComposeViewController.h"

@interface HomeViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *posts;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation HomeViewController

InfiniteScrollActivityView *loadingMoreView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
        
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
        
    // Set up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tableView addSubview:loadingMoreView];
    
    UIEdgeInsets insets = self.tableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tableView.contentInset = insets;
    
    [self queryPosts:20];
}

- (IBAction)logoutUser:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = loginViewController;
    
    NSLog(@"User logged out successfully");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    cell.post = self.posts[indexPath.row];
    [cell refreshData];
    [cell.commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)commentButtonClicked:(PostCell *)cell {
    NSArray *sender = [[NSArray alloc] initWithObjects:cell, nil];
    [self performSegueWithIdentifier:@"detailsSegue" sender:sender];
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
            // do something with the array of object returned by the call
            self.posts = (NSMutableArray *) posts;
            [self.tableView reloadData];
            self.isMoreDataLoading = false;
            [loadingMoreView stopAnimating];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)refreshData:(UIRefreshControl *)refreshControl {
    [self queryPosts:20];
    [refreshControl endRefreshing];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            
            // Update position of loadingMoreView, and start loading indicator
            CGRect frame = CGRectMake(0, self.tableView.contentSize.height, self.tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Post"];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError * _Nullable error) {
                if (!error) {
                    if (count > self.posts.count) {
                        [self queryPosts:(self.posts.count+20)];
                    } else {
                        [loadingMoreView stopAnimating];
                    }
                } else {
                    NSLog(@"Error getting number of posts in database");
                }
            }];

        }
    }
}

- (void)didPost {
    [self queryPosts:20];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailsSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.post = self.posts[indexPath.row];
        if ([sender isKindOfClass:[NSArray class]]) { // comment button in a PostCell clicked
            detailsViewController.cameFromCommentButton = YES;
        }
    } else if ([segue.identifier isEqualToString:@"composeSegue"]) {
        ComposeViewController *composeViewController = [segue destinationViewController];
        composeViewController.delegate = self;
    }

}


@end
