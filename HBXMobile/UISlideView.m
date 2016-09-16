//
//  UISlideView.m
//  TestPOS
//
//  Created by John Boyd on 5/30/14.
//  Copyright (c) 2014 John Boyd. All rights reserved.
//
#import "AppDelegate.h"
#import "UISlideView.h"


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation UISlideView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
        recognizer.direction = UISwipeGestureRecognizerDirectionRight; // | UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:recognizer];

        UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
        recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:recognizerLeft];

        self.backgroundColor = [UIColor greenColor];
        
        loggedInTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) style:UITableViewStylePlain];
        loggedInTable.dataSource = self;
        loggedInTable.delegate = self;
        loggedInTable.rowHeight = 54.0f;

        [loggedInTable setBackgroundView:nil];
        [loggedInTable setBackgroundColor:UIColorFromRGB(0xD9D9D9)];//[UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:1.0]]; //[UIColor darkGrayColor]];
        loggedInTable.allowsSelection = YES;
        
        [self addSubview:loggedInTable];
        
        pCounts = [[NSMutableArray alloc] init];
        
        bOpened = FALSE;
        
        iSort = 3;
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) handleRightSwipe:(UISwipeGestureRecognizer *) recognizer {
//    [self viewDidLoad];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(self.frame.origin.x+200,self.frame.origin.y,200,self.frame.size.height);
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.superview cache:YES]; //UIViewAnimationTransitionFlipFromRight
    [UIView commitAnimations];
    bOpened = FALSE;
}

-(void) handleLeftSwipe:(int)is //(UISwipeGestureRecognizer *) recognizer {
{
    if (bOpened)
    {
        [self handleRightSwipe:nil];
        bOpened = FALSE;
        return;
    }
    [self viewDidLoad];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
//    CGRect rc = self.frame;
    self.frame = CGRectMake(self.frame.origin.x - 200,self.frame.origin.y,200,self.frame.size.height);
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.superview cache:YES]; //UIViewAnimationTransitionFlipFromRight
    [UIView commitAnimations];
    bOpened = TRUE;
    iSort = is;
}

- (void)viewDidLoad
{
    loggedInTable.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);

    [pCounts removeAllObjects];

    [pCounts addObject:@"Enrolled"];
    [pCounts addObject:@"Waived"];
    [pCounts addObject:@"Not Enrolled"];
    [pCounts addObject:@"Show All"];
    
    [loggedInTable reloadData];
    
    [self.superview bringSubviewToFront:self];
    self.userInteractionEnabled = TRUE;
    loggedInTable.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor greenColor];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pCounts count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.textColor = UIColorFromRGB(0x00a99e);
            cell.textLabel.text = [pCounts objectAtIndex:indexPath.row];
            if (iSort == indexPath.row)
                cell.imageView.image = [UIImage imageNamed:@"check_enrolled.png"];
            break;
        case 1:
            cell.textLabel.textColor = UIColorFromRGB(0x625ba8);
            cell.textLabel.text = [pCounts objectAtIndex:indexPath.row];
            if (iSort == indexPath.row)
                cell.imageView.image = [UIImage imageNamed:@"check_waived.png"];
            break;
        case 2:
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.text = [pCounts objectAtIndex:indexPath.row];
            if (iSort == indexPath.row)
                cell.imageView.image = [UIImage imageNamed:@"check_notenrolled.png"];
            break;
        case 3:
            cell.textLabel.textColor = UIColorFromRGB(0x555555);
            cell.textLabel.text = [pCounts objectAtIndex:indexPath.row];
            if (iSort == indexPath.row)
                cell.imageView.image = [UIImage imageNamed:@"check_showall.png"];
            break;
            
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bOpened = FALSE;
    [self handleRightSwipe:nil];
    iSort = (int)indexPath.row;
}
@end
