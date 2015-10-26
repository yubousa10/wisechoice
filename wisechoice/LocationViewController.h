//
//  LocationViewController.h
//  wisechoice
//
//  Created by boyu on 15/10/16.
//  Copyright © 2015年 boyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BZFoursquare.h"



@interface LocationViewController : UIViewController<CLLocationManagerDelegate,BZFoursquareRequestDelegate,BZFoursquareSessionDelegate>
@property(nonatomic,readonly,strong) BZFoursquare *foursquare;
@end
