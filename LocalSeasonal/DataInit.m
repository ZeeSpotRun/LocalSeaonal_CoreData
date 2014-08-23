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
    
    NSMutableArray *returnArray = [self findCurrentProduce:month];
    
    return returnArray;
}

#pragma Mark Initialize CoreData Context methods

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

#pragma mark initialize CoreData database - Methods

-(void)initCoreData:(NSManagedObjectContext*)context{
    
    self.fullProduceArray = [[NSMutableArray alloc]initWithArray:[self inSeasonTableArrayInit]];
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


-(NSMutableArray *)inSeasonTableArrayInit
{
    
    
    Produce *apricot = [[Produce alloc]init];
    apricot.name = @"Apricots";
    apricot.image = @"apricot3.jpg";
    apricot.recipeURL  = @"http://smittenkitchen.com/blog/category/fruit/apricots/";
    apricot.inSeason = @"July,August,September";
    apricot.favorite = @"No";
    
    Produce *plum = [[Produce alloc]init];
    plum.name = @"Plums";
    plum.image = @"plum2.jpeg";
    plum.inSeason = @"July,August";
    plum.recipeURL = @"http://smittenkitchen.com/blog/2013/10/purple-plum-torte/";
    plum.favorite = @"No";
    
    Produce *apple = [[Produce alloc]init];
    apple.name = @"Apples";
    apple.image = @"apple2.jpeg";
    apple.inSeason = @"July,August,September,October";
    apple.recipeURL = @"http://smittenkitchen.com/apples/";
    apple.favorite = @"No";
    
    Produce *blueberry = [[Produce alloc]init];
    blueberry.name = @"Blueberries";
    blueberry.image = @"blueberry2.jpeg";
    blueberry.inSeason = @"July,August,September";
    blueberry.recipeURL =@"http://smittenkitchen.com/blog/category/fruit/blueberries/";
    blueberry.favorite = @"No";
    
    Produce *currant = [[Produce alloc]init];
    currant.name = @"Currants";
    currant.image = @"currants3.jpeg";
    currant.inSeason = @"August";
    currant.recipeURL =@"http://www.davidlebovitz.com/2011/06/red-currant-jam-recipe/";
    currant.favorite = @"No";
    
    Produce *peach = [[Produce alloc]init];
    peach.name = @"Peaches";
    peach.image = @"peach3.jpeg";
    peach.inSeason = @"July,August,September";
    peach.recipeURL = @"http://www.davidlebovitz.com/2012/08/peach-shortcake-recipe/";
    peach.favorite = @"No";
    
    Produce *grape = [[Produce alloc]init];
    grape.name = @"Grapes";
    grape.image = @"grape1.jpg";
    grape.inSeason = @"September,October";
    grape.recipeURL = @"http://www.davidlebovitz.com/2008/09/fresh-grape-sherbet/";
    grape.favorite = @"No";

    NSMutableArray *initArray = [[NSMutableArray alloc]initWithObjects:apple, apricot, blueberry, currant, grape, peach, plum, nil];
    
    
    return initArray;
}

#pragma mark produce for current season - Methods

-(NSMutableArray *)findCurrentProduce:(NSString *)month
{
    /* Intialize season's array of produce from "fullProduceArray" with current month */
    
    NSMutableArray *thisSeasonsArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<=[self.fullProduceArray count]-1; i++)
    {
        Produce *thisSeasonProduce = [[Produce alloc]init];
        thisSeasonProduce = self.fullProduceArray[i];
        
        /* Get array of produce's "in season" months to compare to current month */
        
        NSMutableArray *monthList = [[NSMutableArray alloc]initWithArray:[self createArray:thisSeasonProduce.inSeason]];
        
        for (int j=0; j<[monthList count]; j++)
        {
            if ([monthList[j] isEqualToString:month])
            {
                [thisSeasonsArray addObject:thisSeasonProduce];
            }
        }
        
    }
    
    return thisSeasonsArray;
}

-(NSString *)findCurrentMonth
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMMM"];
    
    NSString *monthString = [dateFormatter stringFromDate:date];
    
    return monthString;
}

-(NSString *)findNextMonth:(NSString *)fromDate
{
    NSDate *date = [self dateFromString:fromDate];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setMonth:1];
    
    NSDate *nextMonth = [gregorian dateByAddingComponents:components toDate:date options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMMM"];
    
    NSString *monthString = [dateFormatter stringFromDate:nextMonth];
    
    return monthString;
}

-(NSString *)findPreviousMonth:(NSString *)fromDate
{
    NSDate *date = [self dateFromString:fromDate];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setMonth:-1];
    
    NSDate *nextMonth = [gregorian dateByAddingComponents:components toDate:date options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"MMMM"];
    
    NSString *monthString = [dateFormatter stringFromDate:nextMonth];
    
    return monthString;
}

-(NSDate *)dateFromString:(NSString *)dateString
{
    
    // convert it into NSDate object
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMMM"];
    NSDate *theDate = [formatter dateFromString:dateString];
    
    NSLog(@"Your Date Object is %@", theDate);
    
    return theDate;
    
}

-(NSArray *)createArray:(NSString *)fromString
{
    
    NSArray *arrayComponents = [fromString componentsSeparatedByString:@","];
    return arrayComponents;
    
}

@end
