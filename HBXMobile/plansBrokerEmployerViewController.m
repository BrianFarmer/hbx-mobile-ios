//
//  plansBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by David Boyd on 9/20/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "plansBrokerEmployerViewController.h"
#import "benefitGroupCardView.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface plansBrokerEmployerViewController ()

@end

@implementation plansBrokerEmployerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    employerTabController *tabBar = (employerTabController *) self.tabBarController;
    
    employerData = tabBar.employerData;

    navImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 0, 200, 40)];
    
    navImage.backgroundColor = [UIColor clearColor];
    navImage.image = [UIImage imageNamed:@"navHeader"];
    navImage.contentMode = UIViewContentModeCenter;
    
    self.navigationController.topViewController.navigationItem.titleView = navImage;
    
    //self.navigationController.topViewController.title = @"info";
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,175);
    [vHeader layoutHeaderView:employerData];
    
    pCompany.font = [UIFont fontWithName:@"Roboto-Bold" size:24];
    pCompany.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 65);
    
    pCompany.textAlignment = NSTextAlignmentCenter;
    pCompany.text = employerData.companyName;
    
    pCompanyFooter.frame = CGRectMake(10, pCompany.frame.origin.y + pCompany.frame.size.height, self.view.frame.size.width - 20, pCompanyFooter.frame.size.height);
    pCompanyFooter.textAlignment = NSTextAlignmentCenter;
    pCompanyFooter.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    
    //    pCompanyFooter.backgroundColor = [UIColor greenColor];
    
    if (employerData.status == (enrollmentState)NEEDS_ATTENTION)
    {
        pCompanyFooter.text = NSLocalizedString(@"TITLE_NOTE", @"OPEN ENROLLMENT IN PROGRESS - MINIMUM NOT MET");
        pCompanyFooter.textColor = [UIColor redColor];
        
    }
    else if (employerData.status == (enrollmentState)OPEN_ENROLLMENT_MET)
    {
        pCompanyFooter.text = @"OPEN ENROLLMENT IN PROGRESS";
        pCompanyFooter.textColor = [UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f]; //[UIColor yellowColor];
        
    }
    else if (employerData.status == (enrollmentState)RENEWAL_IN_PROGRESS)
    {
        pCompanyFooter.text = @"RENEWAL PENDING"; //@"RENEWAL IN PROGRESS";
        pCompanyFooter.textColor = [UIColor colorWithRed:218.0f/255.0f green:165.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
    }
    else if (employerData.status == (enrollmentState)NO_ACTION_REQUIRED)
    {
        pCompanyFooter.text = @"IN COVERAGE";
        pCompanyFooter.textColor = [UIColor colorWithRed:0.0f/255.0f green:139.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    }
    

    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Roboto-Bold" size:12], NSFontAttributeName,
                                [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1], NSForegroundColorAttributeName, nil];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Active Year", @"In Renewal", nil];
    UISegmentedControl *planYearControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    planYearControl.frame = CGRectMake(self.view.frame.size.width/2 - 70, [self.view viewWithTag:30].frame.origin.y + [self.view viewWithTag:30].frame.size.height + 10, 140, 25);
    [planYearControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [planYearControl setTintColor:[UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]];
    
    [planYearControl addTarget:self action:@selector(HandleSegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    planYearControl.selectedSegmentIndex = 0;
    
    [self.view addSubview:planYearControl];

    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat frameX = size.width;
    CGFloat frameY = size.height-30; 

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height)]; //155, frameX, 200)];
                                 
    scrollView.pagingEnabled = YES;
    
    scrollView.backgroundColor = UIColorFromRGB(0xebebeb);//UIColorFromRGB(0xd3d3d3); //d3d3d3
    scrollView.contentSize = CGSizeMake(frameX, frameY);
    scrollView.delegate = self;
    
    [self.view addSubview: scrollView];
  
//    NSDictionary *aa = [[[_delegate getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];
    
    NSArray *po = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];// valueForKey:@"active"];

    for(int i = 0; i < [po count]; i++)
    {
        benefitGroupCardView *cardView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i + 10, 10.0, frameX - 20, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 30)];
        cardView.po = [po objectAtIndex:i];
        cardView.delegate = self;
        cardView.tag = 300+i;
        [cardView layoutView:i+1 totalPages:[po count]];
        cardView.layer.cornerRadius = 3;
/*
        cardView.layer.masksToBounds = NO;
        cardView.layer.shadowOffset = CGSizeMake(-2, 5);
        cardView.layer.shadowRadius = 5;
        cardView.layer.shadowOpacity = 0.5;
        cardView.layer.shadowPath = [UIBezierPath bezierPathWithRect:cardView.bounds].CGPath;
*/        
        [scrollView addSubview:cardView];
    }
    
    scrollView.contentSize = CGSizeMake(frameX*[po count], self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 40);//200);

    
    // Init Page Control
    pageControl = [[UIPageControl alloc] init];
//    pageControl.frame = CGRectMake(10, scrollView.frame.origin.y - 20, scrollView.frame.size.width, 20);
    //369+165
    pageControl.frame = CGRectMake(10,self.tabBarController.tabBar.frame.origin.y - 20,scrollView.frame.size.width-20, 20);
    pageControl.numberOfPages = [po count];
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor clearColor];
    
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:pageControl];
  
}

-(void)scrolltoNextPage:(int)page
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width*page, 0.0f) animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)sView
{
    int width = sView.frame.size.width;
    float xPos = sView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    pageControl.currentPage = (int)xPos/width;
}

- (void)HandleSegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        for(UIView *subview in [scrollView subviews]) {
            [subview removeFromSuperview];
        }
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        CGFloat frameX = size.width;
        
        NSArray *pRenewal = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];
        
        for(int i = 0; i < [pRenewal count]; i++)
        {
            benefitGroupCardView *cardView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i + 10, 10.0, frameX - 20, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 30)];
            cardView.po = [pRenewal objectAtIndex:i];
            cardView.delegate = self;
            cardView.tag = 300+i;
            [cardView layoutView:i+1 totalPages:[pRenewal count]];
            cardView.layer.cornerRadius = 3;
            
            [scrollView addSubview:cardView];
        }
        
        pageControl.numberOfPages = [pRenewal count];
    }
    
    if(segment.selectedSegmentIndex == 1)
    {
        /*
         NSArray *po = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"active"];
         
         for(int i = 0; i < [po count]; i++)
         {
             benefitGroupCardView *cardView = [self.view viewWithTag:300+i];
             [cardView removeFromSuperview];
         }
        */
        for(UIView *subview in [scrollView subviews]) {
            [subview removeFromSuperview];
        }

        CGSize size = [[UIScreen mainScreen] bounds].size;
        CGFloat frameX = size.width;

        NSArray *pRenewal = [[[self getEmployer] valueForKey:@"plan_offerings"] valueForKey:@"renewal"];
        
        for(int i = 0; i < [pRenewal count]; i++)
        {
            benefitGroupCardView *cardView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i + 10, 10.0, frameX - 20, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 30)];
            cardView.po = [pRenewal objectAtIndex:i];
            cardView.delegate = self;
            cardView.tag = 300+i;
            [cardView layoutView:i+1 totalPages:[pRenewal count]];
            cardView.layer.cornerRadius = 3;
 
            [scrollView addSubview:cardView];
        }
        
        pageControl.numberOfPages = [pRenewal count];
    }

}

-(NSDictionary*)getEmployer
{
    return ((employerTabController *) self.tabBarController).detailDictionary;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)phoneEmployer:(id)sender
{
    //    -(void)showAddressBook{
    ABPeoplePickerNavigationController *_addressBookController = [[ABPeoplePickerNavigationController alloc] init];
    [_addressBookController setPeoplePickerDelegate:self];
    [self presentViewController:_addressBookController animated:YES completion:nil];
    //    }

}

@end
