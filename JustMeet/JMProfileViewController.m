//
//  JMProfileViewController.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMProfileViewController.h"
#import "JMNetManager.h"
#import "JMUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface JMProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userCity;
@property (weak, nonatomic) IBOutlet UILabel *userFriendsCount;

@end

@implementation JMProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userImage.layer.cornerRadius = _userImage.frame.size.height/2;
    _userImage.layer.masksToBounds = NO;
    [self reloadData];
    // Do any additional setup after loading the view.
}

- (void)reloadData {
    JMUser *user = [[JMNetManager sharedManager] userModel];
    _userName.text = [NSString stringWithFormat:@"%@ %@", user.name, user.surname];
    _userCity.text = user.city;
    _userFriendsCount.text = user.bdate;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:user.photo200url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutTapped:(id)sender {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"events"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    window.rootViewController = [sb instantiateInitialViewController];
    [window makeKeyAndVisible];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
