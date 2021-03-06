//
//  DetailsViewController.h
//  Instagram
//
//  Created by Elizabeth Ke on 7/7/21.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Post *post;
@property (nonatomic) BOOL *cameFromCommentButton;

@end

NS_ASSUME_NONNULL_END
