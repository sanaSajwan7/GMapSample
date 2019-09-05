//
//  ViewController.m
//  MapSample
//
//  Created by sana sajwan on 05/09/19.
//  Copyright © 2019 mine. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (strong, nonatomic) GMSMarker *marker, *destination;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _marker = [[GMSMarker alloc] init];
    _destination = [[GMSMarker alloc] init];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- PATHSETTING
-(void) drawPath: (CLLocation*) currentLocation{
    CLLocation *destination = [[CLLocation alloc] initWithLatitude:30.742138 longitude:76.818756];
    if(_marker.map != nil){
        _marker.map = nil;
        self.marker.position = currentLocation.coordinate;
        self.marker.title = @"curentLocation";
        //   self.marker.snippet = @"India";
        self.marker.map = _mapView;
    }
    if(_destination.map != nil){
    _marker.map = nil;
    }
    self.destination.position = destination.coordinate;
    self.destination.title = @"chandigarh";
    //   self.marker.snippet = @"India";
    self.destination.map = _mapView;

    NSArray *markerList = [[NSArray alloc] initWithObjects:_marker, _destination, nil];
//    NSMutableArray *markers = [[NSMutableArray alloc] init];
//    [markers addObject:_marker];
//    [markers addObject:_destination];
    
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    
    for (GMSMarker *marker in markerList)
        bounds = [bounds includingCoordinate:marker.position];
    
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];


    NSString *sendtourl=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f,&destination=30.742138,76.818756&mode=driving&key=AIzaSyDsJGAtOSMaG-A_1ea_dS6L84OXiFUWBuk",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:sendtourl];    /* Fire the request */
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection
     sendAsynchronousRequest:request
     queue:[NSOperationQueue mainQueue]
     completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
         if (data.length > 0 && connectionError == nil) {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
             if([json[@"status"]  isEqual: @"REQUEST_DENIED"]){
//             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:json[@"status"] message:json[@"error_message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//             [alert show];
                 UIAlertController* alert = [UIAlertController alertControllerWithTitle:json[@"status"] message:json[@"error_message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                 
                 [alert addAction:defaultAction];
                 [self presentViewController:alert animated:YES completion:nil];
             }
             NSLog(@"BILLING INFORMATION REQUIRED SO UNABLE TO COMPLETE IT");

         }
     }];
    //   Alamofire.request(url!).responseJSON{(responseData) -> Void in
    //        if((responseData.result.value) != nil) {
    //            /* read the result value */
    //            let swiftyJsonVar = JSON(responseData.result.value!)
    //            /* only get the routes object */
    //            if let resData = swiftyJsonVar["routes"].arrayObject {
    //                let routes = resData as! [[String: AnyObject]]
    //                /* loop the routes */
    //                if routes.count > 0 {
    //                    for rts in routes {
    //                        /* get the point */
    //                        let overViewPolyLine = rts["overview_polyline"]?["points"]
    //                        let path = GMSMutablePath(fromEncodedPath: overViewPolyLine as! String)
    //                        /* set up poly line */
    //                        let polyline = GMSPolyline.init(path: path)
    //                        polyline.strokeWidth = 2
    //                        polyline.map = self.mapView
    //                    }
    //                }
    //            }
    //        }
    //    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
            
                //             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:json[@"status"] message:json[@"error_message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //             [alert show];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Please enable location from setting" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
//    NSLog(@"%f", currentLocation.coordinate.latitude);
//    NSLog(@"%f", currentLocation.coordinate.longitude);
    if(currentLocation != nil && _marker.map == nil){
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:10];

        [_mapView animateToCameraPosition:camera];
        // Creates a marker in the center of the map.
        self.marker.position = currentLocation.coordinate;
        self.marker.title = @"curentLocation";
     //   self.marker.snippet = @"India";
        self.marker.map = _mapView;
        [self drawPath:currentLocation];

    }

}

@end
