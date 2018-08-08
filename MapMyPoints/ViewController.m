//
//  ViewController.m
//  MapMyPoints
//
//  Created by Mircea Popescu on 8/6/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKPointAnnotation *gemaltoAnno;
@property (strong, nonatomic) MKPointAnnotation *bigskybarAnno;
@property (strong, nonatomic) MKPointAnnotation *nycpizzaAnno;
@property (strong, nonatomic) MKPointAnnotation *currentAnno;

@property (weak, nonatomic) IBOutlet UISwitch *switchField;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL mapIsMoving;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    // Initiate the delegate for the locationManager, if not, it will not become the main actor and the map will not move to current location of the user when that is triggered.
    self.locationManager.delegate  = self;
    // Requesting user authorisation to allow the location + setting in info.plist -> NSLocationWhenInUseUsageDescription
    [self.locationManager requestWhenInUseAuthorization];
    
    // mapIsMoving was created in order to help allowing the user to be able to zoom-in on the location while the location is active. Because the location is updating at each movement by the user, it is impossible to do a zoom-in if you don't specify a state variable to keep track weather of not a map movement is in progress.
    _mapIsMoving = NO;
    
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
    
    if(_mapIsMoving == NO){
    [self centerMap:_currentAnno];
    }
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

// these 2 functions where created so mapIsMoving gets the state of the map, so you are able to zoom-in and out if the map is not in a state of animation
// For all this to work, we had to create MKMapView as delegate to the ViewController as well.

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    _mapIsMoving = YES;
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    _mapIsMoving = NO;
}
@end
