//
//  UIView+HierarchySupport.m
//  Simple_Texture2D
//
//  Created by v.q on 15/12/21.
//  Copyright © 2015年 Daniel Ginsburg. All rights reserved.
//

#import "UIView+HierarchySupport.h"
#import "IHFMyGLKViewController+instance.h"
#import "UIViewController+selfManager.h"
@implementation UIView (HierarchySupport)
- (NSArray *)superviews
{
    NSMutableArray *array = [NSMutableArray array];
    UIView *view = self.superview;
    while (view) {
        [array addObject:view];
        view = view.superview;
    }
    return [array copy];
}

- (BOOL)isAncestorOfView:(UIView *)aView
{
    return [[aView superviews]containsObject:self];
}

- (UIView *)nearestCommonAncestorToView:(UIView *)aView
{
    if ([self isEqual:aView]) {
        return self;
    }
    if ([self isAncestorOfView:aView]) {
        return self;
    }
    if ([aView isAncestorOfView:self]) {
        return aView;
    }
    NSArray *ancestors = self.superviews;
    for (UIView *view in aView.superviews) {
        if ([ancestors containsObject:view]) {
            return view;
        }
    }
    return nil;
}

- (void)addSubGLViewController:(IHFMyGLKViewController *)glVC InRect:(CGRect)rect InVc:(UIViewController *)vc
{
    [vc installGLK:glVC WithRect:rect ToView:self];
}

- (void)insertGLViewController:(IHFMyGLKViewController *)glVC belowSubview:(UIView *)view InRet:(CGRect)rect InVc:(UIViewController *)vc
{
    [vc insertGLK:glVC WithRect:rect ToView:self belowSubview:view];
}

- (void)removeGLViewController:(IHFMyGLKViewController *)glVC
{
    UIViewController *VC = [UIView getCurrentViewControllerAtView:self];
    [VC uninstallGLK:glVC];
}

- (void)addSubviewInController:(UIView *)view
{
    CGFloat glViewX = self.superview.frame.origin.x + self.frame.origin.x + view.frame.origin.x;
    CGFloat glViewY = self.superview.frame.origin.y + self.frame.origin.y + view.frame.origin.y;
    CGFloat glViewW = view.frame.size.width;
    CGFloat glViewH = view.frame.size.height;
    
    CGRect relativeRect = CGRectMake(glViewX, glViewY, glViewW, glViewH);
    view.frame = relativeRect;
    UIViewController *VC = [UIView getCurrentViewControllerAtView:self];
    [VC.view addSubview:view];
}

+ (UIViewController *)getCurrentViewControllerAtView:(UIView *)view
{
    
    for (UIView *next = view.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (id)nextResponder;
            
        }
    }
    return nil;
}

@end
