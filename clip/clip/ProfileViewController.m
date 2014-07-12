//
//  ProfileViewController.m
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "ProfileViewController.h"
#import "KSVideoPlayerView.h"

#import <MediaPlayer/MediaPlayer.h>
#import <Parse/Parse.h>
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFQuery *query = [PFQuery queryWithClassName:@"Video"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            PFFile *videoFile = [object objectForKey:@"file"];
            NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
            self.player = [[KSVideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 280) contentURL:fileUrl];
            [self.view addSubview:self.player];
            [self.player play];
            //MPMoviePlayerViewController *movie = [[MPMoviePlayerViewController alloc] initWithContentURL:fileUrl];
            //[self presentMoviePlayerViewControllerAnimated:movie];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
