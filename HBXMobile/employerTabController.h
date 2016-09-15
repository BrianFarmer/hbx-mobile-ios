//
//  employerTabController.h
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "brokerEmployersData.h"

@interface employerTabController : UITabBarController <UITabBarControllerDelegate>
{
    
}

@property (strong, nonatomic) brokerEmployersData *employerData;
@property(nonatomic, assign) NSString *enrollHost;
@property(nonatomic, assign) NSString *customCookie_a;

@end
