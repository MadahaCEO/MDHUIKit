//
//  MDHImageBrowserScrollView.h
//  MDHUIKit
//
//  Created by Apple on 2018/8/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 @abstract 加载回调
 
 @param successed  图片加载成功
 */
typedef void(^MDHImageBrowserScrollViewBlock)(BOOL successed);

@interface MDHImageBrowserScrollView : UIScrollView

@property(nonatomic, copy) MDHImageBrowserScrollViewBlock loadBlock;
@property(nonatomic, copy) dispatch_block_t touchBlock;


- (void)setImageWithUrl:(NSURL *)url
                 result:(MDHImageBrowserScrollViewBlock)block
              touchExit:(dispatch_block_t)tBlock;

@end
