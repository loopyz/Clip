//
//  NewCouponsViewController.h
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "AppendableVideoMaker.h"

#import <UIKit/UIKit.h>

@interface NewCouponsViewController : UITableViewController
{
    UITableView *newCouponsTableView;
    AppendableVideoMaker *videoMaker;
}

@property (nonatomic, strong) UIScrollView *myScroll;

@end
