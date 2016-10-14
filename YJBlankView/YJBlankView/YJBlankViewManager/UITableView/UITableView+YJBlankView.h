//
//  UITableView+YJBlankView.h
//  YJBlankView
//
//  Created by YJHou on 14/1/10.
//  Copyright © 2014年 YJManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+YJBlankView.h"

typedef void (^reloadClickActionBlock)();

@interface UITableView (YJBlankView) <YJEmptyDataSource, YJEmptyDelegate>

/** YES is install YJLoading */
@property (nonatomic, assign) BOOL installYJLoading;
/** custom Image */
@property (nonatomic, copy) NSString * loadedImageName;
/** nodata Title */
@property (nonatomic, copy) NSString * titleForNoDataView;
/** detailForNoDataView */
@property (nonatomic, copy) NSString * detailForNoDataView;
/** button title */
@property (nonatomic, copy) NSString * buttonTitle;
/** buttonNormalColor */
@property (nonatomic, strong) UIColor * buttonNormalColor;
/** buttonHighlightColor */
@property (nonatomic, strong) UIColor * buttonHighlightColor;
/** tableView Center Offset */
@property (nonatomic, assign) CGFloat verticalOffsetForNoDataView;

- (void)loadingWithClickBlock:(reloadClickActionBlock)block;


@end
