//
//  NewCouponsViewController.m
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "NewCouponsViewController.h"
#import "PullToRefresh.h"
#import "AppendableVideoMaker.h"

#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface NewCouponsViewController () 

@end

@implementation NewCouponsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // [self addProfile];
        self.fbProfilePic = [[FBProfilePictureView alloc] init];
        
        self.view.backgroundColor = [UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
    }
    return self;
}

- (void) uploadVideo
{
    if (videoMaker && [videoMaker videoIsReady])
    {
        NSURL *videoURL = [videoMaker getVideoURL];
        // do something with the video ...
        NSData *fileData = [NSData dataWithContentsOfURL:[videoMaker getVideoURL]];
        NSString *fileName = @"video.mov";
        NSString *fileType = @"movie";
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"hey file no saving");
            } else {
                PFObject *video = [PFObject objectWithClassName:@"Video"];
                [video setObject:file forKey:@"file"];
                [video setObject:fileType forKey:@"fileType"];
                [video setObject:[PFUser currentUser] forKey:@"creator"];
                [video setObject:self.videoCampaign forKey:@"campaign"];
                [video saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@"hey video object no saving");
                    } else {
                        NSLog(@"worked well");
                        //[self launchVideo];
                    }
                }];
            }
        }];
    }
}

- (void)videoMergeCompleteHandler:(NSNotification*)notification {
    NSLog(@"video merged successfully");
    [self uploadVideo];
}
- (IBAction)makeVideo
{
    NSLog(@"making video");
    videoMaker = [[AppendableVideoMaker alloc] init];
    if ([videoMaker deviceCanRecordVideos])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoMergeCompleteHandler:)
                                                     name:@"AppendableVideoMaker_VideoMergeComplete"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoMergeFailedHandler:)
                                                     name:@"AppendableVideoMaker_VideoMergeFailed"
                                                   object:nil];
        [self presentViewController:videoMaker animated:YES completion:^{}];
    }
}

- (void)addProfile
{
    
    self.fbProfilePic.backgroundColor = [UIColor blackColor];
    self.fbProfilePic.frame = CGRectMake(17, 23, 71, 71);
    
    //makes it into circle
    float width = self.fbProfilePic.bounds.size.width;
    self.fbProfilePic.layer.cornerRadius = width/2;
    
    [self.profileSnippetView addSubview:self.fbProfilePic];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.tableView.contentInset = inset;
//    UIEdgeInsets inset = UIEdgeInsetsMake(60, 0, 0, 0);
//    self.tableView.contentInset = inset;
//    
//    // Do any additional setup after loading the view.
//    
//    //setup pull to refresh
//    self.myPTR = [[PullToRefresh alloc] initWithNumberOfDots:5];
//    self.myPTR.delegate = self;
//    [self.view addSubview:self.myPTR];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    [self.myPTR viewDidScroll:scrollView];
}

// SETUP WHAT REFRESH DOES HERE
- (void)Refresh {
    NSLog(@"test");
    // Perform here the required actions to refresh the data (call a JSON API for example).
    // Once the data has been updated, call the method isDoneRefreshing:
    [self.myPTR isDoneRefreshing];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //number of alphabet letters + recent
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

//Header

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 115;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 115)];
    self.profileSnippetView = view;

    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result;
            
            if (![[PFUser currentUser] objectForKey:@"fbId"]) {
                [[PFUser currentUser] setObject:userData[@"id"] forKey:@"fbId"];
                [[PFUser currentUser] save];
            }
            self.userid = userData[@"id"];
            NSString *username = userData[@"name"];

            self.fbProfilePic.profileID = self.userid;
            //setup name label
            UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(98, 10, 300, 50)];
            
            
            [name setTextColor:nameColor];
            [name setBackgroundColor:[UIColor clearColor]];
            [name setFont:[UIFont fontWithName:@"Avenir" size:22]];
            
            name.text = username; //@"Lucy Guo";
            [self.profileSnippetView addSubview:name];
            [self addProfile];
        }
    }];
    
    
    
    //setup score, offers, and pending label
    UIColor *tinyLabelColor = [UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1.0f];
    
    UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(98, 70, 150, 50)];
    [score setTextColor:tinyLabelColor];
    [score setBackgroundColor:[UIColor clearColor]];
    [score setFont:[UIFont fontWithName:@"Avenir-Light" size:9]];
    score.text = @"Clip Score";
    
    UILabel *offers = [[UILabel alloc] initWithFrame:CGRectMake(190, 70, 150, 50)];
    [offers setTextColor:tinyLabelColor];
    [offers setBackgroundColor:[UIColor clearColor]];
    [offers setFont:[UIFont fontWithName:@"Avenir-Light" size:9]];
    offers.text = @"Offers";
    
    UILabel *pending = [[UILabel alloc] initWithFrame:CGRectMake(262, 70, 150, 50)];
    [pending setTextColor:tinyLabelColor];
    [pending setBackgroundColor:[UIColor clearColor]];
    [pending setFont:[UIFont fontWithName:@"Avenir-Light" size:9]];
    pending.text = @"Pending";
    
    UILabel *numScore = [[UILabel alloc] initWithFrame:CGRectMake(98, 50, 40, 50)];
    [numScore setTextColor:[UIColor colorWithRed:68/255.0f green:203/255.0f blue:154/255.0f alpha:1.0f]];
    [numScore setBackgroundColor:[UIColor clearColor]];
    numScore.textAlignment = NSTextAlignmentCenter;
    [numScore setFont:[UIFont fontWithName:@"Avenir-Light" size:22]];
    numScore.text = @"123";
    
    UILabel *numoffers = [[UILabel alloc] initWithFrame:CGRectMake(190, 50, 25, 50)];
    [numoffers setTextColor:[UIColor colorWithRed:105/255.0f green:32/255.0f blue:213/255.0f alpha:1.0f]];
    [numoffers setBackgroundColor:[UIColor clearColor]];
    numoffers.textAlignment = NSTextAlignmentCenter;
    [numoffers setFont:[UIFont fontWithName:@"Avenir-Light" size:22]];
    numoffers.text = @"8";
    
    UILabel *numPending = [[UILabel alloc] initWithFrame:CGRectMake(262, 50, 32, 50)];
    [numPending setTextColor:[UIColor colorWithRed:206/255.0f green:34/255.0f blue:155/255.0f alpha:1.0f]];
    [numPending setBackgroundColor:[UIColor clearColor]];
    numPending.textAlignment = NSTextAlignmentCenter;
    [numPending setFont:[UIFont fontWithName:@"Avenir-Light" size:22]];
    numPending.text = @"2";

    [view addSubview:score];
    [view addSubview:offers];
    [view addSubview:pending];
    
    [view addSubview:numScore];
    [view addSubview:numoffers];
    [view addSubview:numPending];
    

    
    view.backgroundColor = [UIColor whiteColor];
    
    
    return view;
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    //setup name label
    UIColor *nameColor = [UIColor colorWithRed:91/255.0f green:91/255.0f blue:91/255.0f alpha:1.0f];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(98, 5, 300, 50)];
    [name setTextColor:nameColor];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"Avenir" size:24]];
    
    name.text = @"Free Breadsticks";
    [cell addSubview:name];
    
    //setup description
    UIColor *descColor = [UIColor colorWithRed:136/255.0f green:136/255.0f blue:136/255.0f alpha:1.0f];
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(98, 43, SCREEN_WIDTH - 120, 50)];
    [desc setTextColor:descColor];
    [desc setBackgroundColor:[UIColor clearColor]];
    [desc setFont:[UIFont fontWithName:@"Avenir" size:10]];
    
    desc.text = @"Do you love free breadsticks? Do you like taking funny videos? Send us a funny video with a pizza joke and we'll give you some free breadsticks in return!";
    desc.lineBreakMode = NSLineBreakByWordWrapping;
    desc.numberOfLines = 0;
    [cell addSubview:desc];
    
    //setup logo
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 58.5, 60)];
    imgView.image = [UIImage imageNamed:@"pizzahut.png"];
    [cell addSubview:imgView];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self makeVideo];
    self.videoCampaign = @"This one";
    // blah
}


@end
