Original App Design Project - README Template
===

# AudioSound

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This is a social media app for majorly posting audio and sharing audio amongs our self. In this app
users are able to post audio clips onto an activity feed. Users are able to comment, like, share posts. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Social Media / Music
- **Mobile:** Mainly encouraged on mobile but available on desktop applications as well. More functionality will encapsulates mobile compared to desktop.
- **Story:** Users are able to post audio clips of whatever they want. Clips will be categorized to ensure simple interactivity. A few categories includes relaxation, music genres, nature sounds, motivational speeches, etc.  
- **Market:** Anyone would be able to use this app. Users of varying ages will have proper methods to ensure safety. 
- **Habit:** Depending on the individual the uses of it will vary. Usage would be similar to other social media apps.
- **Scope:** Users will be able to select a category in which they will be able to hear sounds. After selection a feed will pop up of user's audio clips 

## Video Walkthrough

Here's a walkthrough of implemented user stories:
## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://github.com/IOS-AudioSound/AudioSound/blob/main/Gif/Gif.gif' title='Video Walkthrough' title='Video Walkthrough' width='' alt='Video Walkthrough' />

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] User can post a audio clip to the feed
* [x] User can create a new account
* [x] User can login
* [X] User can logout
* [x] User can view a feed of audio clips
* [x] User can see their profile page with their audio clips

**Optional Nice-to-have Stories**

* [x] User can pause a playing audio while in the feed view
* [x] User can search the users by their username on search screen
* [x] Users can upload their profile picture
* [x] User can follow/unfollow another user
* [x] User can follow/ unfollow after searching the profile
* [x] User can see the number of posts in profile page
* [x] User can update their profile bio description
* [x] User can see the number of 'following' in their profile page
* [x] User can see a list of their followers
* [x] User can see a list of their following
* [x] User can view other user’s profiles and see their feed
* [x] User can search for other users
* [ ] User can add a comment on an audio clip
* [ ] User can like an audio clip
* [ ] User can tap a photo to view a more detailed photo screen with comments
* [ ] User can see trending audio clips
* [ ] User can search for audio clips with hashtags
* [ ] User can see notifications when their photo is liked or they are followed


**Bug solved**
* [x] Fixed the bug in profile page: when the user set the profile photo and close the app, and opens the app again, the user was not able to see the profile page. This thing got fixed.


### 2. Screen Archetypes

* Login Screen
    * User can login
* Registration Screen
    * User can create a new account
* Stream
    * User can view a feed of audio clips
    * User can double tap a photo to like
* Creation
    * User can post a new audio clip to their feed
* Settings
    * Lets people change lighting modes and app notification settings.

### 3. Navigation

**Tab Navigation** (Tab to Screen)
* Home
* Post
* Search
* Profile

**Flow Navigation** (Screen to Screen)

* Account Creation -> 
    * Log-In ->
    * Category Selection
* Log-In ->
    * Home Feed
* Audio Clips Category Selection
    * Respective Feed for that category
* Profile -> 
    * Edit Profile
* Settings ->
    * Toggle settings

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://github.com/IOS-AudioSound/AudioSound/blob/main/Wireframe/Wireframe.png" width=600>

### [BONUS] Digital Wireframes & Mockups
Link: https://www.figma.com/file/M2khPrxqxqnViWirqQbdvb/Untitled?node-id=0%3A1&t=Hd6WyEqN8u9lO92T-1

### [BONUS] Interactive Prototype
Link : https://www.figma.com/proto/M2khPrxqxqnViWirqQbdvb/Untitled?node-id=1-2&scaling=scale-down&page-id=0%3A1&starting-point-node-id=33%3A52

## Schema 
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
