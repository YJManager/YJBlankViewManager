//
//  UIScrollView+YJBlankView.h
//  YJBlankView
//
//  Created by YJHou on 14/1/10.
//  Copyright © 2014年 YJManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJEmptyDataSource <NSObject>

@optional
/** Image */
- (UIImage *)emptyViewImageInView:(UIScrollView *)scrollView;

/** imageTintColor */
- (UIColor *)emptyViewImageTintColorInView:(UIScrollView *)scrollView;

/** imageAnimation */
- (CAAnimation *)emptyViewImageAnimationInView:(UIScrollView *) scrollView;

/** title */
- (NSAttributedString *)emptyViewTitleInView:(UIScrollView *)scrollView;

/** detail */
- (NSAttributedString *)emptyViewDetailInView:(UIScrollView *)scrollView;

/** buttonTitle */
- (NSAttributedString *)emptyViewButtonTitleInView:(UIScrollView *)scrollView forState:(UIControlState)state;

/** ButtonAttribute */
- (UIButton *)emptyViewButtonAttributeInView:(UIScrollView *)scrollView forState:(UIControlState)state;

/** backgroundColor Default is ClearColor */
- (UIColor *)emptyViewBackgroundColorInView:(UIScrollView *)scrollView;

/** customView  Default is nil. Returning a custom view will ignore -emptyViewSpaceHeightInView configurations. */
- (UIView *)emptyViewWithCustomViewInView:(UIScrollView *)scrollView;

/** VerticalOffset Default is CGPointZero. */
- (CGFloat)emptyViewVerticalOffsetInView:(UIScrollView *)scrollView;

/** vertical space Default is 11 pts. */
- (CGFloat)emptyViewSpaceHeightInView:(UIScrollView *)scrollView;

/** fadeInOnDisplay Default is YES. */
- (BOOL)emptyViewShouldFadeInInView:(UIScrollView *)scrollView;

/** Default is YES. */
- (BOOL)emptyViewShouldDisplayInView:(UIScrollView *)scrollView;

/** Default is YES. */
- (BOOL)emptyViewIsAllowTouchInView:(UIScrollView *)scrollView;

/** Default is NO. */
- (BOOL)emptyViewIsAllowScrollInView:(UIScrollView *)scrollView;

/**  Default is NO. */
- (BOOL)emptyViewIsAllowAnimateImageViewInView:(UIScrollView *)scrollView;

@end


@protocol YJEmptyDelegate <NSObject>

@optional
- (void)emptyViewInView:(UIScrollView *)scrollView didClickView:(UIView *)view;
- (void)emptyViewInView:(UIScrollView *)scrollView didClickButton:(UIButton *)button;

/** lifecycle */
- (void)emptyViewWillAppearInView:(UIScrollView *)scrollView;
- (void)emptyViewDidAppearInView:(UIScrollView *)scrollView;
- (void)emptyViewWillDisappearInView:(UIScrollView *)scrollView;
- (void)emptyViewDidDisappearInView:(UIScrollView *)scrollView;

@end

@interface UIScrollView (YJBlankView)

@property (nonatomic, weak) id<YJEmptyDataSource> emptyDataSource;
@property (nonatomic, weak) id<YJEmptyDelegate>   emptyDelegate;
@property (nonatomic, readonly, getter=isEmptyViewVisible) BOOL emptyViewVisible;

/** reloads everything from scratch. */
- (void)reloadEmptyView;

@end
