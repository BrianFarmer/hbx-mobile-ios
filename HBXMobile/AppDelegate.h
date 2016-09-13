//
//  AppDelegate.h
//  HBXMobile
//
//  Created by David Boyd on 3/4/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SlideNavigationController.h"
#import "LeftMenuSlideOutTableViewController.h"

@class SWRevealViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSDate *enteredBackground;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) SWRevealViewController *viewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

