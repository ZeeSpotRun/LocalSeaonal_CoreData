//
//  ProduceViewController.m
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 15/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import "ProduceViewController.h"

@interface ProduceViewController ()

@end

@implementation ProduceViewController

@synthesize dataInitialize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self.produceDetailTable reloadData];
    
}

/* Image for Image View, Table View set-up and data source, Create "Favorites" Button */

-(void)viewWillAppear:(BOOL)animated
{
    
    dataInitialize = [[DataInit alloc]init];
    
    [self.produceImageView setImage:[UIImage imageNamed:self.producePage.image]];
    
    self.produceDetailTable = [[UITableView alloc]initWithFrame:CGRectMake(5, 250, self.view.bounds.size.width-10, 275) style:UITableViewStylePlain];
    self.produceDetailTable.delegate = self;
    self.produceDetailTable.dataSource = self;
    self.produceDetailTable.backgroundColor = BACKGROUND_COLOR;
    [self.produceDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.produceDetailTable];
    
    
    self.recipeArray = [[NSMutableArray alloc]initWithObjects:self.producePage.recipeURL, nil];
    self.seasonArray = [[NSMutableArray alloc]initWithArray:[dataInitialize createMonthArray:self.producePage.inSeason]];
    
    [self createFavButton];
    

}

-(void)createFavButton
{
    self.favButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.favButton.frame = CGRectMake(0, 215, self.view.bounds.size.width, 30);

    self.favButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [self.favButton addTarget:self action:@selector(toggleFavoritesData) forControlEvents:UIControlEventTouchUpInside];
    
    // Set Title of FavButton
    
    if ([self.producePage.favorite isEqualToString:@"No"]) {
        [self.favButton setTitle:@"Add To Favorites" forState:UIControlStateNormal];
        [self.favButton setTintColor:FAV_COLOR];
    } else {
        [self.favButton setTitle:@"Remove from Favorites" forState:UIControlStateNormal];
        [self.favButton setTintColor:[UIColor blueColor]];
    }
    
    self.favButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.favButton];
    
}

#pragma  mark TableView Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return [self.seasonArray count];
        
    } else if (section == 1) {
        
        return [self.recipeArray count];
        
    } else {
        
        return 1;
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /* Create custom view to display section header... */
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            0,
                                                            tableView.frame.size.width-10,
                                                            18)];
    view.backgroundColor = BACKGROUND_COLOR;
    
    /*Create label to attach to custom view*/
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,
                                                               tableView.frame.size.width-10,
                                                               18)];
    label.font = [UIFont fontWithName:@"Papyrus" size:18];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = BTN_COLOR;

    if (section == 0) {
        label.text = @"LIST MONTHS IN SEASON";
    } else {
        label.text = @"TAP FOR RECIPES";
    }
    
    [view addSubview:label];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.seasonArray[indexPath.row]];
    } else if (indexPath.section == 1) {
        cell.textLabel.text =[NSString stringWithFormat:@"Recipes for %@", self.title];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Chalkduster" size:20];
    cell.backgroundColor = BACKGROUND_COLOR;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /* Push Recipe Web View */
    
    if (indexPath.section == 1) {
        RecipeViewController *recipeVC = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
        
        NSString *recipeWebsite = [self.recipeArray objectAtIndex:indexPath.row];
        recipeVC.fullURL = recipeWebsite;
        recipeVC.title = @"Recipes";
        
        [self.navigationController pushViewController:recipeVC animated:YES];
        
    }
}

-(void)toggleFavoritesData
{
    
    if ([self.producePage.favorite isEqualToString: @"No"])
    {
        self.producePage.favorite = @"Yes";
        [self.favButton setTitle:@"Remove from Favorites" forState:UIControlStateNormal];
        [self.favButton setTintColor:[UIColor blueColor]];

    }
    else
    {
        self.producePage.favorite = @"No";
        [self.favButton setTitle:@"Add to Favorites" forState:UIControlStateNormal];
        [self.favButton setTintColor:FAV_COLOR];
    }
    
    [dataInitialize editCoreDataFavorite:self.producePage withContext:self.produceContext];
    
}

@end
