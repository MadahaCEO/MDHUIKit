//
//  MDHImageBrowserCell.m
//  MDHUIKit
//
//  Created by Apple on 2018/8/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "MDHImageBrowserCell.h"
#import "MDHImageBrowserScrollView.h"

@interface MDHImageBrowserCell ()

@property(nonatomic, strong) MDHImageBrowserScrollView *scrollview;
@property(nonatomic, strong) UIActivityIndicatorView   *indicatorView;
@property(nonatomic, strong) UILabel   *failedLabel;

@end

@implementation MDHImageBrowserCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.scrollview];
        [self.contentView addSubview:self.indicatorView];
        [self.contentView addSubview:self.failedLabel];
        self.failedLabel.hidden = YES;
        
    }
    
    return self;
}


#pragma mark - Api

- (void)setImageWithUrl:(NSURL *)url touchExit:(dispatch_block_t)tBlock {

    [self.indicatorView startAnimating];

    __weak typeof(self) weakSelf   = self;
    [self.scrollview setImageWithUrl:url result:^(BOOL successed) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf.indicatorView stopAnimating];
        strongSelf.failedLabel.hidden = successed;

    } touchExit:^{

        if (tBlock) {
            tBlock();
        }
    }];
}


#pragma mark - 子视图

- (MDHImageBrowserScrollView *)scrollview {
    
    if (!_scrollview) {
        _scrollview = [[MDHImageBrowserScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollview.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _scrollview;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicatorView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _indicatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    }
    return _indicatorView;
}

- (UILabel *)failedLabel {
    if (!_failedLabel) {
        
        _failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _failedLabel.backgroundColor = [UIColor clearColor];
        _failedLabel.textColor = [UIColor whiteColor];
        _failedLabel.textAlignment = NSTextAlignmentCenter;
        _failedLabel.font = [UIFont systemFontOfSize:15.0];
        _failedLabel.text = @"加载失败 (＃￣～￣＃)";
        _failedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _failedLabel;
}

@end
