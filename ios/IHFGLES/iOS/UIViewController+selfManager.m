//
//  UIViewController+selfManager.m
//  Simple_Texture2D
//
//  Created by v.q on 15/12/20.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import "UIViewController+selfManager.h"

@implementation UIViewController (selfManager)
- (BOOL)installGLK:(UIViewController *)glkVC WithRect:(CGRect)rect
{
    [self.view addSubview:glkVC.view];
    [self addChildViewController:glkVC];
    glkVC.view.frame = rect;
    return YES;
}

- (BOOL)installGLK:(UIViewController *)glkVC WithRect:(CGRect)rect ToView:(UIView *)view
{
    [view addSubview:glkVC.view];
    [self addChildViewController:glkVC];
    glkVC.view.frame = rect;
    return YES;
}

- (BOOL)insertGLK:(UIViewController *)glkVC WithRect:(CGRect)rect ToView:(UIView *)view belowSubview:(UIView *)subView
{
    [view insertSubview:glkVC.view belowSubview:subView];
    [self addChildViewController:glkVC];
    glkVC.view.frame = rect;
    return YES;
}

- (BOOL)uninstallGLK:(UIViewController *)glkVC
{
    [glkVC.view removeFromSuperview];
    [glkVC removeFromParentViewController];
    glkVC = nil;
    return YES;
}
@end
