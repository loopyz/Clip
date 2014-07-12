//
//  NewsFeedViewController.h
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "KSVideoPlayerView.h"
#import "PullToRefresh.h"


#import <UIKit/UIKit.h>

@interface NewsFeedViewController : UITableViewController<UIScrollViewDelegate, BEMPullToRefreshDelegate>

@property (nonatomic, strong) KSVideoPlayerView *player;
@property (nonatomic, strong) PullToRefresh *ptr;
@property (nonatomic, strong) NSMutableArray *videos;

@end
