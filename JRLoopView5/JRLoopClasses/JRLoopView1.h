//
//  JRLoopView.h
//  JRLoopView
//
//  Created by wxiao on 16/1/11.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRLoopViewCell : UIView
@property (nonatomic, strong) UIImageView	*imageView;
@property (nonatomic, strong) UIImage		*image;
@end

// ============================================================ Touch View
@interface JRTouchView :UIView
@property (nonatomic, retain) UIView		*receiver;
@end

// ============================================================ JRLoopView
@class JRLoopView;
@protocol JRLoopViewDataSource <NSObject>
@required
- (NSArray *)imageNumberOfJRLoop:(JRLoopView *)loopView;
@end

@interface JRLoopView : UIView

@property (nonatomic, assign) CGFloat				topMargin;
@property (nonatomic, assign) CGFloat				leftMargin;
@property (nonatomic, assign) CGFloat				bottomMargin;
@property (nonatomic, assign) CGFloat				rightMargin;

/**
 *  数据源代理对象
 */
@property (nonatomic, weak) id<JRLoopViewDataSource> dataSource;

//
- (void)creatPickerWithFrame:(CGRect)frame;

@end
