//
//  JMEventCreateViewController.m
//  JustMeet
//
//  Created by Victor Bogatyrev on 14.09.16.
//  Copyright © 2016 Victor Bogatyrev. All rights reserved.
//

#import "JMEventCreateViewController.h"
#import "JMFriendPickerViewController.h"
#import "JMMeeting.h"
#import "JMNetManager.h"
#import <AFMInfoBanner.h>
#import "ZRFlatButton.h"
#import <GoogleMaps/GoogleMaps.h>

@interface JMEventCreateViewController () <UIImagePickerControllerDelegate, JMFriendPickerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIButton *friendButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic) UILabel *addressLabel;

@property (strong, nonatomic) UIImage *meetingImage;
@property (strong, nonatomic) NSArray *invitedFriends;
@property (nonatomic) CLLocationCoordinate2D location;
@property (retain, nonatomic) CLLocationManager *locationManager;

@end

@implementation JMEventCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMap];
    [self setupUi];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)imageTapped:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {}];
    UIAlertAction *chooseImage = [UIAlertAction actionWithTitle:@"Выбрать изображение" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    UIAlertAction *makePhoto = [UIAlertAction actionWithTitle:@"Сделать Фото" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            imagePicker.showsCameraControls = YES;
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {// The device doesn't have a camera, so use something like the photos album
            
        }
        
    }];
    
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:chooseImage];
    [actionSheet addAction:makePhoto];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        _meetingImage = [info objectForKey:UIImagePickerControllerEditedImage];
        [_imageButton setImage:_meetingImage forState:UIControlStateNormal];
        
    }];
}

- (void)setFriends:(NSArray *)array {
    _invitedFriends = array;
    if (array.count > 0) {
        [_friendButton setImage:nil forState:UIControlStateNormal];
        [_friendButton setTitle:[NSString stringWithFormat:@"%lu", (unsigned long)_invitedFriends.count] forState:UIControlStateNormal];
        _friendButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:40];
    } else {
        [_friendButton setTitle:nil forState:UIControlStateNormal];
        [_friendButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    }
}

- (IBAction)createButtonTapped:(id)sender {
    if (!_nameField.text || !_phoneField.text || !_addressField.text || !_descriptionField.text || !_meetingImage || _invitedFriends.count == 0) {
        [AFMInfoBanner showAndHideWithText:@"Заполните все поля" style:AFMInfoBannerStyleError];
    } else {
        JMMeeting *event = [[JMMeeting alloc] init];
        event.creator = [[JMNetManager sharedManager] userModel];
        event.creationDate = [NSDate date];
        event.counters = _invitedFriends;
        event.image = _meetingImage;
        event.name = _nameField.text;
        event.meetDescription = _descriptionField.text;
        event.phone = _phoneField.text;
        event.address = _addressField.text;
        event.meetId = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
        event.longitude = [NSNumber numberWithFloat:_location.longitude];
        event.latitude = [NSNumber numberWithFloat:_location.latitude];
        _location = CLLocationCoordinate2DMake(0.0, 0.0);
        if (!event.longitude && !event.latitude) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:_addressField.text completionHandler:^(NSArray* placemarks, NSError* error){
                for (CLPlacemark* aPlacemark in placemarks)
                {
                    // Process the placemark.
                    event.longitude = [NSNumber numberWithFloat:aPlacemark.location.coordinate.longitude];
                    event.latitude = [NSNumber numberWithFloat:aPlacemark.location.coordinate.latitude];
                }
            }];
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        if ([NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"events"]]) {
            arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"events"]];
        }
        //arr = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"events"]];
        [arr addObject:event];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"events"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"events"]) {
            [AFMInfoBanner showAndHideWithText:@"Событие успешно создано" style:AFMInfoBannerStyleInfo];
            [self resignFirstResponder];
        }
    }
}

- (void)setupUi {
    _imageButton.layer.cornerRadius = _friendButton.layer.cornerRadius = _imageButton.frame.size.height/2 - 56;
    _imageButton.layer.masksToBounds = _friendButton.layer.masksToBounds = NO;
    _imageButton.clipsToBounds = _friendButton.clipsToBounds = YES;
}

- (IBAction)markerTapped:(id)sender {
    _mapView.hidden = NO;
}

- (IBAction)chooseAddress:(id)sender {
    _addressField.text = _addressLabel.text;
    _location = _mapView.camera.target;
    _mapView.hidden = YES;
    [_locationManager stopUpdatingLocation];
}

- (void)setupMap {
    ZRFlatButton *but = [[ZRFlatButton alloc] initWithFrame:CGRectMake(0, 30, 100, 40)];
    but.fbuttonType = 2;
    [but setTitle:@"Выбрать адрес" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(chooseAddress:) forControlEvents:UIControlEventTouchUpInside];
    but.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_mapView addSubview:but];
    
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:but
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_mapView
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:-20]];
    [but addConstraint:[NSLayoutConstraint constraintWithItem:but
                                                    attribute:NSLayoutAttributeHeight
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil
                                                    attribute:NSLayoutAttributeHeight
                                                   multiplier:1
                                                     constant:40]];
    [but addConstraint:[NSLayoutConstraint constraintWithItem:but
                                                    attribute:NSLayoutAttributeWidth
                                                    relatedBy:NSLayoutRelationEqual
                                                       toItem:nil
                                                    attribute:NSLayoutAttributeWidth
                                                   multiplier:1
                                                     constant:self.view.frame.size.width/2]];
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:but
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_mapView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:17];
    _addressLabel.backgroundColor = [UIColor whiteColor];
    _addressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.numberOfLines = 0;
    _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _addressLabel.text = @"Адрес места встречи";
    [_mapView addSubview:_addressLabel];
    
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_mapView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:30]];
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_mapView
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1
                                                          constant:32]];
    
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_mapView
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1
                                                          constant:-32]];
    [_addressLabel addConstraint:[NSLayoutConstraint constraintWithItem:_addressLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1 constant:30]];
    
    UIImage *marker = [UIImage imageNamed:@"marker"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.translatesAutoresizingMaskIntoConstraints = NO;
    [imgView setImage:marker];
    [_mapView addSubview:imgView];
    
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:imgView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_mapView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0]];
    
    [_mapView addConstraint:[NSLayoutConstraint constraintWithItem:imgView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_mapView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:-40]];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    _mapView.settings.myLocationButton = YES;
    _mapView.camera = [GMSCameraPosition cameraWithTarget:_locationManager.location.coordinate zoom:17];
    
    
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    GMSGeocoder *geo = [[GMSGeocoder alloc] init];
    [geo reverseGeocodeCoordinate:mapView.camera.target completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSAddress *address = [response firstResult];
        _addressLabel.text = address.thoroughfare;
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"friendSegue"]) {
        JMFriendPickerViewController *toVc = [segue destinationViewController];
        toVc.delegate = self;
        if (_invitedFriends.count > 0) {
            toVc.selectedFriends = [[NSMutableArray alloc] initWithArray:_invitedFriends];
        }
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
