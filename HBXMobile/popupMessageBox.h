//
//  popupMessageBox.h
//  HBXMobile
//
//  Created by David Boyd on 7/13/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>


#define typePopupPhone      1000
#define typePopupEmail      1001
#define typePopupSMS        1002
#define typePopupMAP        1003
#define typePopupEmpty      1004
#define typePopupAlert      1005

@protocol popupMessageBoxDelegate

-(void)SMSThesePeople:(id)tt;
-(void)MAPTheseDirections:(id)tt;

@end

@interface popupMessageBox : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *messageTable;
}

@property (nonatomic, retain) NSString      *messageTitle;
@property (nonatomic, retain) NSArray       *messageArray;
@property (nonatomic, assign) int           messageType;
@property (nonatomic, retain) NSArray       *resultArray;
@property (nonatomic, assign) long           resultCode;

@property (nonatomic, weak)id<popupMessageBoxDelegate> delegate;

@end
