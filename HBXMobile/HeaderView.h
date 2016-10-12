//
//  HeaderView.h
//  HBXMobile
//
//  Created by John Boyd on 10/12/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "popupMessageBox.h"
#import "brokerEmployersData.h"

@interface HeaderView : UIView <MFMessageComposeViewControllerDelegate, popupMessageBoxDelegate>
{
    brokerEmployersData *employerData;
}

@property (nonatomic, retain) NSArray *dataArray;

-(void)layoutHeaderView:(brokerEmployersData *)eData;

@end
