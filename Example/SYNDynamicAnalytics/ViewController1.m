//
//  ViewController.m
//  SYNDynamicAnalytics
//
//  Created by Sidhant Gandhi on 11/20/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import "ViewController1.h"
#import "SYNFakeAnalyticsManager.h"

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set our analytics delegate to self
    self.analyticsDelegate = self;
}

// Implement the one required SYNDynamicAnalyticsDelegate method
- (void)logScreenTime:(NSTimeInterval)timeInterval {
    
    // We can use any analytics package here, SYNFakeAnalyticsManager is for example purposes only.
    [[SYNFakeAnalyticsManager sharedManager] recordScreenTime:timeInterval forScreen:NSStringFromClass(self.class)];
}

@end
