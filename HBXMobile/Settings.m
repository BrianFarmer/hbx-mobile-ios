//
//  Settings.m
//  HBX Mobile
//
//  Created by John Boyd on 6/18/13.
//  Copyright (c) 2013 John Boyd. All rights reserved.
//

#import "Settings.h"

@implementation Settings
//@synthesize sMobileServer, sEnrollServer, sUser;
static Settings *instance =nil;
+(Settings *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [Settings new];
        }
    }
    
    return instance;
}

-(NSString *)getMobileServer
{
    return sMobileServer;
}

-(NSString *)getEnrollServer
{
    return sEnrollServer;
}

-(NSString *)getUser
{
    return sUser;
}
@end