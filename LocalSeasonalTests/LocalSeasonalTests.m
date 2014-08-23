//
//  LocalSeasonalTests.m
//  LocalSeasonalTests
//
//  Created by Makeba Zoe Malcolm on 27/07/14.
//  Copyright (c) 2014 Zoe Malcolm. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface LocalSeasonalTests : XCTestCase

@end

@implementation LocalSeasonalTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
   
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        
        [dateFormatter setDateFormat:@"MMMM"];
        
        NSString *monthString = [dateFormatter stringFromDate:date];
        
        NSLog(@"This Month = %@", monthString);
    XCTAssertEqualObjects(@"August", monthString);
}

@end
