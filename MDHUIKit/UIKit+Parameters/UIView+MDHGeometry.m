//
//  UIView+MDHGeometry.m
//  MDHUIKit
//
//  Created by Apple on 2018/8/18.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "UIView+MDHGeometry.h"

@implementation UIView (MDHGeometry)


- (void)setMdh_x:(CGFloat)mdh_x {
    
    CGRect frame   = self.frame;
    frame.origin.x = mdh_x;
    
    self.frame     = frame;
}

- (CGFloat)mdh_x {
    
    return self.frame.origin.x;
}

- (void)setMdh_y:(CGFloat)mdh_y {
    
    CGRect frame   = self.frame;
    frame.origin.y = mdh_y;
    
    self.frame     = frame;
}

- (CGFloat)mdh_y {
    
    return self.frame.origin.y;
}

- (void)setMdh_width:(CGFloat)mdh_width {
    
    CGRect frame     = self.frame;
    frame.size.width = mdh_width;
    
    self.frame       = frame;
}

- (CGFloat)mdh_width {
    
    return self.frame.size.width;
}

- (void)setMdh_height:(CGFloat)mdh_height {
    
    CGRect frame      = self.frame;
    frame.size.height = mdh_height;
    
    self.frame        = frame;
}

- (CGFloat)mdh_height {
    
    return self.frame.size.height;
}

- (void)setMdh_size:(CGSize)mdh_size {
    
    CGRect frame = self.frame;
    frame.size   = mdh_size;
    
    self.frame   = frame;
}

- (void)setMdh_centerX:(CGFloat)mdh_centerX {
    
    CGPoint center = self.center;
    center.x       = mdh_centerX;
    
    self.center   = center;
}


- (CGFloat)mdh_centerX {
    
    return CGRectGetMidX(self.frame);
}


- (void)setMdh_centerY:(CGFloat)mdh_centerY {
    
    CGPoint center = self.center;
    center.y       = mdh_centerY;
    
    self.center   = center;
}

- (CGFloat)mdh_centerY {
    
    return CGRectGetMidY(self.frame);
}

- (CGSize)mdh_size {
    
    return self.frame.size;
}

- (void)setMdh_origin:(CGPoint)mdh_origin {
    
    CGRect frame = self.frame;
    frame.origin = mdh_origin;
    
    self.frame   = frame;
}

- (CGPoint)mdh_origin {
    
    return self.frame.origin;
}

- (void)setMdh_center:(CGPoint)mdh_center {
    
    CGPoint center = self.center;
    center         = mdh_center;
    
    self.center   = center;
}

- (CGPoint)mdh_center {
    
    return self.center;
}


@end
