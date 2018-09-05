//
//  MDHImageBrowserView.h
//  MDHUIKit
//
//  Created by Apple on 2018/8/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHImageBrowserView : UIView

@property(nonatomic, copy) dispatch_block_t touchBlock;


+ (instancetype)initWithFrame:(CGRect)frame
                        index:(NSInteger)index
                       images:(NSArray *)array
                    touchExit:(dispatch_block_t)tBlock;

@end
