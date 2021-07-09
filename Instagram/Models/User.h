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
@property (nonatomic, strong) PFFileObject *photo;

+ (User *) createUserFromPFUser:(PFUser *)pfUser;
+ (User *) getUserWithId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
