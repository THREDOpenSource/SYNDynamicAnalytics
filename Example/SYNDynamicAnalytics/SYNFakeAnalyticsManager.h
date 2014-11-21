//
//  SYNFakeAnalytics.h
//  SYNDynamicAnalytics
//
//  Created by Sidhant Gandhi on 11/20/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SYNFakeAnalyticsManager : NSObject

+ (instancetype)sharedManager;
- (void)recordScreenTime:(NSTimeInterval)timeInterval forScreen:(NSString *)screen;

@end
