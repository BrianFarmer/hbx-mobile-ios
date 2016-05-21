//
//  MapViewController.m
//  HBXMobile
//
//  Created by David Boyd on 5/18/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(10,0,self.view.frame.size.width-20,20)];
    cardView.backgroundColor = [UIColor colorWithRed:(0/255.0) green:(38/255.0) blue:(99/255.0) alpha:0.8f];
 //   cardView.alpha = 0.8f;
    //        cardView.layer.borderWidth = 1;
    cardView.layer.masksToBounds = NO;
    cardView.layer.cornerRadius = 3.0;
    cardView.layer.shadowOffset = CGSizeMake(1, -1);
    cardView.layer.shadowOpacity = 0.3;
    
    lblEstmatedTime = [[UILabel alloc] init];
    lblEstmatedTime.frame = cardView.frame;
    lblEstmatedTime.textAlignment = NSTextAlignmentCenter;
    lblEstmatedTime.textColor = [UIColor whiteColor];
    lblEstmatedTime.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    [cardView addSubview:lblEstmatedTime];
    [self.view addSubview:cardView];
    
    routeItems = [[NSMutableArray alloc] init];
    
    routeTable.frame = CGRectMake(0, screenSize.height - 250, screenSize.width, 190);
    
    _mapView.frame = CGRectMake(0, 0, self.view.frame.size.width, routeTable.frame.origin.y);
    
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    [_mapView setMapType:MKMapTypeStandard];
    [_mapView setZoomEnabled:YES];
    [_mapView setScrollEnabled:YES];
/*
        MKUserLocation *userLocation = _mapView.userLocation;
        MKCoordinateRegion region =
        MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate,
                                           1000, 1000);
        [_mapView setRegion:region animated:NO];
*/
/*
    [self.mapView.userLocation addObserver:self
                                forKeyPath:@"location"
                                   options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                                   context:nil];
 */
    [self getDirections];
//    [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self getDirections];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Listen to change in the userLocation
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = 1; // Change these values to change the zoom
    span.longitudeDelta = 1;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated: YES];
}

- (void)getDirections
{
    MKDirectionsRequest *request =
    [[MKDirectionsRequest alloc] init];
    
    request.source = [MKMapItem mapItemForCurrentLocation];
/*
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 39.281516;
    zoomLocation.longitude= -76.580806;
  */
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(38.8895,-77.0353);
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    
    request.destination = destination; //_destination;
    request.requestsAlternateRoutes = NO;
    MKDirections *directions =
    [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle error
         } else {
             [self showRoute:response];
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse *)response
{
    float lETA;
    for (MKRoute *route in response.routes)
    {
        [_mapView
         addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        lETA += route.expectedTravelTime;
        for (MKRouteStep *step in route.steps)
        {
            NSLog(@"%@", step.instructions);

            [routeItems addObject:step];
        }
    }
    lblEstmatedTime.text = [NSString stringWithFormat:@"Estimated Time: %0.1f minutes",lETA/60]; //@"OPEN ENROLLMENT IS MAY 1, 2016 - MAY 31, 2016";

    [routeTable reloadData];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 4.0;
    return renderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [routeItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    

    MKRouteStep *step = [routeItems objectAtIndex:indexPath.row];

    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.text = step.instructions;
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:14.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f Miles", step.distance/1609.344];
    
    return cell;
}
@end
