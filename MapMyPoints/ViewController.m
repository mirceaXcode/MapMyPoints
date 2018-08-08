//
//  ViewController.m
//  MapMyPoints
//
//  Created by Mircea Popescu on 8/6/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKPointAnnotation *gemaltoAnno;
@property (strong, nonatomic) MKPointAnnotation *bigskybarAnno;
@property (strong, nonatomic) MKPointAnnotation *nycpizzaAnno;
@property (strong, nonatomic) MKPointAnnotation *currentAnno;

@property (weak, nonatomic) IBOutlet UISwitch *switchField;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager.delegate self];
    // Requesting user authorisation to allow the location + setting in info.plist -> NSLocationWhenInUseUsageDescription
    [self.locationManager requestWhenInUseAuthorization];
    
    [self addAnnotations];
    
    
}
- (IBAction)gemaltoTapped:(id)sender {
    [self centerMap:_gemaltoAnno];
}

- (IBAction)bigskyTapped:(id)sender {
    [self centerMap:_bigskybarAnno];
}

- (IBAction)nycpizzaTapped:(id)sender {
    [self centerMap:_nycpizzaAnno];
}

-(void) centerMap:(MKPointAnnotation *) centerPoint{
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}

- (IBAction)switchChanged:(id)sender {
    if (self.switchField.isOn){
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    } else {
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    
    [self centerMap:self.currentAnno];
}

-(void) addAnnotations{
    
    self.gemaltoAnno = [[MKPointAnnotation alloc] init];
    self.gemaltoAnno.coordinate = CLLocationCoordinate2DMake(30.388751,-97.7488101);
    self.gemaltoAnno.title = @"Gemalto office in Austin,TX";
    
    self.bigskybarAnno = [[MKPointAnnotation alloc] init];
    self.bigskybarAnno.coordinate = CLLocationCoordinate2DMake(45.2613924,-111.3194378);
    self.bigskybarAnno.title = @"Broken Spoke Bar in Big Sky,MT";
    
    self.nycpizzaAnno = [[MKPointAnnotation alloc] init];
    self.nycpizzaAnno.coordinate = CLLocationCoordinate2DMake(40.756389,-73.9964807);
    self.nycpizzaAnno.title = @"Capizzi Pizza in NYC";
    
    self.currentAnno = [[MKPointAnnotation alloc] init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0,0.0);
    self.currentAnno.title = @"My Location";
    
    // Adding them to the map
    [self.mapView addAnnotations:@[self.gemaltoAnno, self.bigskybarAnno, self.nycpizzaAnno]];
}

@end
