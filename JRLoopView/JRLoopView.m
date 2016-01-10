//
//  JRLoopView.m
//  JRLoopView
//
//  Created by wxiao on 16/1/9.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "JRLoopView.h"

@interface JRLoopView ()
@property (nonatomic, strong) NSTimer			*timer;
@property (nonatomic, assign) NSInteger			imageTotal;
@property (nonatomic, strong) NSArray			*imageArray;
@end

@implementation JRLoopView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.clipsToBounds				= YES;
		self.imageView					= [[UIImageView alloc] initWithFrame:self.bounds];
		self.imageView.backgroundColor	= [UIColor orangeColor];
		self.imageTotal					= [self.imageArray count];
		self.index						= 0;
		self.imageView.userInteractionEnabled = YES;
		[self addSubview:self.imageView];
		[self registTimer];

		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																			  action:@selector(tapAction:)];
		[self.imageView addGestureRecognizer:tap];
		
		UISwipeGestureRecognizer *swipeleft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
																						action:@selector(leftAction:)];
		swipeleft.direction = UISwipeGestureRecognizerDirectionLeft;
		[self.imageView addGestureRecognizer:swipeleft];
		
		UISwipeGestureRecognizer *swiperight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
																						action:@selector(rightAction:)];
		swiperight.direction = UISwipeGestureRecognizerDirectionRight;
		[self.imageView addGestureRecognizer:swiperight];
	}
	return self;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
	if ([self.delegate respondsToSelector:@selector(loopViewDidClicked:atIndex:)]) {
		[self.delegate loopViewDidClicked:self atIndex:self.index];
	}
}

- (void)leftAction:(UISwipeGestureRecognizer *)swip {
	[self unRegistTimer];
	[self scrollToRight];
	[self registTimer];
}

- (void)rightAction:(UISwipeGestureRecognizer *)swip {
	[self unRegistTimer];
	[self scrollToLeft];
	[self registTimer];
}

- (void)setDataSource:(id<JRLoopViewDataSource>)dataSource {
	_dataSource = dataSource;
	if ([self.dataSource respondsToSelector:@selector(imageNumberOfJRLoop:)]) {
		self.imageArray = [self.dataSource imageNumberOfJRLoop:self];
		self.imageView.image = [self.imageArray firstObject];
	}
	self.imageTotal = self.imageArray.count;
}

- (void)registTimer {
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
	self.timer = [NSTimer scheduledTimerWithTimeInterval:2
											  target:self
											selector:@selector(autoChange)
											userInfo:nil
											 repeats:YES];
//	[self.timer fire];
}

- (void)unRegistTimer {
	[self.timer invalidate];
	self.timer = nil;
}

- (void)autoChange {
//	[self scrollToLeft];
	[self scrollToRight];
}

- (void)scrollToLeft {
	NSInteger tmp = self.index;
	self.index--;
	if (self.index < 0) {
		self.index = self.imageArray.count - 1;
	}
	
	if (tmp == self.index) {
		return;
	} else {
		self.imageView.image		= self.imageArray[self.index];
		CATransition *transition	= [[CATransition alloc]init];
		transition.type				= [self getAnimateType:self.type];//kCATransitionFade;
		transition.subtype			= kCATransitionFromLeft;
		[self.imageView.layer addAnimation:transition forKey:@"SRTransitionAnimation"];
	}
	if ([self.delegate respondsToSelector:@selector(loopViewChaned:withDirection:toIndex:byAuto:)]) {
		[self.delegate loopViewChaned:self withDirection:1 toIndex:self.index byAuto:self.timer ? YES : NO];
	}
	if ([self.delegate respondsToSelector:@selector(loopViewChanedToLeft:toIndex:byAuto:)]) {
		[self.delegate loopViewChanedToLeft:self toIndex:self.index byAuto:self.timer ? YES : NO];
	}
}

- (void)scrollToRight {
	NSInteger tmp = self.index;
	self.index++;
	if (self.index >= self.imageArray.count) {
		self.index = 0;
	}
	
	if (tmp == self.index) {
		return;
	} else {
		self.imageView.image		= self.imageArray[self.index];
		CATransition *transition	= [[CATransition alloc]init];
		transition.type				= [self getAnimateType:self.type];//kCATransitionFade;
		transition.subtype			= kCATransitionFromRight;
		[self.imageView.layer addAnimation:transition forKey:@"SRTransitionAnimation"];
	}
	if ([self.delegate respondsToSelector:@selector(loopViewChaned:withDirection:toIndex:byAuto:)]) {
		[self.delegate loopViewChaned:self withDirection:0 toIndex:self.index byAuto:self.timer ? YES : NO];
	}
	
	if (([self.delegate respondsToSelector:@selector(loopViewChanedToRight:toIndex:byAuto:)])) {
		[self.delegate loopViewChanedToRight:self toIndex:self.index byAuto:self.timer ? YES:NO];
	}
}

- (NSString *)getAnimateType:(JRTransitionAnimateType)type {
	return @[ @"push", @"fade", @"movein", @"reveal", @"cube", @"oglFlip",
			 @"suckEffect", @"rippleEffect", @"pageCurl",	@"pageUnCurl",
			 @"cameralIrisHollowOpen", @"cameraIrisHollowClose",][type];
}

@end













