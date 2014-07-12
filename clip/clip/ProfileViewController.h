//
//  ProfileViewController.h
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//
#import "KSVideoPlayerView.h"
#import "PullToRefresh.h"

#import <FacebookSDK/FacebookSDK.h>

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController<BEMPullToRefreshDelegate>

@property (nonatomic, strong) KSVideoPlayerView *player;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *videosTable;
@property (nonatomic, strong) UIView *profileSnippetView;
@property (nonatomic, strong) FBProfilePictureView *fbProfilePic;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) PullToRefresh *myPTR;

@end
