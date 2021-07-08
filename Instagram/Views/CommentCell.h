//
//  CommentCell.h
//  Instagram
//
//  Created by Elizabeth Ke on 7/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTextLabel;

@end

NS_ASSUME_NONNULL_END
