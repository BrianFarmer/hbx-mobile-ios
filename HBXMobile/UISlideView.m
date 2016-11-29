//
//  UISlideView.m
//  TestPOS
//
//  Created by John Boyd on 5/30/14.
//  Copyright (c) 2014 John Boyd. All rights reserved.
//
#import "AppDelegate.h"
#import "UISlideView.h"
#import "Constants.h"

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
/*
        UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
        recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:recognizerLeft];
*/
        self.backgroundColor = [UIColor greenColor];
        
        loggedInTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) style:UITableViewStylePlain];
        loggedInTable.dataSource = self;
        loggedInTable.delegate = self;
        loggedInTable.rowHeight = 54.0f;

        [loggedInTable setBackgroundView:nil];
        [loggedInTable setBackgroundColor:UIColorFromRGB(0xD9D9D9)];
        loggedInTable.allowsSelection = YES;
        
        [self addSubview:loggedInTable];
        
        pCounts = [[NSMutableArray alloc] init];
        
        bOpened = FALSE;
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

-(BOOL)handleLeftSwipe //:(int)is //(UISwipeGestureRecognizer *) recognizer {
{
    if (bOpened)
    {
        [self handleRightSwipe:nil];
        bOpened = FALSE;
        return bOpened;
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

    return bOpened;
}

- (void)viewDidLoad
{
    loggedInTable.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);

    [pCounts removeAllObjects];

    [pCounts addObject:@"Enrolled"];
    [pCounts addObject:@"Waived"];
    [pCounts addObject:@"Not Enrolled"];
    [pCounts addObject:@"Terminated"];
//    [pCounts addObject:@"Show All"];

    [pCounts addObject:@"Enrolled for next year"];
    [pCounts addObject:@"Waived for next year"];
    [pCounts addObject:@"Not enrolled for next year"];
//    [pCounts addObject:@"Show All"];

    [loggedInTable reloadData];
    
    [self.superview bringSubviewToFront:self];
    self.userInteractionEnabled = TRUE;
    loggedInTable.userInteractionEnabled = TRUE;
    self.backgroundColor = [UIColor greenColor];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([pCounts count] == 0)
        return 0;
    
    if (section == 2)
        return 1;
    if (section == 0)
        return 4;
    
    return 3;//[pCounts count] / 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 2) ? 10:30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, (section == 2) ? 10:30)];
    
    // Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - 5, (section == 2) ? 10:30);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:14.0];

    if (section == 0)
        headerLabel.text = @"ACTIVE STATUS";
    else if (section == 1)
        headerLabel.text = @"RENEWAL STATUS";
    else
        headerLabel.text = @"";
    
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // Add the label to the header view
    [headerView addSubview:headerLabel];
    
    return headerView;
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
    if (indexPath.section == 0 || indexPath.section == 2)
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
    else
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12];
    
    if (indexPath.section == 2)
    {
        cell.textLabel.textColor = UIColorFromRGB(0x555555);
        cell.textLabel.text = @"Show All";
        if (iSort == indexPath)
            cell.imageView.image = [UIImage imageNamed:@"check_showall.png"];
    }
    else
    {
        cell.textLabel.text = [pCounts objectAtIndex:indexPath.section * 4 + indexPath.row];
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.textColor = EMPLOYER_DETAIL_PARTICIPATION_ENROLLED;
                if (iSort == indexPath)
                    cell.imageView.image = [UIImage imageNamed:@"check_green.png"];
                break;
            case 1:
                cell.textLabel.textColor = EMPLOYER_DETAIL_PARTICIPATION_WAIVED;
                if (iSort == indexPath)
                    cell.imageView.image = [UIImage imageNamed:@"check_yellow.png"];
                break;
            case 2:
                cell.textLabel.textColor = EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED;
                if (iSort == indexPath)
                    cell.imageView.image = [UIImage imageNamed:@"check_notenrolled.png"];
                break;
            case 3:
                cell.textLabel.textColor = EMPLOYER_DETAIL_PARTICIPATION_TERMINATED;
                if (iSort == indexPath)
                    cell.imageView.image = [UIImage imageNamed:@"check_purple.png"];
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:iSort].imageView.image = nil;
    
    switch (indexPath.row)
    {
    case 0:
        if (indexPath.section == 2)
            [tableView cellForRowAtIndexPath:indexPath].imageView.image = [UIImage imageNamed:@"check_showall.png"];
        else
            [tableView cellForRowAtIndexPath:indexPath].imageView.image = [UIImage imageNamed:@"check_green.png"];
        break;
    case 1:
            [tableView cellForRowAtIndexPath:indexPath].imageView.image = [UIImage imageNamed:@"check_yellow.png"];
        break;
    case 2:
            [tableView cellForRowAtIndexPath:indexPath].imageView.image = [UIImage imageNamed:@"check_notenrolled.png"];
        break;
    case 3:
            [tableView cellForRowAtIndexPath:indexPath].imageView.image = [UIImage imageNamed:@"check_purple.png"];
            break;
    }
    
    bOpened = FALSE;
    [self handleRightSwipe:nil];
    iSort = indexPath;
    
    [delegate sortByStatus:indexPath];
}
@end
