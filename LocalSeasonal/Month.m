//
//  Month.m
//  LocalSeasonal
//
//  Created by Makeba Zoe Malcolm on 26/08/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import "Month.h"

@implementation Month

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
   
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setMonth:1];
    
    NSString *nextMonth = [self findMonth:components fromDate:fromDate];
    return nextMonth;
    
}

-(NSString *)findPreviousMonth:(NSString *)fromDate
{
  
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setMonth:-1];
    
    NSString *previousMonth = [self findMonth:components fromDate:fromDate];
    return previousMonth;
    
   
}

-(NSString*)findMonth:(NSDateComponents *)components fromDate:(NSString*)dateString
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMMM"];
    
    NSDate *date = [formatter dateFromString:dateString];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *nextMonth = [gregorian dateByAddingComponents:components toDate:date options:0];
    
    NSString *monthString = [formatter stringFromDate:nextMonth];
    
    return monthString;

}


@end
