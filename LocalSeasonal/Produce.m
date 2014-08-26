//
//  Produce.m
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 30/07/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import "Produce.h"

@implementation Produce


-(NSMutableArray *)produceArrayInit
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

@end
