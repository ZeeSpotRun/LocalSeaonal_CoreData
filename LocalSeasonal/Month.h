//
//  Month.h
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 26/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Month : NSObject

-(NSString *)findNextMonth:(NSString *)fromDate;
-(NSString *)findPreviousMonth:(NSString *)fromDate;
-(NSString *)findCurrentMonth;

@end
