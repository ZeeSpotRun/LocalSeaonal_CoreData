//
//  Produce.h
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 30/07/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Produce : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *inSeason;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *recipeURL;
@property (strong, nonatomic) NSString *favorite;

-(NSMutableArray *)produceArrayInit;

@end
