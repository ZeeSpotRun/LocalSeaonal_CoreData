//
//  DataInit.h
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 30/07/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Produce.h"

#define FAV_COLOR [UIColor colorWithRed:45/255.0f green:179/255.0f blue:11/255.0f alpha:1]
#define BTN_COLOR [UIColor colorWithRed:5.0f/255.0f green:111.0f/255.0f blue:115.0f/255.0f alpha:1.0]
#define BACKGROUND_COLOR [UIColor colorWithRed:115.0f/255.0f green:202.0f/255.0f blue:184.0f/255.0f alpha:1.0];



@interface DataInit : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSMutableArray *fullProduceArray;

#pragma mark CoreData Methods
-(NSManagedObjectContext*)managedObjectContextInit;
-(NSMutableArray *)importCoreDataWithContext:(NSManagedObjectContext*)context forMonth:(NSString*)month;
-(NSMutableArray *)findCurrentProduce:(NSString *)month withContext:(NSManagedObjectContext *)context;

 /* "Favorite" Methods */
-(void)editCoreDataFavorite:(Produce *)produceFav withContext:(NSManagedObjectContext*)context;
-(NSMutableArray *)findCoreDataFavorite:(NSManagedObjectContext*)context inMonth:(NSString *)month;

-(NSArray *)createMonthArray:(NSString *)fromString;

@end
