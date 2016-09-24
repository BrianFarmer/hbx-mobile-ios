//
//  benefitGroupCardView.h
//  HBXMobile
//
//  Created by David Boyd on 9/20/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol planCardViewDelegate

-(void)scrolltoNextPage:(int)page;

@end

@interface benefitGroupCardView : UIView
{
    int  currrentCard;
}

//@property (nonatomic, assign) int  currrentCard;
//@property (nonatomic, assign) int  totalCards;

@property (nonatomic, assign) int  employeeContribution;
@property (nonatomic, assign) int  spouseContribution;
@property (nonatomic, assign) int  dpContribution;
@property (nonatomic, assign) int  childContribution;

@property (nonatomic, retain) NSString      *benefitGroupName;
@property (nonatomic, retain) NSString      *referencePlan;

@property (nonatomic, weak)id<planCardViewDelegate> delegate;

-(void)layoutView:(int)cp totalPages:(int)tp;

@end
