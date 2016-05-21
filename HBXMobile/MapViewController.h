//
//  MapViewController.h
//  HBXMobile
//
//  Created by David Boyd on 5/18/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <mapkit/mapkit.h>

@interface MapViewController : UIViewController
{
    NSMutableArray  *routeItems;
    IBOutlet UITableView *routeTable;
    
    UILabel *lblEstmatedTime;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) MKMapItem *destination;

@end
