//
//  UITableView+YJBlankView.m
//  YJBlankView
//
//  Created by YJHou on 14/1/10.
//  Copyright © 2014年 YJManager. All rights reserved.
//

#import "UITableView+YJBlankView.h"
#import <objc/runtime.h>

static char const * const kInstallYJLoadingKey      =  "kInstallYJLoadingKey";
static char const * const kLoadedImgNameKey         =  "kLoadedImgNameKey";
static char const * const kTitleForNoDataViewKey    =  "kTitleForNoDataViewKey";
static char const * const kDetailForNoDataView      =  "kDetailForNoDataView";
static char const * const kButtonTitleKey           =  "kButtonTitleKey";
static char const * const kButtonNormalColorKey     =  "kButtonNormalColorKey";
static char const * const kButtonHighlightColorKey  =  "kButtonHighlightColorKey";
static char const * const kVOffsetForNoDataViewKey  =  "kVOffsetForNoDataViewKey";
static char const * const kreloadClickBlockKey      =  "kreloadClickBlockKey";

@interface UITableView ()
@property(nonatomic, copy) reloadClickActionBlock tapBlock;
@end

@implementation UITableView (YJBlankView)

//+ (void)load{
//
//    Method changeMethod = class_getInstanceMethod(self, @selector(abcInBlankView));
//    Method systemMethod = class_getInstanceMethod(self, @selector(initWithFrame:style:));
//    
//    BOOL isAdd = class_addMethod(self, @selector(initWithFrame:style:), method_getImplementation(changeMethod), method_getTypeEncoding(changeMethod));
//    
//    if (isAdd) {
//        class_replaceMethod(self, @selector(abcInBlankView), method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
//    }else{
//        method_exchangeImplementations(systemMethod, changeMethod);
//    }
//}
//
//- (void)abcInBlankView{
//
//}

#pragma mark - Setter & Getter
- (void)setInstallYJLoading:(BOOL)installYJLoading{
    if (self.installYJLoading == installYJLoading) return;
    
    objc_setAssociatedObject(self, kInstallYJLoadingKey, @(installYJLoading), OBJC_ASSOCIATION_ASSIGN);
    
    self.emptyDataSource = self;
    self.emptyDelegate = self;
    [self reloadEmptyView];
}
- (BOOL)installYJLoading{
    return [objc_getAssociatedObject(self, kInstallYJLoadingKey) boolValue];
}

-(void)setLoadedImageName:(NSString *)loadedImageName{
    objc_setAssociatedObject(self, kLoadedImgNameKey, loadedImageName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)loadedImageName{
    return objc_getAssociatedObject(self, kLoadedImgNameKey);
}

- (void)setTitleForNoDataView:(NSString *)titleForNoDataView{
    objc_setAssociatedObject(self, kTitleForNoDataViewKey, titleForNoDataView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)titleForNoDataView{
    return objc_getAssociatedObject(self, kTitleForNoDataViewKey);
}

- (void)setDetailForNoDataView:(NSString *)detailForNoDataView{
    objc_setAssociatedObject(self, kDetailForNoDataView, detailForNoDataView, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)detailForNoDataView{
    return objc_getAssociatedObject(self, kDetailForNoDataView);
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    objc_setAssociatedObject(self, kButtonTitleKey, buttonTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSString *)buttonTitle{
    return objc_getAssociatedObject(self, kButtonTitleKey);
}

-(void)setButtonNormalColor:(UIColor *)buttonNormalColor{
    objc_setAssociatedObject(self, kButtonNormalColorKey, buttonNormalColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)buttonNormalColor{
    return objc_getAssociatedObject(self, kButtonNormalColorKey);
}

-(void)setButtonHighlightColor:(UIColor *)buttonHighlightColor{
    objc_setAssociatedObject(self, kButtonHighlightColorKey, buttonHighlightColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIColor *)buttonHighlightColor{
    return objc_getAssociatedObject(self, kButtonHighlightColorKey);
}

- (void)setVerticalOffsetForNoDataView:(CGFloat)verticalOffsetForNoDataView{
    objc_setAssociatedObject(self, kVOffsetForNoDataViewKey, @(verticalOffsetForNoDataView),OBJC_ASSOCIATION_RETAIN);
}
- (CGFloat)verticalOffsetForNoDataView{
    return [objc_getAssociatedObject(self, kVOffsetForNoDataViewKey) floatValue];
}

- (void)setTapBlock:(reloadClickActionBlock)tapBlock{
    objc_setAssociatedObject(self, kreloadClickBlockKey, tapBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (reloadClickActionBlock)tapBlock{
    return objc_getAssociatedObject(self, kreloadClickBlockKey);
}

#pragma mark - Public API
- (void)loadingWithClickBlock:(reloadClickActionBlock)block{
    if (self.tapBlock) {
        block = self.tapBlock;
    }
    self.tapBlock = block;
}


#pragma mark - YJEmptyDataSource
- (UIView *)emptyViewWithCustomViewInView:(UIScrollView *)scrollView{
    if (self.installYJLoading) {
        
        UIView * emptyView = [[UIView alloc] initWithFrame:scrollView.bounds];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        activityView.center = emptyView.center;
        [emptyView addSubview:activityView];
        
        UILabel * loading = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 15)];
        loading.textAlignment = NSTextAlignmentCenter;
        loading.text = @"加载中...";
        loading.textColor = [UIColor lightGrayColor];
        loading.font = [UIFont systemFontOfSize:11.0f];
        
        CGPoint center = emptyView.center;
        center.y += 25;
        loading.center = center;
        [emptyView addSubview:loading];
        
        return emptyView;
    }else {
        return nil;
    }
}

- (UIImage *)emptyViewImageInView:(UIScrollView *)scrollView{
    if (self.installYJLoading) {
        return nil;
    }else {
        NSString * imageName = @"noDataDefault.png";
        if (self.loadedImageName) {
            imageName = self.loadedImageName;
        }
        return [UIImage imageNamed:imageName];
    }
}

- (NSAttributedString *)emptyViewTitleInView:(UIScrollView *)scrollView{
    if (self.installYJLoading) {
        return nil;
    }else {
        NSString * text = @"暂时无法获取到数据";
        if (self.titleForNoDataView) {
            text = self.titleForNoDataView;
        }
        NSMutableParagraphStyle * paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}

- (NSAttributedString *)emptyViewDetailInView:(UIScrollView *)scrollView{
    if (self.installYJLoading) {
        return nil;
    }else {
        NSString * text = @"没有数据！您可以尝试重新获取";
        if (self.detailForNoDataView) {
            text = self.detailForNoDataView;
        }
        NSMutableParagraphStyle * paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        
        NSDictionary * attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                      NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                      NSParagraphStyleAttributeName: paragraph};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}

- (NSAttributedString *)emptyViewButtonTitleInView:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (self.installYJLoading) {
        return nil;
    }else {
        
        UIColor * textNormalColor = self.buttonNormalColor?self.buttonNormalColor:[UIColor redColor];
        UIColor * textHighlightColor = self.buttonHighlightColor?self.buttonHighlightColor:[UIColor orangeColor];
        UIColor * textColor = (state == UIControlStateNormal)?textNormalColor:textHighlightColor;
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                     NSForegroundColorAttributeName: textColor};
        
        return [[NSAttributedString alloc] initWithString:self.buttonTitle?self.buttonTitle:@"再次刷新" attributes:attributes];
    }
}

- (UIButton *)emptyViewButtonAttributeInView:(UIScrollView *)scrollView forState:(UIControlState)state{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 10, 200, 40);
    [btn.layer setCornerRadius:20];
    [btn.layer setBorderWidth:1];
    [btn.layer setBorderColor:[UIColor orangeColor].CGColor];
    return btn;
}

- (CGFloat)emptyViewVerticalOffsetInView:(UIScrollView *)scrollView{
    if (self.verticalOffsetForNoDataView != 0) {
        return self.verticalOffsetForNoDataView;
    }
    return -10;
}

-(BOOL)emptyViewShouldDisplayInView:(UIScrollView *)scrollView{
    return YES;
}

- (BOOL)emptyViewIsAllowTouchInView:(UIScrollView *)scrollView{
    return !self.installYJLoading;
}

- (BOOL)emptyViewIsAllowScrollInView:(UIScrollView *)scrollView{
    return NO;
}

- (BOOL)emptyViewIsAllowAnimateImageViewInView:(UIScrollView *)scrollView{
    return YES;
}

#pragma mark - YJEmptyDataSetDelegate
- (void)emptyViewInView:(UIScrollView *)scrollView didClickButton:(UIButton *)button{
    if (self.tapBlock) {
        self.tapBlock();
    }
}

//+ (void)load{
//    [self _exchangeOriginalSelector:@selector(reloadData) newSelector:@selector(reloadDataYJLoading) isClassMethod:NO];
//}
//
//+ (void)_exchangeOriginalSelector:(SEL)originalSelector newSelector:(SEL)newSelector isClassMethod:(BOOL)isClassMethod{
//    
//    Class cls = [self class];
//    Method originalMethod;
//    Method swizzledMethod;
//    
//    if (isClassMethod) {
//        originalMethod = class_getClassMethod(cls, originalSelector);
//        swizzledMethod = class_getClassMethod(cls, newSelector);
//    } else {
//        originalMethod = class_getInstanceMethod(cls, originalSelector);
//        swizzledMethod = class_getInstanceMethod(cls, newSelector);
//    }
//    
//    if (!originalMethod) {
//        return;
//    }
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}
//
//
//- (void)reloadDataYJLoading{
//    
//    NSInteger items = 0;
//    id <UITableViewDataSource> dataSource = self.dataSource;
//    
//    NSInteger sections = 1;
//    
//    if (dataSource && [dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
//        sections = [dataSource numberOfSectionsInTableView:self];
//    }
//    
//    if (dataSource && [dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
//        for (NSInteger section = 0; section < sections; section++) {
//            items += [dataSource tableView:self numberOfRowsInSection:section];
//        }
//    }
//    
//    if (items == 0) {
//        self.installYJLoading = NO;
//    }
//    
//    [self reloadDataYJLoading];
//}

@end
