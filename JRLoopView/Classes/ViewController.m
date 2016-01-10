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

@interface ViewController () <JRLoopViewDataSource, JRLoopViewDelegte, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) JRLoopView		*loopView;
@property (nonatomic, strong) UITableView		*tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setUpView];
}

- (void)setUpView {
	self.view.backgroundColor = [UIColor whiteColor];
//	[self addTableView];
	[self addLoopView];
}

- (void)addTableView {
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[self.view addSubview:self.tableView];
}

- (void)addLoopView {
	self.loopView				= [[JRLoopView alloc] initWithFrame:CGRectMake(0, 100, SCREEN_W, SCREEN_W * 0.5)];
	//	self.loopView.type			= JRTransitionAnimateTypeRippleEffect;
	self.loopView.dataSource	= self;
	self.loopView.delegate		= self;
	[self.view addSubview:self.loopView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	}
	cell.textLabel.text = @"CELL";
	return cell;
}

#pragma mark - UItableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	NSLog(@"===== ");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1;
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
