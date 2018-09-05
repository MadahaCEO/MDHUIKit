//
//  MDHImageBrowserScrollView.m
//  MDHUIKit
//
//  Created by Apple on 2018/8/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "MDHImageBrowserScrollView.h"
#import <AFNetworking/AFNetworking.h>

@interface MDHImageBrowserScrollView ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIImageView *imageView;


@end

static CGFloat const kMinZoomScale = 1.0;
static CGFloat const kMaxZoomScale = 3.0;

@implementation MDHImageBrowserScrollView

- (void)dealloc {
    NSLog(@"MDHImageBrowserScrollView------dealloc");
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        //        self.zoomBouncing  = NO;
        self.delegate      = self;
        self.minimumZoomScale = kMinZoomScale;
        self.maximumZoomScale = kMaxZoomScale;
        self.contentOffset = CGPointMake(0, 0);
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:self.imageView];
        

        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [self.imageView addGestureRecognizer:singleTapGesture];

        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTapGesture setNumberOfTapsRequired:2];
        [self.imageView addGestureRecognizer:doubleTapGesture];
      
        // 双击手势确定监测失败才会触发单击手势的相应操作（防止手势冲突）
        [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
        
    }
    
    return self;
}


- (void)setImageWithUrl:(NSURL *)url
                 result:(MDHImageBrowserScrollViewBlock)block
              touchExit:(dispatch_block_t)tBlock {

    self.loadBlock = block;
    self.touchBlock = tBlock;
    self.imageView.image = nil;
    
    __weak typeof(self) weakSelf   = self;

    [self.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:url]
                          placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

                              __strong typeof(weakSelf) strongSelf = weakSelf;

                              if (image) {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      CGFloat windowWidth  = [UIScreen mainScreen].bounds.size.width;
                                      CGFloat windowHeight = [UIScreen mainScreen].bounds.size.height;
                                      CGFloat imageWidth   = image.size.width;
                                      CGFloat imageHeight  = image.size.height;
                                      CGFloat tempHeight   = imageHeight / (imageWidth/windowWidth);
                                     
                                      if (tempHeight < windowHeight) {
                                          tempHeight = windowHeight;
                                      }
                                      
                                      CGSize realSize     = CGSizeMake(windowWidth, tempHeight);
                                      
                                      // 优先设置 zoomScale
                                      strongSelf.zoomScale       = 1.0;
                                      strongSelf.contentSize     = realSize;
                                      strongSelf.contentOffset   = CGPointMake(0, 0);
                                      strongSelf.imageView.frame = CGRectMake(0, 0, realSize.width, realSize.height);
                                      strongSelf.imageView.image = image;
                                  });
                              }
                              
                              if (strongSelf.loadBlock) {
                                  strongSelf.loadBlock(image?YES:NO);
                              }
                          } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                              __strong typeof(weakSelf) strongSelf = weakSelf;
                              if (strongSelf.loadBlock) {
                                  strongSelf.loadBlock(NO);
                              }
                          }];
   
}


#pragma mark - 单、双击

- (void)handleSingleTap:(UIGestureRecognizer *)gesture {

    if (self.touchBlock) {
        self.touchBlock();
    }
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gesture {

    CGFloat zoomScale = self.zoomScale;
    zoomScale = (zoomScale == kMinZoomScale) ? kMaxZoomScale : kMinZoomScale;
   
    CGPoint center = [gesture locationInView:gesture.view];
    
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / zoomScale;
    zoomRect.size.width  =self.frame.size.width  / zoomScale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /kMaxZoomScale);
    zoomRect.origin.y = center.y - (zoomRect.size.height /kMaxZoomScale);

    [self zoomToRect:zoomRect animated:YES];
    
}


#pragma mark - 子视图

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _imageView;
}



#pragma mark - UIScrollView

//设置本scroll的缩放对象
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
//捏合时执行这里
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    //得到缩放比例
    CGFloat zoom = scrollView.zoomScale;
    //下面两句经典，当zs小于1时，取1，当zs在1和2之间时，取1和2之间的值，当zs大于2时，取2，既是指，zs只在1和2之间被允许
    zoom = MAX(zoom, kMinZoomScale);
    zoom = MIN(zoom, kMaxZoomScale);
    //通过动画，调整本scroll的最终的缩放比例
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    scrollView.zoomScale = zoom;
    [UIView commitAnimations];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
