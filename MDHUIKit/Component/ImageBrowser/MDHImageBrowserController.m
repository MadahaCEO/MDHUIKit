//
//  MDHImageBrowserController.m
//  MDHUIKit
//
//  Created by Apple on 2018/8/11.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "MDHImageBrowserController.h"
#import "MDHImageBrowserView.h"

@interface MDHImageBrowserController ()

@property(nonatomic, copy)   NSArray *dataSource;
@property(nonatomic, assign) NSInteger defaultIndex;

@property(nonatomic, strong) MDHImageBrowserView *imageBrowserView;

@end

@implementation MDHImageBrowserController


- (void)dealloc {

    NSLog(@"MDHImageBrowserController------dealloc");
}


+ (instancetype)popImageBrowser:(NSArray *)array defaultIndex:(NSInteger)index {
    
    MDHImageBrowserController *vc = [[MDHImageBrowserController alloc] init];
    vc.dataSource   = array;
    vc.defaultIndex = index;
    
    return vc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.imageBrowserView];
}




- (MDHImageBrowserView *)imageBrowserView {
    
    if (!_imageBrowserView) {
        
        CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        __weak typeof(self) weakSelf   = self;
        _imageBrowserView = [MDHImageBrowserView initWithFrame:rect
                                                         index:self.defaultIndex
                                                        images:self.dataSource
                                                     touchExit:^{
                                                         __strong typeof(weakSelf) strongSelf = weakSelf;
                                                         [strongSelf dismissViewControllerAnimated:YES completion:nil];
                                                     }];
        
        _imageBrowserView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;

    }
    return _imageBrowserView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
