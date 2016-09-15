//
//  tutorialViewController.m
//  HBXMobile
//
//  Created by John Boyd on 8/2/16.
//  Copyright © 2016 David Boyd. All rights reserved.
//

#import "tutorialViewController.h"

@interface tutorialViewController ()

@end

@implementation tutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.contentMode = UIViewContentModeScaleAspectFit;
//    self.view.clipsToBounds = TRUE;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,screenSize.width,screenSize.height-60)];
//    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage setImage:[UIImage imageNamed:@"tutorialImage"]];
    
    // choose best mode that works for you
    [backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
    
    [self.view insertSubview:backgroundImage atIndex:0];
    
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(screenSize.width/2-90, screenSize.height-130, 180, 50)];
    
    button.backgroundColor = [UIColor clearColor];

    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.clipsToBounds = YES;
    button.titleLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];
    [button addTarget:self
               action:@selector(dismissSelf:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Hide This" forState:UIControlStateNormal];

    [self.view addSubview:button];
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
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    NSLog(@"touches began");
    UITouch *touch = [touches anyObject];
 //   if(touch.view!=myView){
   [self dismissViewControllerAnimated:YES completion:nil];
//    }
}
*/

-(void)dismissSelf:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];  
}
@end
