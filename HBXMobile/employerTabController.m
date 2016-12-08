//
//  employerTabController.m
//  HBXMobile
//
//  Created by John Boyd on 9/14/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "employerTabController.h"
#import "Settings.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

NSString * const rosterLoadedNotification = @"rosterLoaded";

@interface employerTabController ()

@end

@implementation employerTabController

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    if (_isBroker)
        return NO;
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self setDelegate:self];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabBG1.png"]]; //[UIImage imageNamed:@"tabbar_selected.png"]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       UIColorFromRGB(0x007BC4), NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    
    [UITabBarItem.appearance setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];

    
    UITabBarItem *item0 = self.tabBar.items[0];    
//    self.tabBarItem.image = [self imageWithImage:image scaledToSize:CGSizeMake(30, 30)];
    [item0 setImage:[[self imageWithImage:[UIImage imageNamed:@"infonormal48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    [item0 setImage:[[UIImage imageNamed:@"infonormal32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    [item0 setSelectedImage:[[UIImage imageNamed:@"infoactive32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item0 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"infoactive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UITabBarItem *item1 = self.tabBar.items[1];
    [item1 setImage:[[self imageWithImage:[UIImage imageNamed:@"rosternormal48.png"]  scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"rosteractive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    UITabBarItem *item2 = self.tabBar.items[2];
    [item2 setImage:[[self imageWithImage:[UIImage imageNamed:@"costsnormal48.png"]  scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"costsactive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
/*
    [item2 setImage:[[UIImage imageNamed:@"costsnormal32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"costsactive32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
*/
    UITabBarItem *item3 = self.tabBar.items[3];
    [item3 setImage:[[self imageWithImage:[UIImage imageNamed:@"plansnormal48.png"]  scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[self imageWithImage:[UIImage imageNamed:@"plansactive48.png"] scaledToSize:CGSizeMake(32, 32)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

 /*
    [item3 setImage:[[UIImage imageNamed:@"plansnormal32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"plansactive32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
*/
    _enrolled = -1;
    _waived = -1;
    _notenrolled = -1;
    _total_employees = -1;
    
    _current_coverage_year_index = [[_detailDictionary valueForKey:@"plan_years"] count]-1;

    [self loadDictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadDictionary
{
    NSString *pUrl;
//    NSString *empId = @"";
    NSString *e_url = @"";
    
    Settings *obj=[Settings getInstance];

 //   if ([obj.sEmployerId length]>0)
 //       empId = [NSString stringWithFormat:@"/%@", obj.sEmployerId];
    if (_roster_url)
        e_url = _roster_url;
    else
        e_url = [NSString stringWithFormat:@"%@/api/v1/mobile_api/employee_roster", obj.sEnrollServer];  //_employerData.roster_url;
    
    NSLog(@"HERE IN tabbar:LOAD DICTIONARY\n");
//    bDataLoading = TRUE;
    
    if (! [e_url hasPrefix:@"https://"] && ![e_url hasPrefix:@"http://"])
        pUrl = [NSString stringWithFormat:@"%@%@", _enrollHost, _roster_url];
    else
        pUrl = e_url; //_employerData.roster_url;
    
    NSURL* url = [NSURL URLWithString:pUrl];
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                _enrollHost, NSHTTPCookieDomain,
                                @"/", NSHTTPCookiePath,  // IMPORTANT!
                                @"_session_id", NSHTTPCookieName,
                                _customCookie_a, NSHTTPCookieValue,
                                nil];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:properties];
    NSArray* cookies = [NSArray arrayWithObjects: cookie, nil];
    NSDictionary * headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    
    [urlRequest setAllHTTPHeaderFields:headers];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest
                                       queue:queue
                           completionHandler:^(NSURLResponse* response,
                                               NSData* data,
                                               NSError* error)
     {
         if (data) {
             NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
             // check status code and possibly MIME type (which shall start with "application/json"):
             //          NSRange range = [response.MIMEType rangeOfString:@"application/json"];
             NSString *myString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"\n%@\n", myString);
             
             if (httpResponse.statusCode == 200) { // /* OK */ && range.length != 0) {
                 NSError* error;
                 id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                 if (jsonObject) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         // self.model = jsonObject;
                         NSLog(@"jsonObject: %@", jsonObject);
                 //        _rosterDictionary = jsonObject;
                         
                         NSError *error;
                         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                                            options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                              error:&error];
                         
                         if (! jsonData) {
                             NSLog(@"Got an error: %@", error);
                         } else {
                             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            NSLog(@"\n%@\n", jsonString);
                         }
                         
                         NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"last_name" ascending:YES];
                         NSArray *sortDescriptors = [NSArray arrayWithObject:sort];
                         
     //                    employerTabController *tabBar = (employerTabController *) self.tabBarController;
                         
                         // rosterList = [[dictionary valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
 
                         _rosterList = [[jsonObject valueForKey:@"roster"] sortedArrayUsingDescriptors:sortDescriptors];
                         
                         NSMutableDictionary *pArray;
                         
                         _rosterDictionary = [[NSMutableDictionary alloc] init];
                         
                         for (pArray in _rosterList)
                         {
                             NSMutableArray *pRoster;// = [[NSMutableArray alloc] init];
                             
                             NSMutableDictionary * mutableDict = [NSMutableDictionary dictionary];
                             [mutableDict addEntriesFromDictionary:pArray];
                             [mutableDict removeObjectForKey:@"enrollments"];

                             int iIndex = 0;
                             NSArray *enrollment = [pArray valueForKey:@"enrollments"];
                             for (id plans in enrollment)
                             {
                  //               [mutableDict removeObjectForKey:@"enrollment"];
                                 NSLog(@"%@", plans);
                                 pRoster = [_rosterDictionary valueForKey:[plans valueForKey:@"start_on"]];
                                 if (pRoster == nil)
                                 {
                                    [mutableDict setObject:plans forKey:@"enrollment"];
                                     
                                    pRoster = [[NSMutableArray alloc] init];
                                    [pRoster addObject:[mutableDict mutableCopy]];
                                    [_rosterDictionary setValue:pRoster forKey:[plans valueForKey:@"start_on"]];
                                 }
                                 else
                                 {
                                     [mutableDict setObject:plans forKey:@"enrollment"];

                                    [pRoster addObject:mutableDict];
                                    [_rosterDictionary setValue:pRoster forKey:[plans valueForKey:@"start_on"]];
                                 }
                                 iIndex++;
                             }
                             
                         }
                         
                         NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
                         [dnc postNotificationName:rosterLoadedNotification
                                            object:self
                                          userInfo:nil];
                         
                         NSString *sKey;
                         
                         NSDateFormatter *f = [[NSDateFormatter alloc] init];
                         [f setDateFormat:@"yyyy-MM-dd"];
                         [f setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                         
                         NSString *todayDateString = [f stringFromDate:[NSDate date]];
                         
                         NSArray *pPlan = [_employerData.plans objectAtIndex:[_employerData.plans count]-1];
                         
    //                     NSDate *planYearBegins = [self userVisibleDateTimeForRFC3339Date:[pPlan valueForKey:@"plan_year_begins"] ];

                         NSDate *planYear = [f dateFromString:[pPlan valueForKey:@"plan_year_begins"]]; //_employerData.planYear];
                         
                         BOOL bPlanYearInTheFuture = FALSE;
                         
                         if ([[f dateFromString:todayDateString] compare:planYear] == NSOrderedAscending)
                         {
                             bPlanYearInTheFuture = TRUE;
                         }
                         
                       //  if (_employerData.status == (enrollmentState)NO_ACTION_REQUIRED) //NEEDS_ATTEENTION) OPEN_ENROLLMENT_MET
                       //      sKey = [_employerData.plans objectAtIndex:[_employerData.plans count]];//]@"active";
                       //  else
                             sKey = [_employerData.plans objectAtIndex:[_employerData.plans count]-1];//@"renewal";
                         
                       //   sKey = @"active";
                         
     //                    NSLog(@"%@\n", [[_employerData.plans valueForKey:@"enrollments"] valueForKey:sKey]); //[_employerData.plans valueForKey:@"start_on"]);
                         
                         _enrolled = 0;
                         _waived = 0;
                         _notenrolled = 0;
                         
                         for (id myArrayElement in _rosterList)
                         {
//                             NSString *oo = [[[[[myArrayElement valueForKey:@"enrollments"] valueForKey:sKey] valueForKey:@"health"] valueForKey:@"employer_contribution"] stringValue];
  //                           NSString *ll = [[[[[myArrayElement valueForKey:@"enrollments"] valueForKey:sKey] valueForKey:@"health"] valueForKey:@"employee_cost"] stringValue];
                             
                             
   //                          NSString *status = [[[[myArrayElement valueForKey:@"enrollments"] valueForKey:sKey] valueForKey:@"health"] valueForKey:@"status"];
   //                          if (status == nil && [sKey isEqualToString:@"renewal"])
   //                              status = [[[[myArrayElement valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];
                             
                            NSDictionary *pp = [[myArrayElement valueForKey:@"enrollments"] valueForKey:@"health"];
                             
                            if ([pp count] > 0)
                            {
                                 NSDictionary *courseDetail = [[pp valueForKey:@"status"] objectAtIndex:0];
                                 
                                 NSString *status = [NSString stringWithFormat:@"%@", courseDetail];
                                 
     //                           NSString *status = [[[myArrayElement valueForKey:@"enrollments"] valueForKey:@"health"] valueForKey:@"status"];
                        
                                 if ([status isEqualToString:@"Not Enrolled"])
                                     _notenrolled += 1;
                                 else
                                 {
                                     if ([status isEqualToString:@"Enrolled"])
                                         _enrolled += 1;
                                     if ([status isEqualToString:@"Waived"])
                                         _waived += 1;
                                     if ([status isEqualToString:@"Terminated"])
                                         _terminated += 1;

       //                              NSString *oo = [[[[myArrayElement valueForKey:@"enrollments"] valueForKey:@"health"] valueForKey:@"employer_contribution"] stringValue];
         //                            NSString *ll = [[[[myArrayElement valueForKey:@"enrollments"] valueForKey:@"health"] valueForKey:@"employee_cost"] stringValue];

                                    NSDictionary *emp_contr = [[pp valueForKey:@"employer_contribution"] objectAtIndex:0];
                                    NSDictionary *emp_cost = [[pp valueForKey:@"employee_cost"] objectAtIndex:0];
                                     
                                    NSString *oo = [NSString stringWithFormat:@"%@", emp_contr];
                                    NSString *ll = [NSString stringWithFormat:@"%@", emp_cost];
                                   
                                     _employer_contribution += [oo doubleValue];
                                     _employee_costs += [ll doubleValue];
                                 }
                                 
                             }
                         }
                         
  //                       _current_coverage_year_index = [_employerData.plans count]-1;
                         
//                        NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
                         [dnc postNotificationName:@"rosterCostsLoaded"
                                            object:self
                                          userInfo:nil];

                     });
                 } else {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         //[self handleError:error];
                         NSLog(@"ERROR: %@", error);
                     });
                 }
             }
             else {
                 // status code indicates error, or didn't receive type of data requested
                 NSString* desc = [[NSString alloc] initWithFormat:@"HTTP Request failed with status code: %d (%@)",
                                   (int)(httpResponse.statusCode),
                                   [NSHTTPURLResponse localizedStringForStatusCode:httpResponse.statusCode]];
                 NSError* error = [NSError errorWithDomain:@"HTTP Request"
                                                      code:-1000
                                                  userInfo:@{NSLocalizedDescriptionKey: desc}];
                 dispatch_async(dispatch_get_main_queue(), ^{
                     //[self handleError:error];  // execute on main thread!
                     NSLog(@"ERROR: %@", error);
                 });
             }
         }
         else {
             // request failed - error contains info about the failure
             dispatch_async(dispatch_get_main_queue(), ^{
                 //[self handleError:error]; // execute on main thread!
                 NSLog(@"ERROR: %@", error);
             });
         }
     }];
}
/*
-(NSString*)getRenewalEnrollment:(NSInteger)row
{
    NSArray *pk = [[displayArray objectAtIndex:row] valueForKey:@"enrollments"];
    
    for (int ii=0;ii<[pk count];ii++)
    {
        NSDictionary *pp = [[displayArray objectAtIndex:row] valueForKey:@"enrollments"][ii]; //[pk value:ii];
        
        NSString *a;
        NSString *b;
        NSString *c;
        
        a = [pp valueForKey:@"coverage_kind"];
        b = [pp valueForKey:@"period_type"];
        c = [pp valueForKey:@"status"];
        
        if ([b isEqualToString:@"renewal"])
            if ([a isEqualToString:@"health"])
                return c;
        
        NSLog(@"%@    ---   %@   -----   %@", a,b,c);
        
    }
    return nil;
}

-(NSString*)getActiveEnrollment:(NSInteger)row
{
    NSArray *pk = [[displayArray objectAtIndex:row] valueForKey:@"enrollments"];
    
    for (int ii=0;ii<[pk count];ii++)
    {
        //        NSDictionary *pp = [[rosterList objectAtIndex:row] valueForKey:@"enrollments"][ii]; //[pk value:ii];
        NSDictionary *pp = [[[[[displayArray objectAtIndex:row] valueForKey:@"enrollments"] valueForKey:@"active"] valueForKey:@"health"] valueForKey:@"status"];//[ii]; //[pk value:ii];
        
        NSString *a;
        NSString *b;
        NSString *c;
        
        a = [pp valueForKey:@"coverage_kind"];
        b = [pp valueForKey:@"period_type"];
        c = [pp valueForKey:@"status"];
        
        if ([b isEqualToString:@"active"])
            if ([a isEqualToString:@"health"])
                return c;
        
        NSLog(@"%@    ---   %@   -----   %@", a,b,c);
        
    }
    return nil;
}
*/
                         
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //    self.secondViewController = (YourSecondViewController*) viewController;
    //    self.secondViewController.aLabel.text = self.stringFromTableViewController;
}
/*
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    // http://stackoverflow.com/questions/5161730/iphone-how-to-switch-tabs-with-an-animation
    NSUInteger controllerIndex = [self.viewControllers indexOfObject:viewController];
    
    if (controllerIndex == tabBarController.selectedIndex) {
        return NO;
    }
    
    // Get the views.
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [tabBarController.viewControllers[controllerIndex] view];
    
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    BOOL scrollRight = controllerIndex > tabBarController.selectedIndex;
    
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    
    // Position it off screen.
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    toView.frame = CGRectMake((scrollRight ? screenWidth : -screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame = CGRectMake((scrollRight ? -screenWidth : screenWidth), viewSize.origin.y, screenWidth, viewSize.size.height);
                         toView.frame = CGRectMake(0, viewSize.origin.y, screenWidth, viewSize.size.height);
                     }
     
                     completion:^(BOOL finished) {
                         if (finished) {
 
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             tabBarController.selectedIndex = controllerIndex;
                         }
                     }];
    
    return NO;
*/
/*
    
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView)
        return false;
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.3
                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    return true;
 */
//}
@end
