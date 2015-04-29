//
//  CustomUISearchDisplayController.m
//  SearchDemo
//
//  Created by JatWaston on 15/4/29.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import "CustomUISearchDisplayController.h"

@implementation CustomUISearchDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated {
    if(self.active == visible) {
        return;
    }
    [super setActive:visible animated:animated];
    NSArray *subViews = self.searchContentsController.view.subviews;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        for (UIView *view in subViews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchDisplayControllerContainerView")]) {
                NSArray *sub = view.subviews;
                ((UIView*)sub[2]).hidden = YES;
            }
        }
    } else {
        [[subViews lastObject] removeFromSuperview];
    }
}

@end
