//
//  detailBrokerEmployerViewController.h
//  HBXMobile
//
//  Created by John Boyd on 9/10/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "brokerEmployersData.h"
#import "popupMessageBox.h"
#import "XYGraph/XYPieChart.h"
#import "HeaderView.h"

@interface detailBrokerEmployerViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource, UITabBarControllerDelegate>
{
    IBOutlet UILabel *pCompany;
    IBOutlet UILabel *pCompanyFooter;
    
    IBOutlet HeaderView *vHeader;
    
    IBOutlet UITableView *detailTable;
    
    brokerEmployersData *employerData;
    
    NSMutableIndexSet *expandedSections;
    
    NSArray *sections;
    
    UIImageView *navImage;
    
    NSDictionary *dictionary;
    NSArray *monthlyCostValues;
    NSArray *monthlyCostNames;

    NSArray *renewalValues;
    NSArray *renewalNames;
}

@property (strong, nonatomic) brokerEmployersData *employerData;
@property(nonatomic, assign) long bucket;
@property(nonatomic, assign) NSString *enrollHost;
@property(nonatomic, assign) NSString *customCookie_a;
//@property (strong, nonatomic) IBOutlet XYPieChart *pieChartRight;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;

@end
