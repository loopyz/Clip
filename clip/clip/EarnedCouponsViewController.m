//
//  EarnedCouponsViewController.m
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "EarnedCouponsViewController.h"

#import <Parse/Parse.h>

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface EarnedCouponsViewController ()

@end

@implementation EarnedCouponsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.coupons = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;
    
    
    // do querying
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    if ([PFUser currentUser]) {
        [query whereKey:@"creator" equalTo:[PFUser currentUser]];
    }
    [query whereKeyExists:@"campaign"];
    [query whereKeyDoesNotExist:@"used"];
    [query includeKey:@"campaign"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            self.coupons = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
        } else {
            NSLog(@"some error at querying for won coupons");
        }
        
    }];
    self.myPTR = [[PullToRefresh alloc] initWithNumberOfDots:5];
    self.myPTR.delegate = self;
    [self.view addSubview:self.myPTR];
    
    
    // Do any additional setup after loading the view.
    if (!expandedSections)
    {
        expandedSections = [[NSMutableIndexSet alloc] init];
    }
}

- (void) refreshView
{
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    if ([PFUser currentUser]) {
        [query whereKey:@"creator" equalTo:[PFUser currentUser]];
    }
    [query whereKeyExists:@"campaign"];
    [query whereKeyDoesNotExist:@"used"];
    [query includeKey:@"campaign"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects && !error) {
            self.coupons = [[NSMutableArray alloc] initWithArray:objects];
            [self.tableView reloadData];
        } else {
            NSLog(@"some error at querying for won coupons");
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    [self.myPTR viewDidScroll:scrollView];
}

- (void)Refresh {
    // Perform here the required actions to refresh the data (call a JSON API for example).
    // Once the data has been updated, call the method isDoneRefreshing:
    [self.myPTR isDoneRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Expanding

- (BOOL)tableView:(UITableView *)tableView canCollapseSection:(NSInteger)section
{
    return YES;
    //if (section>0) return YES;
    
    //return NO;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.coupons count]; //actual number of coupons
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self tableView:tableView canCollapseSection:section])
    {
        if ([expandedSections containsIndex:section])
        {
            return 2; // return rows when expanded
        }
        
        return 1; // only top row showing
    }
    return 1;//25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{   if (indexPath.row % 2 == 0)
    return 100;
else return 150;
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    PFObject *coupon = [self.coupons[indexPath.row] objectForKey:@"campaign"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
        if ([self tableView:tableView canCollapseSection:indexPath.section])
        {
            if (!indexPath.row)
            {
                //setup name label
                UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
                UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(98, 5, 300, 50)];
                [name setTextColor:nameColor];
                [name setBackgroundColor:[UIColor clearColor]];
                [name setFont:[UIFont fontWithName:@"Avenir" size:24]];
                
                
                name.text = [coupon objectForKey:@"title"];//@"Free Breadsticks";
                [cell addSubview:name];
                name.tag = 101;
                //setup expiration
                UIColor *expColor = [UIColor colorWithRed:249/255.0f green:24/255.0f blue:95/255.0f alpha:1.0f];
                UILabel *exp = [[UILabel alloc] initWithFrame:CGRectMake(98, 30, SCREEN_WIDTH - 120, 50)];
                [exp setTextColor:expColor];
                [exp setBackgroundColor:[UIColor clearColor]];
                [exp setFont:[UIFont fontWithName:@"Avenir" size:13]];
                
                exp.text = [NSString stringWithFormat:@"EXP: %@", [coupon objectForKey:@"expiration"]];//@"EXP: 7/17/14";
                exp.tag = 102;
                exp.lineBreakMode = NSLineBreakByWordWrapping;
                exp.numberOfLines = 0;
                [cell addSubview:exp];
                
                //setup description
                UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
                UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(98, 50, SCREEN_WIDTH - 120, 50)];
                [desc setTextColor:descColor];
                [desc setBackgroundColor:[UIColor clearColor]];
                [desc setFont:[UIFont fontWithName:@"Avenir" size:11]];
                
                desc.text = [coupon objectForKey:@"description"];//@"Offer good at any Pizza Hut in the US.";
                desc.tag = 103;
                desc.lineBreakMode = NSLineBreakByWordWrapping;
                desc.numberOfLines = 0;
                [cell addSubview:desc];
                
                
                //setup logo
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 58.5, 60)];
                //imgView.image = [UIImage imageNamed:@"pizzahut.png"];
                //setup logo
               
                if (indexPath.row % 4 == 0) {
                    imgView.image = [UIImage imageNamed:@"pizzahut.png"];
                }
                else if (indexPath.row % 4 == 1) {
                    imgView.image = [UIImage imageNamed:@"partyhat.png"];
                }
                else if (indexPath.row %4  == 2) {
                    imgView.image = [UIImage imageNamed:@"present.png"];
                }
                else if (indexPath.row %4 == 3) {
                    imgView.image = [UIImage imageNamed:@"popcorn.png"];
                }

                [cell addSubview:imgView];
            }
            else
            {
                // all other rows
                cell.accessoryView = nil;
                cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"qrbg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                cell.selectedBackgroundView =  [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"qrbg.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 247.5)/2, 27, 247.5, 91.5)];
                imgView.image = [UIImage imageNamed:@"qrborder.png"];
                [cell addSubview:imgView];
                
                UIImageView *tempQR = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 242)/2, 32, 242, 83.5)];
                tempQR.image = [UIImage imageNamed:@"tempqr.png"];
                [cell addSubview:tempQR];
                
            }
        }
        else
        {
            cell.accessoryView = nil;
            cell.textLabel.text = @"Normal Cell";
            
        }
        
    }
    
    // Configure the cell...
    
    UILabel *name = (UILabel *) [cell.contentView viewWithTag:101];
    name.text = [coupon objectForKey:@"title"];
    
    UILabel *exp = (UILabel *) [cell.contentView viewWithTag:102];
    exp.text = [NSString stringWithFormat:@"EXP: %@", [coupon objectForKey:@"expiration"]];
    UILabel *desc = (UILabel *) [cell.contentView viewWithTag:103];
    desc.text = [coupon objectForKey:@"description"];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self tableView:tableView canCollapseSection:indexPath.section])
    {
        if (!indexPath.row)
        {
            [self.tableView beginUpdates];
            
            // only first row toggles exapand/collapse
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            NSInteger section = indexPath.section;
            BOOL currentlyExpanded = [expandedSections containsIndex:section];
            NSInteger rows;
            
            NSMutableArray *tmpArray = [NSMutableArray array];
            
            if (currentlyExpanded)
            {
                rows = [self tableView:tableView numberOfRowsInSection:section];
                [expandedSections removeIndex:section];
                
            }
            else
            {
                [expandedSections addIndex:section];
                rows = [self tableView:tableView numberOfRowsInSection:section];
            }
            
            for (int i=1; i<rows; i++)
            {
                NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:section];
                [tmpArray addObject:tmpIndexPath];
            }
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (currentlyExpanded)
            {
                [tableView deleteRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                
                //                cell.backgroundColor = [UIColor clearColor];
                
            }
            else
            {
                [tableView insertRowsAtIndexPaths:tmpArray
                                 withRowAnimation:UITableViewRowAnimationTop];
                //                cell.backgroundColor = [UIColor redColor];
                
            }
            
            [self.tableView endUpdates];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    PFObject *coupon = self.coupons[indexPath.row];
    [coupon setObject:@true forKey:@"used"];
    [coupon saveInBackground];
    [self.coupons removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    NSLog(@"Deleted row.");
}


@end