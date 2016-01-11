//
//  ViewController.m
//  JRLoopView5
//
//  Created by wxiao on 16/1/10.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "ViewController.h"
#import "JRLoopView1.h"

#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)

@interface ViewController () <JRLoopViewDataSource>
@property (nonatomic, strong) JRLoopView *loopView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.loopView					= [[JRLoopView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, SCREEN_W * 0.45)];
	self.loopView.backgroundColor	= [UIColor orangeColor];
	self.loopView.dataSource		= self;
	[self.loopView creatPickerWithFrame:CGRectMake(0, 0, 250, SCREEN_W * 0.45)];
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

@end
