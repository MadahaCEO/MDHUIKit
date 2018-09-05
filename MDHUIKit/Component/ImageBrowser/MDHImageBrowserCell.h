//
//  MDHImageBrowserCell.h
//  MDHUIKit
//
//  Created by Apple on 2018/8/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDHImageBrowserCell : UICollectionViewCell

- (void)setImageWithUrl:(NSURL *)url touchExit:(dispatch_block_t)tBlock;

@end
