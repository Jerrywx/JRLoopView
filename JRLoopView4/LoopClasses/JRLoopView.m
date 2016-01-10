//
//  JRLoopView.m
//  JRLoopView
//
//  Created by wxiao on 16/1/10.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "JRLoopView.h"

#define COUNT 20
@interface JRLoopView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView					*collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout		*layout;
@property (nonatomic, strong) NSMutableArray					*dataArray;
@property (nonatomic, assign) NSInteger							dataTotle;
@property (nonatomic, assign) NSInteger							dataCount;
@property (nonatomic, assign) NSInteger							dataCenter;

@property (nonatomic, strong) NSTimer							*timer;
@property (nonatomic, assign) NSInteger							currentIndex;
@end

@implementation JRLoopView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.collectionView					= [[UICollectionView alloc] initWithFrame:self.bounds
																 collectionViewLayout:self.layout];
		self.collectionView.dataSource		= self;
		self.collectionView.delegate		= self;
		self.collectionView.pagingEnabled	= YES;
		self.collectionView.showsHorizontalScrollIndicator = NO;
		self.collectionView.backgroundColor = [UIColor whiteColor];
		[self.collectionView registerClass:[JRLoopViewCell class] forCellWithReuseIdentifier:@"cell1"];
		[self addSubview:self.collectionView];
	}
	return self;
}

- (void)setDataSource:(id<JRLoopViewDataSource>)dataSource {
	_dataSource = dataSource;
	
	NSArray *array = nil;
	if ([self.dataSource respondsToSelector:@selector(imageNumberOfJRLoop:)]) {
		array = [self.dataSource imageNumberOfJRLoop:self].mutableCopy;
	}
	self.dataCount = array.count;
	if (self.dataCount <= 0) {
		return;
	} else {
		self.dataTotle = self.dataCount * COUNT;
		self.dataArray = [NSMutableArray arrayWithCapacity:self.dataTotle];
		for (int i = 0; i < COUNT; ++i) {
			[self.dataArray addObjectsFromArray:array];
		}
		self.dataCenter = self.dataCount * COUNT * 0.5;
		NSIndexPath *index = [NSIndexPath indexPathForRow:self.dataCenter inSection:0];
		[self.collectionView scrollToItemAtIndexPath:index
									atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
											animated:NO];
		self.currentIndex = self.dataCenter;
		[self regsitTimer];
	}
}

- (void)regsitTimer {
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
	self.timer = [NSTimer scheduledTimerWithTimeInterval:2
												  target:self
												selector:@selector(changeToRight)
				  //							selector:@selector(changeToLeft)
												userInfo:nil
												 repeats:YES];
	
}

- (void)unRegistTimer {
	if (self.timer) {
		[self.timer invalidate];
		self.timer = nil;
	}
}

- (void)changeToRight {
	self.currentIndex++;
	NSIndexPath *index = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
	[self.collectionView scrollToItemAtIndexPath:index
								atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
										animated:YES];
}

- (void)changeToLeft {
	self.currentIndex--;
	NSIndexPath *index = [NSIndexPath indexPathForRow:self.currentIndex inSection:0];
	[self.collectionView scrollToItemAtIndexPath:index
								atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
										animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	JRLoopViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
	cell.content = [NSString stringWithFormat:@"N-%zd", indexPath.row];
	cell.image = self.dataArray[indexPath.row];
	return cell;
}

#pragma mark - 
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	NSIndexPath *index	= [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];
	NSInteger ind		= self.dataCenter + index.row % self.dataCount;
	NSIndexPath *index2 = [NSIndexPath indexPathForRow:ind inSection:0];
	[self.collectionView scrollToItemAtIndexPath:index2
								atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
										animated:NO];
	self.currentIndex = index2.row;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self unRegistTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];
	NSInteger ind = self.dataCenter + index.row % self.dataCount;
	NSIndexPath *index2 = [NSIndexPath indexPathForRow:ind inSection:0];
	[self.collectionView scrollToItemAtIndexPath:index2
								atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
										animated:NO];
	self.currentIndex = index2.row;
	[self regsitTimer];
}

#pragma mark - 懒加载
- (UICollectionViewFlowLayout *)layout {
	if (_layout) {
		return _layout;
	}
	_layout							= [[UICollectionViewFlowLayout alloc] init];
	_layout.minimumLineSpacing		= 0;
	_layout.minimumInteritemSpacing = 0;
	_layout.itemSize				= self.frame.size;
	_layout.scrollDirection			= UICollectionViewScrollDirectionHorizontal;
	return _layout;
}

@end


@interface JRLoopViewCell ()
@property (nonatomic, strong) UIImageView	*imageView;
@property (nonatomic, strong) UILabel		*label;
@end

@implementation JRLoopViewCell

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		[self.contentView addSubview:self.imageView];
		self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
		self.label.backgroundColor = [UIColor grayColor];
		[self.contentView addSubview:self.label];
	}
	return self;
}

- (void)setImage:(UIImage *)image {
	_image = image;
	self.imageView.image = image;
}

- (void)setContent:(NSString *)content {
	self.label.text = content;
}

@end


