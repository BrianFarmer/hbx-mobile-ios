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

    [pCounts addObject:@"Enrolled for next year"];
    [pCounts addObject:@"Waived for next year"];
    [pCounts addObject:@"Not enrolled for next year"];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [pCounts count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 34;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"mySectionName", @"mySectionName");
            break;
        case 1:
            sectionName = NSLocalizedString(@"myOtherSectionName", @"myOtherSectionName");
            break;
            // ...
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}
*/
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    
    // Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithRed:236.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0f].CGColor;//[UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    headerView.tag = section;
    
    // Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 0, tableView.frame.size.width - 5, 34);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor darkGrayColor];
    headerLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16.0];

    if (section == 0)
        headerLabel.text = @"ACTIVE STATUS";
    else
        headerLabel.text = @"RENEWAL STATUS";
    
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
    if (indexPath.section == 0)
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:16];
    else
    cell.textLabel.font = [UIFont fontWithName:@"Roboto-Bold" size:12];
    
    
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
