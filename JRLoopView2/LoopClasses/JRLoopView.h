//
//  JRLoopView.h
//  JRLoopView
//
//  Created by wxiao on 16/1/10.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JRLoopViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage		*image;
@property (nonatomic, strong) NSString		*content;
@end

@class JRLoopView;
@protocol JRLoopViewDataSource <NSObject>
@required
- (NSArray *)imageNumberOfJRLoop:(JRLoopView *)loopView;
@end

@interface JRLoopView : UIView
/**
 *  Description
 */
@property (nonatomic, weak) id<JRLoopViewDataSource> dataSource;

@end
