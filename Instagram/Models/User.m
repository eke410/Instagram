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
    user.photo = pfUser[@"photo"];
    user.pfUser = pfUser;
    return user;
}

+ (User *) getUserWithId:(NSString *)userId {
    PFQuery *query = [PFUser query];
    [query whereKey:@"objectId" equalTo:userId];
    NSArray *users = [query findObjects];
    if (users) {
        PFUser *pfUser = [users firstObject];
        return [User createUserFromPFUser:pfUser];
    } else {
        return nil;
    }
}


@end
