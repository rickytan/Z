//
//  ZFreshmanTests.m
//  ZFreshmanTests
//
//  Created by ricky on 13-12-21.
//  Copyright (c) 2013年 Ricky. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+RExtension.h"

@interface ZFreshmanTests : XCTestCase

@end

@implementation ZFreshmanTests

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
    UIColor *c = [UIColor colorWithHexString:@"#fff"];
}

@end
