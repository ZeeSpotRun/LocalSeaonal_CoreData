//
//  InSeasonViewController.m
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 15/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

//(2) Add Email app
//(3) Make everything self.blabla

#import "InSeasonViewController.h"

@interface InSeasonViewController ()

@end

@implementation InSeasonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.dataInit = [[DataInit alloc]init];
    
    if (self.currentMonth == nil){
        self.currentMonth = [self.dataInit findCurrentMonth];
    }
    
    [self initNavBar];
    [self createFavoritesButton];
    [self initTableView];
    
    
    if (self.tableArray != nil){
        NSLog(@"Table array has already been loaded!");
        [self.inSeasonTableView reloadData];
    
    } else {
        
        [self initSeasonList];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)initNavBar
{
    /* Set Font Attributes */
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"Helvetica-Bold" size:20], NSFontAttributeName,
                                FAV_COLOR, NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    self.title = [NSString stringWithFormat:@"%@", self.currentMonth];
    
    /* Set "Previous Month" Button */
    
    self.previousMonthBtn = [[UIBarButtonItem alloc]initWithTitle:[self.dataInit findPreviousMonth:self.currentMonth]
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(loadPreviousMonth)];
    self.previousMonthBtn.tintColor = BTN_COLOR;
    
    /* Set "Next month" Button */
    
    self.nextMonthBtn = [[UIBarButtonItem alloc]initWithTitle:[self.dataInit findNextMonth:self.currentMonth]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(loadNextMonth)];
    self.nextMonthBtn.tintColor = BTN_COLOR;
    
    
    /* Set Buttons to the navigation bar and make visible */
    
    self.navigationItem.leftBarButtonItem = self.previousMonthBtn;
    self.navigationItem.rightBarButtonItem = self.nextMonthBtn;
    [self.navigationController setNavigationBarHidden:NO];
    
}

-(void)createFavoritesButton
{
    
    self.showFavorite = [[UIButton alloc]initWithFrame:CGRectMake(0,
                                                                  self.view.frame.size.height - 50,
                                                                  self.view.frame.size.width,
                                                                  50)];

    [self.showFavorite setTitle:@"Show Favorites"
                       forState:UIControlStateNormal];
    [self.showFavorite setTitleColor:FAV_COLOR forState:UIControlStateNormal];
    
    [self.showFavorite addTarget:self
                          action:@selector(toggleFavorites)
                forControlEvents:UIControlEventTouchUpInside];
    
    self.showFavorite.backgroundColor = BACKGROUND_COLOR;
    self.showFavorite.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.showFavorite.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.view addSubview:self.showFavorite];
    
}

-(void)initTableView
{
    /* Create TableView Frame minus 20, DataSource, Delegate */
    
    self.inSeasonTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                     65,
                                                                     self.view.frame.size.width,
                                                                     self.view.frame.size.height - 115)];
    self.inSeasonTableView.delegate = self;
    self.inSeasonTableView.dataSource = self;
    
    self.inSeasonTableView.backgroundColor = BACKGROUND_COLOR;
    self.inSeasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.inSeasonTableView];
    
}


-(void)initSeasonList

{
    if (self.context == nil) {
        
        self.context = [self.dataInit managedObjectContextInit];
        
    } else {
        NSLog(@"Context already initialized.");
    }
    
        
    self.tableArray = [[NSMutableArray alloc]init];
    self.tableArray = [self.dataInit importCoreDataWithContext:self.context forMonth:self.currentMonth];
    
    [self.inSeasonTableView reloadData];
}

#pragma mark Button Methods

-(void)loadPreviousMonth
{
    NSString *previousMonth = [self.dataInit findPreviousMonth:self.currentMonth];
    self.title = [NSString stringWithFormat:@"%@", previousMonth];
    self.navigationItem.leftBarButtonItem.title = [self.dataInit findPreviousMonth:previousMonth];
    self.navigationItem.rightBarButtonItem.title = [self.dataInit findNextMonth:previousMonth];
    self.currentMonth = previousMonth;
    
    if ([self.showFavorite.titleLabel.text isEqual: @"Show Favorites"] ) {
        
        self.tableArray = [[NSMutableArray alloc]initWithArray:[self.dataInit findCurrentProduce:self.currentMonth]];
        [self.inSeasonTableView reloadData];
       
    } else {
        
        [self populateFavoriteArray];
    }
    
}

-(void)loadNextMonth
{
    NSString *nextMonth = [self.dataInit findNextMonth:self.currentMonth];
    self.title = [NSString stringWithFormat:@"%@", nextMonth];
    self.navigationItem.leftBarButtonItem.title = [self.dataInit findPreviousMonth:nextMonth];
    self.navigationItem.rightBarButtonItem.title = [self.dataInit findNextMonth:nextMonth];
    self.currentMonth = nextMonth;
    
    if ([self.showFavorite.titleLabel.text  isEqual: @"Show Favorites"] ) {
        
        self.tableArray = [[NSMutableArray alloc]initWithArray:[self.dataInit findCurrentProduce:self.currentMonth]];
        [self.inSeasonTableView reloadData];
        
    } else {
        
        [self populateFavoriteArray];
    }
}

-(void)toggleFavorites{
    if ([self.showFavorite.titleLabel.text isEqualToString: @"Show Favorites"])
        
        /* Populate Favorites Array */
        
    {
        [self populateFavoriteArray];
        [self.showFavorite setTitle:@"Show All Produce" forState:UIControlStateNormal];
        [self.showFavorite setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

    }
    
    else
        /* Reload Table Array with full produce list */
        
    {
        [self.showFavorite setTitle:@"Show Favorites" forState:UIControlStateNormal];
        [self.showFavorite setTitleColor:FAV_COLOR forState:UIControlStateNormal];
        [self initSeasonList];
        
    }
}

-(void)populateFavoriteArray
{
    self.favoriteArray = [[NSMutableArray alloc]init];
    self.favoriteArray = [self.dataInit findCoreDataFavorite:self.context inMonth:self.currentMonth];
    
    /* reload Table View with Favorites */
    
    self.tableArray = [[NSMutableArray alloc]initWithArray:self.favoriteArray];
    
    [self.inSeasonTableView reloadData];
}

#pragma mark - Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    return [self.tableArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    Produce *item = [self.tableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", item.name];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:30];
    
    
    UIImage *blurredImage = [self blur:[UIImage imageNamed:item.image]];
    UIImageView *blurredView = [[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            cell.bounds.size.width,
                                                                            120)];
    blurredView.image = blurredImage;
    blurredView.contentMode = UIViewContentModeScaleAspectFill;
    cell.backgroundView = [[UIImageView alloc]init];
    [cell.backgroundView addSubview:blurredView];
    cell.backgroundView.clipsToBounds = YES;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

#pragma mark TableView Delegate methods

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            tableView.frame.size.width-10,
                                                            18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,
                                                               tableView.frame.size.width-10,
                                                               18)];
    label.font = [UIFont fontWithName:@"Papyrus" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"IN SEASON NEAR YOU";
    label.textColor = BTN_COLOR;
    
    
    [view addSubview:label];
    view.backgroundColor = BACKGROUND_COLOR;
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            tableView.frame.size.width-10,
                                                            18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                               5,
                                                               tableView.frame.size.width-10,
                                                               18)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"CLICK ON ITEM FOR MORE HARVEST INFO";
    label.textColor = BTN_COLOR;
    
    
    [view addSubview:label];
    view.backgroundColor = BACKGROUND_COLOR;
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProduceViewController *produceVC = [[ProduceViewController alloc]
                                        initWithNibName:@"ProduceViewController"
                                        bundle:nil];
    
    Produce *item = [self.tableArray objectAtIndex:indexPath.row];
    
    produceVC.producePage = [[Produce alloc]init];
    produceVC.producePage = item;
    
    produceVC.produceContext = [[NSManagedObjectContext alloc]init];
    produceVC.produceContext = self.context;
    
    produceVC.title = produceVC.producePage.name;
    
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:produceVC animated:YES];
}

#pragma mark - CALayer method

-(UIImage *)blur:(UIImage *)theImage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
    
    return returnImage;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
