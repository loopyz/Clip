//
//  EarnedCouponsViewController.h
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefresh.h"


@interface EarnedCouponsViewController : UITableViewController<BEMPullToRefreshDelegate> {
    NSMutableIndexSet *expandedSections;
}

@property (nonatomic, strong) PullToRefresh *myPTR;

@end
