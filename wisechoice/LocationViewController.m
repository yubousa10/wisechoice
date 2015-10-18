//
//  LocationViewController.m
//  wisechoice
//
//  Created by boyu on 15/10/16.
//  Copyright © 2015年 boyu. All rights reserved.
//

#import "LocationViewController.h"


@interface LocationViewController ()
@property(nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.locationManager startUpdatingLocation];
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currLocation = [locations lastObject];
    UILabel *lat = (UILabel*)[self.view viewWithTag:101];
    UILabel *lng = (UILabel*)[self.view viewWithTag:102];
    UILabel *lalt = (UILabel*)[self.view viewWithTag:103];
    lat.text = [NSString stringWithFormat:@"%3.5f",currLocation.coordinate.latitude];
    lng.text = [NSString stringWithFormat:@"%3.5f",currLocation.coordinate.longitude];
    lalt.text = [NSString stringWithFormat:@"%3.5f",currLocation.altitude];

}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Authorized");
    }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
         NSLog(@"AuthorizedWhenInuse");
    }else if (status == kCLAuthorizationStatusDenied){
        NSLog(@"Denied");
    }else if (status == kCLAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }else if (status == kCLAuthorizationStatusNotDetermined){
        NSLog(@"NotDetermined");
    }
}
@end
