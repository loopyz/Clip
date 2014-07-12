//
//  NewCouponsViewController.h
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"

@interface NewCouponsViewController : UITableViewController<BEMPullToRefreshDelegate>
{
    UITableView *newCouponsTableView;
}

@property (nonatomic, strong) UIScrollView *myScroll;
@property (nonatomic, strong) PullToRefresh *myPTR;
@end
