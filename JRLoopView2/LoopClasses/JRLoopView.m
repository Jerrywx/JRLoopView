//
//  JRLoopView.m
//  JRLoopView
//
//  Created by wxiao on 16/1/10.
//  Copyright © 2016年 wxiao. All rights reserved.
//

#import "JRLoopView.h"

@interface JRLoopView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView					*collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout		*layout;
@property (nonatomic, strong) NSMutableArray					*dataArray;
@property (nonatomic, assign) NSInteger							dataTotle;
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
		self.collectionView.bounces			= NO;
//		self.collectionView.backgroundColor = [UIColor whiteColor];
		self.collectionView.showsHorizontalScrollIndicator = NO;
		[self.collectionView registerClass:[JRLoopViewCell class] forCellWithReuseIdentifier:@"cell1"];
		[self addSubview:self.collectionView];
	}
	return self;
}

- (void)setDataSource:(id<JRLoopViewDataSource>)dataSource {
	_dataSource = dataSource;
	
	if ([self.dataSource respondsToSelector:@selector(imageNumberOfJRLoop:)]) {
		self.dataArray = [self.dataSource imageNumberOfJRLoop:self].mutableCopy;
	}
	self.dataTotle = self.dataArray.count;
	if (self.dataTotle <= 0) {
		self.currentIndex = 0;
		return;
	} else {
		id lastObj = [self.dataArray lastObject];
		id firstObj = [self.dataArray firstObject];
		[self.dataArray insertObject:lastObj atIndex:0];
		[self.dataArray addObject:firstObj];
		NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
		[self.collectionView scrollToItemAtIndexPath:index
									atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
											animated:NO];
		self.currentIndex = 1;
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
//												selector:@selector(changeToLeft)
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
	cell.content = [NSString stringWithFormat:@"Tip:%zd", indexPath.row];
	cell.image = self.dataArray[indexPath.row];
	return cell;
}

#pragma mark -
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];
	if (index.row == self.dataTotle + 1) {
		NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
		[self.collectionView scrollToItemAtIndexPath:index
									atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
											animated:NO];
		self.currentIndex = 1;
	}
	
	if (index.row == 0) {
		NSIndexPath *index = [NSIndexPath indexPathForRow:self.dataTotle inSection:0];
		[self.collectionView scrollToItemAtIndexPath:index
									atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
											animated:NO];
		self.currentIndex = self.dataTotle;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	[self unRegistTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

	NSIndexPath *index = [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];
	if (index.row == self.dataTotle + 1) {
		NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
		[self.collectionView scrollToItemAtIndexPath:index
									atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
											animated:NO];
		self.currentIndex = 1;
	}

	if (index.row == 0) {
		NSIndexPath *index = [NSIndexPath indexPathForRow:self.dataTotle inSection:0];
		[self.collectionView scrollToItemAtIndexPath:index 
									atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
											animated:NO];
		self.currentIndex = self.dataTotle;
	}
	index = [self.collectionView indexPathForItemAtPoint:scrollView.contentOffset];
	self.currentIndex = index.row;

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

