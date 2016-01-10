//
//  ViewController.m
//  JRLoopView
//
//  Created by wxiao on 16/1/9.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "ViewController.h"
#import "JRLoopView.h"

#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)

@interface ViewController () <JRLoopViewDataSource, JRLoopViewDelegte>
@property (nonatomic, strong) JRLoopView		*loopView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.loopView				= [[JRLoopView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, SCREEN_W * 0.5)];
//	self.loopView.type			= JRTransitionAnimateTypeRippleEffect;
	self.loopView.dataSource	= self;
	self.loopView.delegate		= self;
	[self.view addSubview:self.loopView];
}

#pragma mark - JRLoopViewDataSource
- (NSArray *)imageNumberOfJRLoop:(JRLoopView *)loopView {
	return @[
			 [UIImage imageNamed:@"01"],
			 [UIImage imageNamed:@"02"],
			 [UIImage imageNamed:@"03"],
			 [UIImage imageNamed:@"04"],
			 [UIImage imageNamed:@"05"]
			 ];
}

- (void)loopViewDidClicked:(JRLoopView *)loopView atIndex:(NSInteger)index {
	NSLog(@"---- %zd = %@", index, loopView);
}

- (void)loopViewChaned:(JRLoopView *)loopView withDirection:(NSInteger)direction toIndex:(NSInteger)index byAuto:(BOOL)isAuto{
	NSLog(@"--- dir:%zd -%zd- index:%zd", direction, isAuto,index);
}

- (void)loopViewChanedToRight:(JRLoopView *)loopView toIndex:(NSInteger)index byAuto:(BOOL)isAuto{
	NSLog(@"=== LEFT: %zd = %zd", index, isAuto);
}

- (void)loopViewChanedToLeft:(JRLoopView *)loopView toIndex:(NSInteger)index byAuto:(BOOL)isAuto{
	NSLog(@"=== RIGHT: %zd = %zd", index, isAuto);
}

@end
