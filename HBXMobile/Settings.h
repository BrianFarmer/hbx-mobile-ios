//
//  Settings.h
//  HBX Mobile
//
//  Created by John Boyd on 6/18/13.
//  Copyright (c) 2013 John Boyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
{
//    NSString *sMobileServer;
//    NSString *sEnrollServer;
//    NSString *sUser;
}

@property(nonatomic,retain)NSString *sMobileServer;
@property(nonatomic,retain)NSString *sEnrollServer;
@property(nonatomic,retain)NSString *sUser;

+(Settings*)getInstance;
-(NSString*)getMobileServer;
-(NSString*)getEnrollServer;
-(NSString*)getUser;

@end