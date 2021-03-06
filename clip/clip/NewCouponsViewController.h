//
//  NewCouponsViewController.h
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "AppendableVideoMaker.h"
#import "PullToRefresh.h"
#import "PullToRefresh.h"

#import <Parse/Parse.h>

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface NewCouponsViewController : UITableViewController<BEMPullToRefreshDelegate>
{
    UITableView *newCouponsTableView;
    AppendableVideoMaker *videoMaker;
}

@property (nonatomic, strong) UIScrollView *myScroll;
@property (nonatomic, strong) PullToRefresh *myPTR;
@property (nonatomic, strong) FBProfilePictureView *fbProfilePic;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) UIView *profileSnippetView;
@property (nonatomic, strong) PFObject *videoCampaign;
@property (nonatomic, strong) NSMutableArray *campaigns;
@property (nonatomic, assign) int videoId;
@property (nonatomic, assign) NSArray *picsArray;

- (id)initWithFacebookShit:(NSString *)userId userName:(NSString *)userName;

@end
