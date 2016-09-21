//
//  plansBrokerEmployerViewController.m
//  HBXMobile
//
//  Created by David Boyd on 9/20/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "plansBrokerEmployerViewController.h"
#import "benefitGroupCardView.h"

@interface plansBrokerEmployerViewController ()

@end

@implementation plansBrokerEmployerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGFloat frameX = size.width - 20;
    CGFloat frameY = size.height-30; //padding for UIpageControl
    
    UIScrollView  *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 155, frameX, 200)];
    scrollView.pagingEnabled = YES;
    
    scrollView.backgroundColor = [UIColor grayColor];
    scrollView.contentSize = CGSizeMake(frameX, frameY);
    scrollView.delegate = self;
    
    [self.view addSubview: scrollView];
    
    
    for(int i = 0; i < 3; i++)
    {
        /*
        UIImage *image;
        if (i == 0)
         image = [UIImage imageNamed:@"tabBG1.png"];
        else
            image = [UIImage imageNamed:@"gear.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
         */
        benefitGroupCardView *imageView = [[benefitGroupCardView alloc] initWithFrame:CGRectMake(frameX * i, 0.0, frameX, 200)];
        imageView.benefitGroupName = @"CEO's & Managers";
        [imageView layoutView];
        [scrollView addSubview:imageView];
    }
    scrollView.contentSize = CGSizeMake(frameX*3, 200);
    
 
    // Init Page Control
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(10, 360, 360, 20);
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor clearColor];
    
    pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    [self.view addSubview:pageControl];
  
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
