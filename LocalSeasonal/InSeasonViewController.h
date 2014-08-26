//
//  InSeasonViewController.h
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 15/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DataInit.h"
#import "ProduceViewController.h"
#import "Month.h"

@interface InSeasonViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIImageView *inSeasonImageView;
@property (strong, nonatomic) UITableView *inSeasonTableView;

@property (strong, nonatomic) NSMutableArray *tableArray;
@property (strong, nonatomic) NSMutableArray *favoriteArray;
@property (strong, nonatomic) DataInit *dataInit;

@property (strong, nonatomic) Month *monthSearch;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSString *currentMonth;
@property (strong, nonatomic) UIBarButtonItem *previousMonthBtn;
@property (strong, nonatomic) UIBarButtonItem *nextMonthBtn;

@property (strong, nonatomic) UIToolbar *inSeasonTab;
@property (strong, nonatomic) UIButton *showFullProduceArray;
@property (strong, nonatomic) UIButton *showFavorite;


-(void)toggleFavorites;
-(void)populateFavoriteArray;


@end
