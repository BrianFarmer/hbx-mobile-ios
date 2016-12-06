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

@protocol HeaderViewDelegate
-(void)HandleSegmentControlAction:(UISegmentedControl *)segment;
-(void)changeCoverageYear:(NSInteger)index;
-(NSInteger)getPlanIndex;
@end

@interface HeaderView : UIView <MFMessageComposeViewControllerDelegate, popupMessageBoxDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate>
{
//    brokerEmployersData *employerData;
    NSDictionary *employerDetail;
    UISegmentedControl *planYearControl;
    
    UIPickerView *pickerView;
    NSMutableArray *coverageArray;
    
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
    
    BOOL isSelectDate;
    IBOutlet UIButton *btnRoom;
    IBOutlet UIPickerView *roomPickerview;
        
    NSMutableArray *arrRooms;
}

@property (nonatomic, retain) NSArray *dataArray;
@property (nonatomic, weak)id<HeaderViewDelegate> delegate;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *coverageArray;
@property (nonatomic, assign) NSInteger iCurrentPlanIndex;


-(void)layoutHeaderView:(brokerEmployersData *)eData;
//-(void)layoutHeaderView:(brokerEmployersData *)eData showcoverage:(BOOL)bShowCoverage showplanyear:(BOOL)bShowPlanYear;
-(void)layoutHeaderView:(NSDictionary *)eData showcoverage:(BOOL)bShowCoverage showplanyear:(BOOL)bShowPlanYear;
-(int)layoutEmployeeProfile:(brokerEmployersData *)eData nameY:(int)y;
-(void)drawCoverageYear:(NSInteger)index;

@end
