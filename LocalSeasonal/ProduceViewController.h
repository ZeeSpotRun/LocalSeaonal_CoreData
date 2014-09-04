//
//  ProduceViewController.h
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 15/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "DataInit.h"



@interface ProduceViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *produceImageView;
@property (strong, nonatomic) UITableView *produceDetailTable;
@property (strong, nonatomic) UIButton *favButton;

@property (strong, nonatomic) DataInit *dataInitialize;
@property (strong, nonatomic) NSManagedObjectContext *produceContext;
@property (strong, nonatomic) Produce *producePage;

@property (strong, nonatomic) NSMutableArray *recipeArray;
@property (strong, nonatomic) NSMutableArray *seasonArray;
@property (strong, nonatomic) NSMutableArray *farmerArray;


-(void)toggleFavoritesData;

@end
