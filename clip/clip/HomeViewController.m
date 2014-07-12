//
//  HomeViewController.m
//  clip
//
//  Created by Lucy Guo on 7/11/14.
//  Copyright (c) 2014 Niveditha Jayasekar. All rights reserved.
//

#import "HomeViewController.h"
#import "NewCouponsViewController.h"
#import "EarnedCouponsViewController.h"
#import "NewsFeedViewController.h"
#import "ProfileViewController.h"

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.bgColor = [UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
        [self modifyBackground];
        [self initNavBar];
        [self setupTabBars];
        
        
    }
    return self;
}

- (void)initNavBar
{
    [self.navigationController.navigationBar setTranslucent:NO];
        
    UIBarButtonItem *lbb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchicon.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(launchAddGameView)];
    
    lbb.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = lbb;
    
    // Logo in the center of navigation bar
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 43.5, 30)];
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navlogo.png"]];
    titleImageView.frame = CGRectMake(0, 0, titleImageView.frame.size.width/2, titleImageView.frame.size.height/2);
    [logoView addSubview:titleImageView];
    self.navigationItem.titleView = logoView;
    
    
    // Right bar button item to launch the categories selection screen.
    UIBarButtonItem *rbb = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settigsicon.png"]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(launchAddGameView)];
    
    rbb.tintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = rbb;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self assignTabColors];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)modifyBackground
{
    self.view.backgroundColor = self.bgColor;
}

#pragma mark - UITabBarController Methods

- (void)setupTabBars
{
    NewCouponsViewController *nvc = [[NewCouponsViewController alloc]initWithNibName:nil bundle:nil];
    nvc.tabBarItem.image = [UIImage imageNamed:@"hometab.png"];
    
    EarnedCouponsViewController *evc = [[EarnedCouponsViewController alloc] initWithNibName:nil bundle:nil];
    evc.tabBarItem.image = [UIImage imageNamed:@"coupontab.png"];
    
    NewsFeedViewController *nfvc = [[NewsFeedViewController alloc] initWithNibName:nil bundle:nil];
    nfvc.tabBarItem.image = [UIImage imageNamed:@"newstab.png"];
    
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithNibName:nil bundle:nil];
    pvc.tabBarItem.image = [UIImage imageNamed:@"profiletab.png"];
    
    
    self.viewControllers=[NSArray arrayWithObjects:nvc, evc, nfvc, pvc, nil];
}

- (void)assignTabColors
{
    switch (self.selectedIndex) {
        case 0: {
            UIColor * color = [UIColor colorWithRed:149/255.0f green:25/255.0f blue:48/255.0f alpha:1.0f];
            self.view.tintColor = color;
            break;
        }
            
        default:
            break;
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self assignTabColors];
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
