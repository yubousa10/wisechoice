//
//  LocationViewController.m
//  wisechoice
//
//  Created by boyu on 15/10/16.
//  Copyright © 2015年 boyu. All rights reserved.
//

#import "LocationViewController.h"

#define kClientID       FOURSQUARE_CLIENT_ID
#define kCallbackURL    FOURSQUARE_CALLBACK_URL
#define kClientSecret    FOURSQUARE_CLIENT_SECRET

@interface LocationViewController ()
@property(nonatomic,strong) CLLocationManager *locationManager;


@property(nonatomic,readwrite,strong) BZFoursquare *foursquare;
@property(nonatomic,strong) BZFoursquareRequest *request;
@property(nonatomic,copy) NSDictionary *meta;
@property(nonatomic,copy) NSArray *notifications;
@property(nonatomic,copy) NSDictionary *response;
@property(nonatomic,readwrite,copy) id JSONObject;

@end

@implementation LocationViewController

- (CLLocationManager *)locationManager{
    if(!_locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    
    self.foursquare = [[BZFoursquare alloc]initWithClientID:kClientID callbackURL:kCallbackURL];
    [self.foursquare setClientSecret:FOURSQUARE_CLIENT_SECRET];
    [self.foursquare setVersion:@"20130815"];
    [self.foursquare setLocale:[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]];
    [self.foursquare setSessionDelegate:self];

}
//for the foursquare

#pragma mark -
#pragma mark BZFoursquareRequestDelegate


- (void)venuesSearchLat:(NSString*)lat venuesSearchLng:(NSString*)lng {
    NSDictionary *parameters = @{@"ll": [[lat stringByAppendingString:@","] stringByAppendingString:lng]};
    self.request = [_foursquare userlessRequestWithPath:@"venues/search" HTTPMethod:@"GET" parameters:parameters delegate:self];
    [_request start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)requestDidFinishLoading:(BZFoursquareRequest *)request {
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.JSONObject = request.response;
    NSLog(@"%@",self.JSONObject);
    self.request = nil;
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)request:(BZFoursquareRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[error userInfo][@"errorDetail"] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
    [alertView show];
    self.meta = request.meta;
    self.notifications = request.notifications;
    self.response = request.response;
    self.request = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark BZFoursquareSessionDelegate

- (void)foursquareDidAuthorize:(BZFoursquare *)foursquare {

}

- (void)foursquareDidNotAuthorize:(BZFoursquare *)foursquare error:(NSDictionary *)errorInfo {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, errorInfo);
}


//for the location
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
    //NSLog(@"%@",lat.text);
    lng.text = [NSString stringWithFormat:@"%3.5f",currLocation.coordinate.longitude];
   // NSLog(@"%@",lng.text);
    
    [self venuesSearchLat:lat.text venuesSearchLng:lng.text];
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
