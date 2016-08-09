//
//  PythonServierDemoTests.m
//  PythonServierDemoTests
//
//  Created by linhua hu on 16/7/29.
//  Copyright © 2016年 linhua hu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IHFAccountNet.h"
@interface PythonServierDemoTests : XCTestCase

@end

@implementation PythonServierDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
   
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSDictionary *dic = @{@"accontIDStr":@"18916259021",@"newPW":@"HUhu0007"};
    [IHFAccountNet changePasswordAPI:dic callBack:^(NSNumber *success, id response) {
        
        
        NSLog(@"&&&&&&&&&&&&&&&&&&______   %@",response);
        
        NSLog(@"aaa");
        
        
    }];
    [super tearDown];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
