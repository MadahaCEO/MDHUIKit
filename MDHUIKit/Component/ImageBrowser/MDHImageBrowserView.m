//
//  MDHImageBrowserView.m
//  MDHUIKit
//
//  Created by Apple on 2018/8/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "MDHImageBrowserView.h"
#import "MDHImageBrowserCell.h"

static CGFloat const kConstInteger = 10.0;

@interface MDHImageBrowserView ()
<UICollectionViewDataSource,UICollectionViewDelegate>


@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, copy) NSArray *dataSource;
@property(nonatomic, assign) NSInteger defaultIndex;


@end


static NSString *const kMDHImageBrowserCellID = @"MDHImageBrowserCellID";

@implementation MDHImageBrowserView


- (void)dealloc {
    [self removeNotification];
    NSLog(@"MDHImageBrowserView------dealloc");

}

+ (instancetype)initWithFrame:(CGRect)frame
                        index:(NSInteger)index
                       images:(NSArray *)array
                    touchExit:(dispatch_block_t)tBlock {

    return [[self alloc] initWithFrame:frame imageArray:array defaultIndex:index touchExit:tBlock];
}


- (instancetype)initWithFrame:(CGRect)frame
                   imageArray:(NSArray *)array
                 defaultIndex:(NSInteger)index
                    touchExit:(dispatch_block_t)tBlock {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.dataSource   = array;;
        self.defaultIndex = index;
        self.touchBlock   = tBlock;
        
        [self addSubview:self.collectionView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.defaultIndex < 0 || self.defaultIndex > self.dataSource.count - 1) {
                self.defaultIndex = 0;
            }
            
            if (self.dataSource.count > self.defaultIndex) {
                [self.collectionView setContentOffset:CGPointMake(self.defaultIndex * self.collectionView.frame.size.width, 0)];
            }
        });
        [self addNotification];
    }
    
    return self;
}




- (UICollectionView *)collectionView {
    
    if (!_collectionView) {

        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize  = CGSizeMake(self.frame.size.width+kConstInteger, self.frame.size.height);
        //最小行间距(默认为10)
        layout.minimumLineSpacing = 0;
        //最小item间距（默认为10）
//        layout.minimumInteritemSpacing = 0;
        
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [_collectionView registerClass:[MDHImageBrowserCell class] forCellWithReuseIdentifier:kMDHImageBrowserCellID];
        
    }
    return _collectionView;
}


#pragma mark collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MDHImageBrowserCell *cell = (MDHImageBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kMDHImageBrowserCellID forIndexPath:indexPath];

    if (self.dataSource.count > indexPath.row) {
        NSString *string = self.dataSource[indexPath.row];
        if (string && [string isKindOfClass:[NSString class]] && string.length > 0) {
            
            __weak typeof(self) weakSelf   = self;
            [cell setImageWithUrl:[NSURL URLWithString:string] touchExit:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;

                if (strongSelf.touchBlock) {
                    strongSelf.touchBlock();
                }
            }];
        }
    }
        
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    NSString *msg = cell.botlabel.text; 
//    NSLog(@"%@",msg);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    self.defaultIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
//    NSLog(@"defaultIndex: %ld",self.defaultIndex);
}


#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillChangeOrientation:)
                                                 name:UIApplicationWillChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appWillChangeOrientation:(NSNotification *)notif {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        [self.collectionView setContentOffset:CGPointMake(self.defaultIndex * self.collectionView.frame.size.width, 0)];
    });
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
