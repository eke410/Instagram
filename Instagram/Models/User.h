//
//  User.h
//  Instagram
//
//  Created by Elizabeth Ke on 7/9/21.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *profilePhotoURLString;

+ (User *) createUserFromPFUser:(PFUser *)pfUser;

@end

NS_ASSUME_NONNULL_END