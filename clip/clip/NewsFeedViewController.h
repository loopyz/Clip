//
//  NewsFeedViewController.h
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "KSVideoPlayerView.h"

#import <UIKit/UIKit.h>

@interface NewsFeedViewController : UITableViewController<UIScrollViewDelegate>

@property (nonatomic, strong) KSVideoPlayerView *player;
@end
