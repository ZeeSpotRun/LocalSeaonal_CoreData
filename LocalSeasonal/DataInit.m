//
//  DataInit.m
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 30/07/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import "DataInit.h"

@implementation DataInit

@synthesize model = _model;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize context =_context;


//import produce data from CoreData

-(NSMutableArray *)importCoreDataWithContext:(NSManagedObjectContext*)context forMonth:(NSString*)month {
    
    /* Initialize "fullProduceArray" with data from CoreData database */
    
if (self.fullProduceArray == nil)
    {
        self.fullProduceArray = [[NSMutableArray alloc]init];
        
        NSEntityDescription *entityProduce = [NSEntityDescription entityForName:@"Produce" inManagedObjectContext:context];
        NSFetchRequest *produceRequest = [[NSFetchRequest alloc]init];
        [produceRequest setEntity:entityProduce];
        NSManagedObject *dataItem;
        
        NSError *errorMsg;
        NSArray *produceResults = [context executeFetchRequest:produceRequest error:&errorMsg];
        
        
        if([produceResults count] > 0) {
            for (int i=0;i<[produceResults count];i++){
                dataItem = produceResults[i];
                Produce *produce = [[Produce alloc]init];
                produce.name = [dataItem valueForKey:@"name"];
                produce.image = [dataItem valueForKey:@"image"];
                produce.recipeURL = [dataItem valueForKey:@"recipeURL"];
                produce.inSeason = [dataItem valueForKey:@"season"];
                produce.favorite = [dataItem valueForKey:@"favorite"];
                
                [self.fullProduceArray addObject:produce];
            }
        
            } else {
        
                NSLog (@"No Data Found. Now initialize data.");
                [self initCoreData:context];
    }


} else {
        
        NSLog(@"FullProduceArray already populated");
    }
    
    NSMutableArray *returnArray = [self findCurrentProduce:month withContext:context];
    
    return returnArray;
}

#pragma Mark Initialize CoreData Context

-(NSManagedObjectModel *) managedObjectModel {
    if (_model !=nil) {
        return _model;
        NSLog(@"model found");
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LocalSeasonalFav" withExtension:@"momd"];
    _model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _model;
}

-(NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if (_persistentStoreCoordinator !=nil) {
        return _persistentStoreCoordinator;
        NSLog(@"store found");
    }
    
    NSError * error;
    // retrieve the store URL
    NSURL * storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LocalSeasonalFav.sqlite"];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

-(NSURL *) applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSManagedObjectContext*)managedObjectContextInit {
    if (_context !=nil) {
        return _context;
        NSLog(@"context found");
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    _context = [[NSManagedObjectContext alloc]init];
    [_context setPersistentStoreCoordinator:coordinator];
    
    return _context;
}

/* populate CoreData database - Methods */

-(void)initCoreData:(NSManagedObjectContext*)context{
    
    Produce *produceMaker = [[Produce alloc]init];
    self.fullProduceArray = [[NSMutableArray alloc]initWithArray:[produceMaker produceArrayInit]];
    
    for (int i = 0; i<[self.fullProduceArray count];i++) {
        
        Produce *produce = [[Produce alloc]init];
        produce = self.fullProduceArray[i];
        NSManagedObject *newProduce = [NSEntityDescription insertNewObjectForEntityForName:@"Produce"
                                                                    inManagedObjectContext:context];
        
        [newProduce setValue:produce.name forKey:@"name"];
        [newProduce setValue:produce.image forKey:@"image"];
        [newProduce setValue:produce.recipeURL forKey:@"recipeURL"];
        [newProduce setValue:produce.inSeason forKey:@"season"];
        [newProduce setValue:produce.favorite forKey:@"favorite"];
        NSError *err;
        [context save:&err];

    }
}

 /* Manage Favorites - Methods*/

-(void)editCoreDataFavorite:(Produce *)produceFav withContext:(NSManagedObjectContext*)context
{
    NSEntityDescription *produceDesc = [NSEntityDescription entityForName:@"Produce" inManagedObjectContext:context];
    
    NSManagedObject *editProduce = [[NSManagedObject alloc]initWithEntity:produceDesc insertIntoManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:produceDesc];
    
    NSPredicate *produceCriteria = [NSPredicate predicateWithFormat:@"(name = %@)", produceFav.name];
    [request setPredicate:produceCriteria];
    
    NSError *err;
    NSArray *produceMatches = [context executeFetchRequest:request error:&err];
    
    if ([produceMatches count] == 0) {
        NSLog(@"Produce Not Found");
    } else {
    
        editProduce = produceMatches[0];
    
        [editProduce setValue:produceFav.favorite forKey:@"favorite"];
        [context save:&err];
        
        NSLog(@"Favorite Status Changed");
    }
    
}


-(NSMutableArray *)findCoreDataFavorite:(NSManagedObjectContext*)context inMonth:(NSString *)month
{
    NSEntityDescription *produceDesc = [NSEntityDescription entityForName:@"Produce" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:produceDesc];
    
    NSPredicate *produceCriteria = [NSPredicate predicateWithFormat:@"(favorite = %@) AND (season CONTAINS %@)", @"Yes", month];
    [request setPredicate:produceCriteria];
    
    NSError *err;
    NSArray *produceMatches = [context executeFetchRequest:request error:&err];
    
    NSManagedObject *favCoreDataProduce;
    NSMutableArray *favArray = [[NSMutableArray alloc]init];
    
    if ([produceMatches count] == 0) {
        NSLog(@"Produce Not Found");
    } else {
        
        for (int i = 0; i < [produceMatches count]; i++)
        {
            favCoreDataProduce = produceMatches[i];
            Produce *favProduce = [[Produce alloc]init];
            favProduce.name = [favCoreDataProduce valueForKey:@"name"];
            favProduce.image = [favCoreDataProduce valueForKey:@"image"];
            favProduce.recipeURL = [favCoreDataProduce valueForKey:@"recipeURL"];
            favProduce.inSeason = [favCoreDataProduce valueForKey:@"season"];
            favProduce.favorite = [favCoreDataProduce valueForKey:@"favorite"];
            
            [favArray addObject:favProduce];
            
        }
    }
    
    return favArray;
}


/* Populate array of current Produce */

-(NSMutableArray *)findCurrentProduce:(NSString *)month withContext:(NSManagedObjectContext *)context
{
    
    NSEntityDescription *produceDesc = [NSEntityDescription entityForName:@"Produce" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:produceDesc];
    
    NSPredicate *produceCriteria = [NSPredicate predicateWithFormat:@"(season CONTAINS %@)", month];
    [request setPredicate:produceCriteria];
    
    NSError *err;
    NSArray *produceMatches = [context executeFetchRequest:request error:&err];
    
    NSManagedObject *currentCoreDataProduce;
    NSMutableArray *currentArray = [[NSMutableArray alloc]init];
    
    if ([produceMatches count] == 0) {
        
        NSLog(@"Produce Not Found");
        [self initCoreData:context];
        
    } else {
        
        for (int i = 0; i < [produceMatches count]; i++)
        {
            currentCoreDataProduce = produceMatches[i];
            Produce *currentProduce = [[Produce alloc]init];
            currentProduce.name = [currentCoreDataProduce valueForKey:@"name"];
            currentProduce.image = [currentCoreDataProduce valueForKey:@"image"];
            currentProduce.recipeURL = [currentCoreDataProduce valueForKey:@"recipeURL"];
            currentProduce.inSeason = [currentCoreDataProduce valueForKey:@"season"];
            currentProduce.favorite = [currentCoreDataProduce valueForKey:@"favorite"];
            
            [currentArray addObject:currentProduce];
            
        }
    }
    
    return currentArray;
}

/* Create Array of months from "inSeason" Produce property*/

-(NSArray *)createMonthArray:(NSString *)fromString
{
    
    NSArray *arrayComponents = [fromString componentsSeparatedByString:@","];
    return arrayComponents;
    
}

 /* In case needed to re-boot Core Data */

-(void)deleteAllProduce:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Produce" inManagedObjectContext:context];
    NSFetchRequest *produceRequest = [[NSFetchRequest alloc]init];
    [produceRequest setEntity:entityDesc];
    
    NSManagedObject *deleteProduce;
    NSError *err;
    NSArray *results = [context executeFetchRequest:produceRequest error:&err];
    
    for (int i=0; i<[results count]; i++) {
        deleteProduce = results[i];
        [context deleteObject:deleteProduce];
        NSLog(@"Deleted Object = %@", [self.context deletedObjects]);
        [self.context save:&err];
        
    }
    
}


@end
