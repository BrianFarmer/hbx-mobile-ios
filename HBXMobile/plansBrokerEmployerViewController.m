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
    vHeader.frame = CGRectMake(0,0,self.view.frame.size.width,145);
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
    
    for (int btnCount=0;btnCount<4;btnCount++)
    {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag=30+btnCount;
        [button setFrame:CGRectMake(10, pCompanyFooter.frame.origin.y + pCompanyFooter.frame.size.height + 10, 38, 38)];
        [button setBackgroundColor:[UIColor clearColor]];
        UIImage *btnImage;
        switch(btnCount)
        {
            case 0:
                btnImage = [UIImage imageNamed:@"phone.png"];
                [button addTarget:self action:@selector(phoneEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                btnImage = [UIImage imageNamed:@"message.png"];
                [button addTarget:self action:@selector(smsEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 2:
                btnImage = [UIImage imageNamed:@"location.png"];
                [button addTarget:self action:@selector(showDirections:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 3:
                btnImage = [UIImage imageNamed:@"email.png"];
                [button addTarget:self action:@selector(emailEmployer:) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
        
        button.contentMode = UIViewContentModeScaleToFill;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [button setImage:btnImage forState:UIControlStateNormal];
        
        [vHeader addSubview:button];
    }
    [self evenlySpaceTheseButtonsInThisView:@[[self.view viewWithTag:30], [self.view viewWithTag:31], [self.view viewWithTag:32], [self.view viewWithTag:33]] :self.view];

    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat frameX = size.width;
    CGFloat frameY = size.height-30; //padding for UIpageControl

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, vHeader.frame.origin.y + vHeader.frame.size.height, self.view.frame.size.width, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height)]; //155, frameX, 200)];
                                 
    scrollView.pagingEnabled = YES;
    
    scrollView.backgroundColor = UIColorFromRGB(0xd3d3d3); //d3d3d3
    scrollView.contentSize = CGSizeMake(frameX, frameY);
    scrollView.delegate = self;
    
    [self.view addSubview: scrollView];
  

    for(int i = 0; i < 3; i++)
    {
        benefitGroupCardView *cardView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i + 10, 10.0, frameX - 20, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 30)];
        cardView.benefitGroupName = @"CEO's & Managers";
        cardView.delegate = self;
        [cardView layoutView:i+1 totalPages:3];
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
    
    scrollView.contentSize = CGSizeMake(frameX*3, self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 40);//200);
    int iht = self.tabBarController.tabBar.frame.origin.y - vHeader.frame.size.height - 40;
    int uu = scrollView.frame.origin.y;
    
    // Init Page Control
    pageControl = [[UIPageControl alloc] init];
//    pageControl.frame = CGRectMake(10, scrollView.frame.origin.y - 20, scrollView.frame.size.width, 20);
    //369+165
    pageControl.frame = CGRectMake(10,self.tabBarController.tabBar.frame.origin.y - 20,scrollView.frame.size.width-20, 20);
//   benefitGroupCardView.frame.origin.y + benefitGroupCardView.frame.size.height, scrollView.frame.size.width, 20);
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor clearColor];
    
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:pageControl];
  
}

-(void)scrolltoNextPage:(int)page
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width*page, 0.0f) animated:YES];
//    scroll.contentOffset = CGPointMake(scroll.frame.size.width*pageNo, 0);
}

- (void) evenlySpaceTheseButtonsInThisView : (NSArray *) buttonArray : (UIView *) thisView {
    int widthOfAllButtons = 0;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *thisButton = [buttonArray objectAtIndex:i];
        //    [thisButton setCenter:CGPointMake(0, thisView.frame.size.height / 2.0)];
        widthOfAllButtons = widthOfAllButtons + thisButton.frame.size.width;
    }
    
    int spaceBetweenButtons = (thisView.frame.size.width - widthOfAllButtons) / (buttonArray.count + 1);
    
    UIButton *lastButton = nil;
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *thisButton = [buttonArray objectAtIndex:i];
        if (lastButton == nil) {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        } else {
            [thisButton setFrame:CGRectMake(spaceBetweenButtons + lastButton.frame.origin.x + lastButton.frame.size.width, thisButton.frame.origin.y, thisButton.frame.size.width, thisButton.frame.size.height)];
        }
        
        lastButton = thisButton;
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int width = scrollView.frame.size.width;
    float xPos = scrollView.contentOffset.x+10;
    
    //Calculate the page we are on based on x coordinate position and width of scroll view
    pageControl.currentPage = (int)xPos/width;
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

@end
