//
//  ViewController2.m
//  SYNDynamicAnalytics
//
//  Created by Sidhant Gandhi on 11/20/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import "ViewController2.h"
#import "UIViewController+DynamicAnalytics.h"
#import "SYNFakeAnalyticsManager.h"

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set our block to record analytics events
    __weak UIViewController* weakSelf = self; // Avoid retain cycle since we strongly retain the block
    [self setRecordScreenTimeBlock:^(NSTimeInterval timeInterval) {
        
        // We can use any analytics package here, SYNFakeAnalyticsManager is for example purposes only.
        [[SYNFakeAnalyticsManager sharedManager] recordScreenTime:timeInterval forScreen:NSStringFromClass(weakSelf.class)];
    }];
}

@end