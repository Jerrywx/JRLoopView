//
//  JRLoopView.m
//  JRLoopView
//
//  Created by wxiao on 16/1/11.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "JRLoopView1.h"

@interface JRLoopView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView			*scrollView;		//
@property (nonatomic, strong) JRTouchView			*touchView;
@property (nonatomic, assign) CGRect				scrollFrame;		//
@property (nonatomic, strong) NSMutableArray		*imageArray;

@property (nonatomic, assign) NSInteger				cellTotle;
@property (nonatomic, assign) NSInteger				currentIndex;
@property (nonatomic, strong) NSTimer				*timer;
@end

@implementation JRLoopView

- (instancetype)initWithFrame:(CGRect)frame {
	
	self.topMargin		= 10;
	self.leftMargin		= 5;
	self.bottomMargin	= 10;
	self.rightMargin	= 5;
	
	if (self = [super initWithFrame:frame]) {
		
		self.touchView = [[JRTouchView alloc] initWithFrame:self.bounds];
		self.touchView.backgroundColor = [UIColor yellowColor];
		[self addSubview:self.touchView];
	}
	return self;
}

- (void)setDataSource:(id<JRLoopViewDataSource>)dataSource {
	_dataSource = dataSource;
	
	if ([self.dataSource respondsToSelector:@selector(imageNumberOfJRLoop:)]) {
		self.imageArray = [self.dataSource imageNumberOfJRLoop:self].mutableCopy;
	}
	
	if (self.imageArray.count <= 1) {
		return;
	}

	id firstObj1 = [self.imageArray firstObject];
	id firsyObj2 = self.imageArray[1];
	id lastObj1 = [self.imageArray lastObject];
	id lastObj2 = self.imageArray[self.imageArray.count - 2];
	
	[self.imageArray insertObject:lastObj1 atIndex:0];
	[self.imageArray insertObject:lastObj2 atIndex:0];
	[self.imageArray addObject:firstObj1];
	[self.imageArray addObject:firsyObj2];
	self.cellTotle = self.imageArray.count;
}

- (void)creatPickerWithFrame:(CGRect)frame {
	
	if (_scrollView) {
		[_scrollView removeFromSuperview];
	}
	
	_scrollFrame = frame;
	if (_scrollFrame.size.width > self.frame.size.width) {
		_scrollFrame.size.width = self.frame.size.width;
	}
	if (_scrollFrame.size.height > self.frame.size.height) {
		_scrollFrame.size.height = self.frame.size.height;
	}
	
	_scrollView					= [[UIScrollView alloc] initWithFrame:frame];
	_scrollView.center			= CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
	_scrollView.delegate		= self;
	_scrollView.decelerationRate		= 1.0;//UIScrollViewDecelerationRateNormal;
	_scrollView.delaysContentTouches	= NO;
	_scrollView.clipsToBounds			= NO;
	_scrollView.pagingEnabled			= YES;
	_scrollView.bounces					= NO;
	_scrollView.showsHorizontalScrollIndicator = NO;
	_scrollView.autoresizingMask		= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.touchView.receiver = _scrollView;
	[self addSubview:_scrollView];
	
	[self addContentView];
	
	[self scrollVIewToItem:2 animation:YES];
	[self registTimer];
}

- (void)addContentView {
	NSInteger num = self.cellTotle;
	self.scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * num, _scrollView.frame.size.height);
	for (int i = 0; i < num; ++i) {

		UIView *cell = [[UIView alloc] initWithFrame:CGRectMake(i * _scrollView.frame.size.width, 0,
													_scrollView.frame.size.width, _scrollView.frame.size.height)];

		JRLoopViewCell *subCell = [[JRLoopViewCell alloc] initWithFrame:CGRectMake(self.leftMargin, self.topMargin,
													_scrollView.frame.size.width - self.leftMargin - self.rightMargin,
													_scrollView.frame.size.height - self.topMargin - self.bottomMargin)];
		subCell.image = self.imageArray[i];
		
		[cell addSubview:subCell];
		[_scrollView addSubview:cell];
	}
}

- (void)registTimer {
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self
												selector:@selector(changeToRight)
												userInfo:nil 
												 repeats:YES];
}

- (void)unRegistTimer {
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)changeToLeft {
	self.currentIndex--;
	[self scrollVIewToItem:self.currentIndex animation:YES];
}

- (void)changeToRight {
	self.currentIndex++;
	[self scrollVIewToItem:self.currentIndex animation:YES];
}

#pragma mark - Action
- (void)scrollVIewToItem:(NSInteger)index animation:(BOOL)animation {
	self.currentIndex = index;
	CGPoint pointer = CGPointMake(index * self.scrollFrame.size.width, 0);
	[self.scrollView setContentOffset:pointer animated:animation];
}

- (NSInteger)getCurrentIndex:(CGPoint)point {
	return self.currentIndex = point.x / self.scrollFrame.size.width;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.userInteractionEnabled = NO;
	[self unRegistTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self registTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	self.userInteractionEnabled = YES;
	[self getCurrentIndex:scrollView.contentOffset];
	if (self.currentIndex == 1) {
		[self scrollVIewToItem:self.cellTotle - 3 animation:NO];
	}
	if (self.currentIndex == 0) {
		[self scrollVIewToItem:self.cellTotle - 4 animation:NO];
	}
	if (self.currentIndex == self.cellTotle - 2) {
		[self scrollVIewToItem:2 animation:NO];
	}
	if (self.currentIndex == self.cellTotle - 1) {
		[self scrollVIewToItem:3 animation:NO];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	[self scrollViewDidEndDecelerating:scrollView];
}

@end

// ============================================================================= JRTouchView
@implementation JRTouchView
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return self.receiver;
	}
	return nil;
}
@end

// ============================================================================= Cell
@implementation JRLoopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self addSubview:self.imageView];
	}
	return self;
}

- (void)setImage:(UIImage *)image {
	_image = image;
	self.imageView.image = image;
}

@end







