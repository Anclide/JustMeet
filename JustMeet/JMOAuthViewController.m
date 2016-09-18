//
//  JMOAuthViewController.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMOAuthViewController.h"
#import <AFMInfoBanner.h>
#import "JMNetManager.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface JMOAuthViewController ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *loginView;

@end

@implementation JMOAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _loginView.delegate = self;
    NSString *url = [NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=%@&display=mobile&redirect_uri=https://oauth.vk.com/blank.html&scope=offline,friends&response_type=token&v=5.53", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"APP_ID"]];
    NSURL *address = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:address];
    [_loginView loadRequest:request];
    //NSLog(@"%@", url);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //NSLog(@"%@", _loginView.request.URL.absoluteString);
    if ([_loginView.request.URL.absoluteString rangeOfString:@"access_token"].location != NSNotFound) {
        [SVProgressHUD show];
        NSString *accessToken = _loginView.request.URL.absoluteString;
        
        NSRange idRange = [accessToken rangeOfString:@"user_id="];
        
        NSString *userId = [accessToken substringFromIndex:idRange.location+8];
        
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^https:\/\/oauth.vk.com\/blank.html#access_token=(.+?)&expires_in=[0-9]*&user_id=[0-9]*$"
                                                                               options:0
                                                                                 error:nil];
        NSTextCheckingResult *result = [regex firstMatchInString:accessToken
                                                         options:NSAnchoredSearch
                                                           range:NSMakeRange(0, accessToken.length)];
        NSRange tokenRange = [result rangeAtIndex:1];
        accessToken = [accessToken substringWithRange:tokenRange];
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[JMNetManager sharedManager] setToken:accessToken];
        
        [[JMNetManager sharedManager] fetchUserInfoWithId:userId andCompletion:^(NSDictionary *dict, NSError *err) {
            if (err) {
                [SVProgressHUD dismiss];
                [AFMInfoBanner showAndHideWithText:err.localizedDescription style:AFMInfoBannerStyleError];
            } else {
                
            }
        }];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] isEqualToString:[[JMNetManager sharedManager] token]]) {
            [SVProgressHUD dismiss];
            UIStoryboard *enterStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIWindow* window = [[UIApplication sharedApplication] keyWindow];
            window.rootViewController = [enterStoryboard instantiateViewControllerWithIdentifier:@"TabBar"];
            [window makeKeyAndVisible];
            [AFMInfoBanner showAndHideWithText:@"Успешная авторизация" style:AFMInfoBannerStyleInfo];
        }
        NSLog(@"token: %@", accessToken);
    } else {
        
    }
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@", error);
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
