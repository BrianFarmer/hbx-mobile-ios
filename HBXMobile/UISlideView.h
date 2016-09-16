//
//  UISlideView.h
//  TestPOS
//
//  Created by John Boyd on 5/30/14.
//  Copyright (c) 2014 John Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol uiSlideViewDelegate
//-(void)addUser;
//-(void)addSpecial;
@end

@interface UISlideView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *loggedInTable;
    NSMutableArray *pCounts;
    
    BOOL    bOpened;
    int     iSort;
    
    __weak id <uiSlideViewDelegate> delegate;
}

@property (nonatomic, weak) id<uiSlideViewDelegate> delegate;

-(void) handleLeftSwipe:(int)iSort; 

@end
