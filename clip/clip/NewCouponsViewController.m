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
        [self addProfile];
    }
    return self;
}



- (void)addProfile
{
    //add background
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, 321, 115)];
    
    imgView.image = [UIImage imageNamed:@"profile.png"];
    [self.myScroll addSubview:imgView];
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
- (IBAction)makeVideo:(id)sender
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *createGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [createGameButton setTitle:@"Make Video" forState:UIControlStateNormal];
    [createGameButton addTarget:self action:@selector(makeVideo:) forControlEvents:UIControlEventTouchUpInside];
    createGameButton.frame = CGRectMake(10, 50, 100, 40);
    [self.view addSubview:createGameButton];
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

//Header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 50)];
    
    //setup recent label
    UIColor * color = [UIColor colorWithRed:41/255.0f green:178/255.0f blue:177/255.0f alpha:1.0f];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 20)];
    

    [name setTextColor:color];
    [name setBackgroundColor:[UIColor clearColor]];
    [name setFont:[UIFont fontWithName:@"HelveticaNeue" size:22]];
    
    name.text = @"Lucy Guo";
    [view addSubview:name];
    
    //setup clear
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}

//for each cell in table
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    cell.textLabel.text = @"meowwww";
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // blah
}


@end
