//
//  SYNFakeAnalytics.m
//  SYNDynamicAnalytics
//
//  Created by Sidhant Gandhi on 11/20/14.
//  Copyright (c) 2014 Sidhant Gandhi. All rights reserved.
//

#import "SYNFakeAnalyticsManager.h"
#import "CWStatusBarNotification.h"

@implementation SYNFakeAnalyticsManager

+ (instancetype)sharedManager
{
    static id sharedManager;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)recordScreenTime:(NSTimeInterval)timeInterval forScreen:(NSString *)screen {
    NSLog(@"[ANALYTICS] Time on %@: %f", screen, timeInterval);
    
    CWStatusBarNotification *notification = [CWStatusBarNotification new];
    notification.notificationLabelBackgroundColor = [UIColor orangeColor];
    notification.notificationLabelFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0];
    notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
    [notification displayNotificationWithMessage:[NSString stringWithFormat:@"Time on %@: %.1f seconds", screen, timeInterval] forDuration:2.0];
}

@end
