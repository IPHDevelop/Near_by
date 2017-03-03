//
//  MapViewController.m
//  SimlpeNear
//
//  Created by Admini on 1/22/17.
//  Copyright © 2017 Admini. All rights reserved.
//

#import "MapViewController.h"
#import <Foundation/Foundation.h>
#import "PrefixHeader.pch"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapview;
@property (weak, nonatomic) IBOutlet UILabel *cur_title;
@property (weak,nonatomic) IBOutlet UILabel *cur_subtitle;
@property (weak,nonatomic) IBOutlet UILabel *cur_position;
@property (weak,nonatomic) IBOutlet UILabel *cur_distance;
@property (strong,nonatomic) NSArray *region;
@property (strong,nonatomic) NSMutableArray *arr_title;
@property (strong,nonatomic) NSMutableArray *arr_subtitle;
@property (strong,nonatomic) NSMutableArray *arr_coordination;
@property (strong,nonatomic) MKUserLocation *my_user_location;
@property (weak, nonatomic) IBOutlet UIView *dropview;

@property(nonatomic,strong)IBOutlet UIImageView *imgOnOff;



@property(nonatomic,strong)IBOutlet CLLocationManager *locationManager;
@end

@implementation MapViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *str_url=@"http://192.168.0.16/1/AEDs.json";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:str_url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        self.region=[responseObject objectForKey:@"aeds"];
        self.arr_title=[NSMutableArray arrayWithCapacity:self.region.count];
        self.arr_subtitle=[NSMutableArray arrayWithCapacity:self.region.count];
        self.arr_coordination=[NSMutableArray arrayWithCapacity:self.region.count];
        self.arr_coordination=[self.region valueForKey:@"geo"];
        self.arr_title=[self.region valueForKey:@"Installation"];
        self.arr_subtitle=[self.region valueForKey:@"ambulance"];
        NSLog(@"JSON: %@", self.arr_coordination);
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
   
    // JSON Data Pasing end
    
    if ([CLLocationManager locationServicesEnabled]) {
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            [self.locationManager requestWhenInUseAuthorization];
        
        [self.locationManager startUpdatingLocation];

    }
    [self.dropview setHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.01f;
    region.span.longitudeDelta = 0.01f;
    [self.mapview setRegion:region animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - MKMapView delegate

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"GrnPin"];
            pinView.calloutOffset = CGPointMake(0, 16);
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
    
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self.dropview setHidden:NO];
    MKPointAnnotation *annotation= (MKPointAnnotation *)view.annotation;
    self.cur_title.text=annotation.title;
    self.cur_subtitle.text=annotation.subtitle;
    self.cur_position.text=[NSString stringWithFormat:@"%f/%f",annotation.coordinate.latitude,annotation.coordinate.longitude];
    [self.cur_position setTextColor:[UIColor redColor]];
    
    
    view.image = [UIImage imageNamed:@"GrnPinSel"];
    self.imgOnOff.image = [UIImage imageNamed:@"Open"];
   
    CLLocation *initial_location=[[CLLocation alloc] initWithLatitude:self.my_user_location.coordinate.latitude longitude:self.my_user_location.coordinate.longitude];
    CLLocation *sel_location=[[CLLocation alloc] initWithLatitude:annotation.coordinate.latitude longitude:annotation.coordinate.longitude];
    CLLocationDistance distance=[initial_location distanceFromLocation:sel_location];
    [self.cur_distance setText:[NSString stringWithFormat:@"%f",distance]];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    view.image = [UIImage imageNamed:@"GrnPin"];
}


#pragma mark - CLLocationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Latitude :%f", newLocation.coordinate.latitude);
    NSLog(@"Longitude :%f", newLocation.coordinate.longitude);
    
    [manager stopUpdatingLocation];
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError:%@", error);
}




- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    self.my_user_location=userLocation;
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"My Location";
    point.subtitle = @"This is my GPS position";

    self.mapview.showsUserLocation=YES;
    [self.cur_title setText:userLocation.title];
    [self.cur_subtitle setText:userLocation.subtitle];
    [self.cur_position setText:[NSString stringWithFormat:@"%f/%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude]];
    

    for(int i = 0; i<self.region.count;i++)
    {
        NSArray *arr_coordnate = [self.arr_coordination[i] componentsSeparatedByString:@","];
        CLLocationCoordinate2D newCoord = {[[arr_coordnate objectAtIndex:0] floatValue],[[arr_coordnate objectAtIndex:1] floatValue] };
        MKPointAnnotation *annotation=[[MKPointAnnotation alloc] init];
        annotation.coordinate=newCoord;
        annotation.title=self.arr_title[i];
        annotation.subtitle=self.arr_subtitle[i];
        [self.mapview addAnnotation:annotation];
        NSLog(@"x=   %f  y=   %f",[[arr_coordnate objectAtIndex:0] floatValue],[[arr_coordnate objectAtIndex:1] floatValue]);
    
    }
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 20000, 20000);
    [self.mapview setRegion:[self.mapview regionThatFits:region] animated:YES];
    [self.mapview setCenterCoordinate:userLocation.coordinate animated:YES];
    
}

- (IBAction)onArrowBtn:(id)sender {
    [self.dropview setHidden:YES];
}

-(IBAction)oncenter:(id)sender{
    [self.mapview setCenterCoordinate:self.my_user_location.coordinate animated:YES];
}
@end
