//
//  JRLoopView.h
//  JRLoopView
//
//  Created by wxiao on 16/1/9.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JRTransitionAnimateType) {
	JRTransitionAnimateTypePush = 0,
	JRTransitionAnimateTypeFade,
	JRTransitionAnimateTypeMoveIn,
	JRTransitionAnimateTypeReveal,
	JRTransitionAnimateTypeCube,
	JRTransitionAnimateTypeOglFlip,
	JRTransitionAnimateTypeSuckEffect,
	JRTransitionAnimateTypeRippleEffect,
	JRTransitionAnimateTypePageCurl,
	JRTransitionAnimateTypePageUncurl,
	JRTransitionAnimateTypeCameraIrisHollowOpen,
	JRTransitionAnimateTypeCameraIrisHollowClose
};

@class JRLoopView;
@protocol JRLoopViewDataSource <NSObject>
@required
- (NSArray *)imageNumberOfJRLoop:(JRLoopView *)loopView;
@end

@protocol JRLoopViewDelegte <NSObject>
@optional
- (void)loopViewDidClicked:(JRLoopView *)loopView atIndex:(NSInteger)index;
- (void)loopViewChaned:(JRLoopView *)loopView withDirection:(NSInteger)direction toIndex:(NSInteger)index byAuto:(BOOL)isAuto;
- (void)loopViewChanedToRight:(JRLoopView *)loopView toIndex:(NSInteger)index byAuto:(BOOL)isAuto;
- (void)loopViewChanedToLeft:(JRLoopView *)loopView toIndex:(NSInteger)index byAuto:(BOOL)isAuto;
@end

@interface JRLoopView : UIView

/**
 *  数据代理
 */
@property (nonatomic, weak) id<JRLoopViewDataSource> dataSource;

/**
 *  代理对象
 */
@property (nonatomic, weak) id<JRLoopViewDelegte> delegate;

/**
 *  imageView 视图
 */
@property (nonatomic, strong) UIImageView *imageView;

/**
 *  当前索引
 */
@property (nonatomic, assign) NSInteger index;

/**
 *  动画样式
 */
@property (nonatomic, assign) JRTransitionAnimateType type;

@end
