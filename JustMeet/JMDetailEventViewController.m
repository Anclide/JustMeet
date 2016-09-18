//
//  JMDetailEventViewController.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 16.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMDetailEventViewController.h"
#import "JMMeeting.h"
#import "JMNetManager.h"
#import "JMUser.h"
#import <AFMInfoBanner/AFMInfoBanner.h>
#import "JMInvitedTableViewController.h"

@interface JMDetailEventViewController ()
{
    NSArray *counters;
}

//@property (nonatomic, weak) IBOutlet UIView *blur;

@end

@implementation JMDetailEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    _detailImageview.layer.cornerRadius = 60;
    _detailImageview.layer.masksToBounds = YES;
    if ([self isHighter]) {
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        [_backgroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    [_backgroundImageView setImage:_event.image];
    [_detailImageview setImage:_event.image];
    _nameLabel.text = _event.name;
    _addressLabel.text = _event.address;
    _phoneLabel.text = _event.phone;
    _descriptionLabel.text = _event.meetDescription;
    counters = _event.counters;
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = CGRectMake(0, 0, _backgroundImageView.frame.size.width, _backgroundImageView.frame.size.height + 68);
        //blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        //_blur = blurEffectView;
        //[_backgroundImageView addSubview:blurEffectView];
    } else {
        self.view.backgroundColor = [UIColor blackColor];
    }
}

- (BOOL)isHighter {
    if (_event.image.size.height/_event.image.size.width > self.view.frame.size.height/self.view.frame.size.width) {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)joinEvent:(id)sender {
    if ([[[[JMNetManager sharedManager] userModel] userId] isEqualToNumber:_event.creator.userId]) {
        [AFMInfoBanner showAndHideWithText:@"Вы являетесь создателем" style:AFMInfoBannerStyleError];
    } else {
        [AFMInfoBanner showAndHideWithText:@"Вы успешно присоединились" style:AFMInfoBannerStyleInfo];
    }
}

- (IBAction)showCounters:(id)sender {
    [self performSegueWithIdentifier:@"kek" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"kek"]) {
        JMInvitedTableViewController *toVc = [segue destinationViewController];
        toVc.friends = _event.counters;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
