//
//  ViewController.h
//  MapSample
//
//  Created by sana sajwan on 05/09/19.
//  Copyright © 2019 mine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;

}


@end

