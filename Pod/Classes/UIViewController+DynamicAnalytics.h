//
//  UIViewController+DynamicAnalytics.h
//  SYNDynamicAnalytics
//
//  Created by Sidhant Gandhi on 11/20/14.
//  Copyright (c) 2014 Syntertainment. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SYNDynamicAnalyticsDelegate <NSObject>

@required

- (void)logScreenTime:(NSTimeInterval)timeInterval;

@end

@interface UIViewController (DynamicAnalytics)

@property (nonatomic, strong) NSDate *appearTimestamp;
@property (nonatomic, strong) NSDate *disappearTimestamp;
@property (nonatomic, strong) id <SYNDynamicAnalyticsDelegate> analyticsDelegate;
@property (nonatomic, copy) void (^recordScreenTimeBlock)(NSTimeInterval timeInterval); /*  Make sure if you use a block, not to reference self in it. 
                                                                                            May result in retain cycle.
                                                                                            Instead use a weak reference to self. */

@end
