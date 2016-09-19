//
//  JMListViewController.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMListViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "JMHeaderListCell.h"
#import "JMListBodyCell.h"
#import "JMListFooterCell.h"
#import "JMMeeting.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JMUser.h"
#import "JMDetailEventViewController.h"
#import <AFMInfoBanner.h>

static NSUInteger row;
@interface JMListViewController () <UITableViewDelegate, UITableViewDataSource, GMSMapViewDelegate>
{
    NSArray *meetings;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) JMMeeting *selectedEvent;
@property (strong, nonatomic) NSArray *meets;

@end

@implementation JMListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    [self setupMap];
    [self setupTable];
    // Do any additional setup after loading the view.
}
- (IBAction)segmentValueChanged:(id)sender {
    switch (_segmentedController.selectedSegmentIndex) {
        case 0:
            _mapView.hidden = YES;
            _table.hidden = NO;
            break;
        case 1:
            _mapView.hidden = NO;
            _table.hidden = YES;
        default:
            break;
    }
}

- (void)reloadData {
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"events"];
    _meets = [[NSArray alloc] init];
    _meets = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    meetings = _meets;
    [_table reloadData];
    [self reloadMarkers];
//    if (!meetings) {
//        [AFMInfoBanner showAndHideWithText:@"Нет встреч" style:AFMInfoBannerStyleError];
//    }
   
}

#pragma mark - Map

- (void)setupMap {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
    _mapView.camera = [GMSCameraPosition cameraWithTarget:_locationManager.location.coordinate zoom:17];
    
    [self reloadMarkers];
    
}

- (void)reloadMarkers {
    _mapView.camera = [GMSCameraPosition cameraWithTarget:_locationManager.location.coordinate zoom:17];
    for (JMMeeting *meet in meetings) {
        if (meet.longitude && meet.latitude) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            
            marker.position = CLLocationCoordinate2DMake([meet.latitude floatValue], [meet.longitude floatValue]);
            marker.userData = meet;
            marker.title = meet.name;
            marker.icon = [UIImage imageNamed:@"marker"];
            marker.map = _mapView;
        }
    }
}

-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    _selectedEvent = marker.userData;
    [self performSegueWithIdentifier:@"detailMeeting" sender:self];
}

#pragma mark - Table

- (void)setupTable {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Загрузка"];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refreshControl];
    [refreshControl.superview sendSubviewToBack:refreshControl];
    
    [self refresh:refreshControl];
    //_table.estimatedRowHeight = 60;
    //_table.rowHeight = UITableViewAutomaticDimension;
    [_table registerNib:[UINib nibWithNibName:@"JMHeaderListCell" bundle:nil] forCellReuseIdentifier:@"HeaderCell"];
    [_table registerNib:[UINib nibWithNibName:@"JMListBodyCell" bundle:nil] forCellReuseIdentifier:@"BodyCell"];
    [_table registerNib:[UINib nibWithNibName:@"JMListFooterCell" bundle:nil] forCellReuseIdentifier:@"FooterCell"];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self reloadData];
    [refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return meetings.count ? meetings.count : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedEvent = meetings[indexPath.section];
    [self performSegueWithIdentifier:@"detailMeeting" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row == 1) {
        return 200;
    } else {
        return 52;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMMeeting *meet = meetings[indexPath.section];
    if (indexPath.row == 0) {
        JMHeaderListCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
        [headerCell.creatorImageView sd_setImageWithURL:[NSURL URLWithString:meet.creator.photo200url]];
        headerCell.creatorName.text = [NSString stringWithFormat:@"%@ %@", meet.creator.name, meet.creator.surname];
        headerCell.meetingName.text = meet.name;
        headerCell.timeLabel.text = [self changeDateFormat:meet.creationDate];
        return headerCell;
    } else if (indexPath.row == 1) {
        JMListBodyCell *bodyCell = [tableView dequeueReusableCellWithIdentifier:@"BodyCell"];
        bodyCell.meetingImageView.image = meet.image;
        bodyCell.meetingAddress.text = meet.address;
        return bodyCell;
    } else {
        JMListFooterCell *footerCell = [tableView dequeueReusableCellWithIdentifier:@"FooterCell"];
        footerCell.likes.text = @"0";
        footerCell.comments.text = @"0";
        return footerCell;
    }
}

- (NSString *)changeDateFormat:(NSDate *)date {
    NSString *formattedDate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"RU"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    formattedDate = [dateFormatter stringFromDate:date];
    
    return formattedDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailMeeting"]) {
        JMDetailEventViewController *toVc = [segue destinationViewController];
        toVc.event = _selectedEvent;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
