//
//  User.m
//  Instagram
//
//  Created by Elizabeth Ke on 7/9/21.
//

#import "User.h"

@implementation User

+ (User *)createUserFromPFUser:(PFUser *)pfUser {
    User *user = [User new];
    user.objectId = pfUser.objectId;
    user.username = pfUser.username;
    user.profilePhotoURLString = @"";
    return user;
}

@end
