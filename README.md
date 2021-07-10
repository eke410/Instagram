# Project 4 - Instagram

Instagram is a photo sharing app using Parse as its backend.

Time spent: **18** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [x] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [x] Tapping on a post's username or profile photo goes to that user's profile page
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [x] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen.
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [x] Click comment button to immediately start commenting on a post.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Better way to add profile photo to user. 
2. How to use collection views better. 

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![](https://i.imgur.com/Ouj3NKx.gif)
![](https://i.imgur.com/1XNgJ5G.gif)
![](https://i.imgur.com/WDy95oB.gif)
![](https://i.imgur.com/3SfjMWv.gif)
![](https://i.imgur.com/vVee7b6.gif)
![](https://i.imgur.com/GHB1NAb.gif)
![](https://i.imgur.com/zJKqAmF.gif)
![](https://i.imgur.com/vrHE9R5.gif)

GIF created with [ezgif](https://ezgif.com/video-to-gif).

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [Parse](https://docs.parseplatform.org/)
- [AFNetworking](https://github.com/AFNetworking/AFNetworking) 
- [UITextView-Placeholder](https://github.com/devxoul/UITextView-Placeholder)
- [DateTools](https://github.com/MatthewYork/DateTools)
- [MBProgressHUD](https://github.com/matej/MBProgressHUD)


## Notes

Describe any challenges encountered while building the app.
- implementing infinite scrolling - accidentally made 4000 API requests in the span of a few minutes
- adding profile picture feature - figuring how to incorporate that extra property into PFUser object
- collection view - cells were not sizing the way I wanted them to  

## License

    Copyright 2021 Elizabeth Ke

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
