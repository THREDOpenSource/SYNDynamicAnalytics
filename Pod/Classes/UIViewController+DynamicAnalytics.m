//
//  UIViewController+DynamicAnalytics.m
//  SYNDynamicAnalytics
//
//  Created by Sidhant Gandhi on 11/20/14.
//  Copyright (c) 2014 Syntertainment. All rights reserved.
//

#import "UIViewController+DynamicAnalytics.h"
#import <objc/runtime.h>

@implementation UIViewController (DynamicAnalytics)
@dynamic appearTimestamp;
@dynamic disappearTimestamp;
@dynamic analyticsDelegate;
@dynamic recordScreenTimeBlock;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        Class class = [self class];
        
        // We will swizzle multiple methods
        const SEL originalSelectors[] = {@selector(viewDidAppear:), @selector(viewDidDisappear:)};
        const SEL swizzledSelectors[] = {@selector(SYN_viewDidAppear:), @selector(SYN_viewDidDisappear:)};
        
        // Check that we have the same number of original and swizzled selectors
        if (sizeof(originalSelectors) != sizeof(swizzledSelectors)) {
            return;
        }
        
        // Loop over selectors and exchange method implmentations
        for (int i = 0; i < sizeof(originalSelectors); i++) {
            Method originalMethod = class_getInstanceMethod(class, originalSelectors[i]);
            Method swizzledMethod = class_getInstanceMethod(class, swizzledSelectors[i]);
            
            BOOL didAddMethod =
            class_addMethod(class,
                            originalSelectors[i],
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
            
            if (didAddMethod) {
                class_replaceMethod(class,
                                    swizzledSelectors[i],
                                    method_getImplementation(originalMethod),
                                    method_getTypeEncoding(originalMethod));
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    });
}

#pragma mark - Method Swizzling

- (void)SYN_viewDidAppear:(BOOL)animated {
    
    [self setAppearTimestamp];
    
    // Set a notification observer for when the app gets backgrounded / foregrounded
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setAppearTimestamp) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDisappearTimestamp) name:UIApplicationWillResignActiveNotification object:nil];

    // Call the original method (now swizzled)
    [self SYN_viewDidAppear:animated];
}

- (void)SYN_viewDidDisappear:(BOOL)animated {
    
    [self setDisappearTimestamp];
    
    // Remove notification observer for when the app gets backgrounded / foregrounded
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    // Call the orignal method (now swizzled)
    [self SYN_viewDidDisappear:animated];
}

#pragma mark - Associated Objects

/**
 * Getters
 */

- (NSDate *)appearTimestamp {
    return objc_getAssociatedObject(self, @selector(appearTimestamp));
}

- (NSDate *)disappearTimestamp {
    return objc_getAssociatedObject(self, @selector(disappearTimestamp));
}

- (id<SYNDynamicAnalyticsDelegate>)analyticsDelegate {
    return objc_getAssociatedObject(self, @selector(analyticsDelegate));
}

-(void (^)(NSTimeInterval timeInterval))recordScreenTimeBlock {
    return objc_getAssociatedObject(self, @selector(recordScreenTimeBlock));
}

/**
 * Setters
 */

- (void)setAppearTimestamp {
    NSDate *currentTimestamp = [NSDate date];
    objc_setAssociatedObject(self, @selector(appearTimestamp), currentTimestamp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDisappearTimestamp {
    NSDate *currentTimestamp = [NSDate date];
    objc_setAssociatedObject(self, @selector(disappearTimestamp), currentTimestamp, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // Yes, traditionally setters are not supposed to do extraneous things, but
    // because we have a self-contained process here, it makes things much simpler.
    // Log the time interval now that we have a disappear timestamp
    [self logScreenTime];
}


- (void)setAnalyticsDelegate:(id<SYNDynamicAnalyticsDelegate>)analyticsDelegate {
    objc_setAssociatedObject(self, @selector(analyticsDelegate), analyticsDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setRecordScreenTimeBlock:(void (^)(NSTimeInterval timeInterval))recordScreenTimeBlock {
    objc_setAssociatedObject(self, @selector(recordScreenTimeBlock), recordScreenTimeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Logging (Analytics)

- (void)logScreenTime {
    
    // Failsafe, if for some reason we don't have both timestamps
    if (![self appearTimestamp] || ![self disappearTimestamp]) {
        return;
    }
    
    // CFTimeInterval to NSTimeInterval is toll-free bridged
    NSTimeInterval timeOnViewController = [self.disappearTimestamp timeIntervalSinceDate:self.appearTimestamp];
    
    if (self.analyticsDelegate && self.recordScreenTimeBlock) {
        NSLog(@"[%@] Both delegate and block are set. This may result in duplicate logging.", NSStringFromClass(self.class));
    }
    
    // For the delegate, if one is set
    if (self.analyticsDelegate) {
        [self.analyticsDelegate logScreenTime:timeOnViewController];
    }
    
    // For the block, if one is set
    if (self.recordScreenTimeBlock) {
        self.recordScreenTimeBlock(timeOnViewController);
    }
    
    // Reset timestamps as a failsafe (shouln't be necessary)
    objc_setAssociatedObject(self, @selector(appearTimestamp), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(disappearTimestamp), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

@end
