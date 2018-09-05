//
//  MDHAppSandboxController.m
//  MDHUIKit
//
//  Created by Apple on 2018/8/29.
//  Copyright © 2018年 马大哈. All rights reserved.
//

#import "MDHAppSandboxController.h"
#import <Masonry/Masonry.h>


static NSString *const kFolder = @"Folder";
static NSString *const kFile   = @"File";


@interface MDHAppSandboxController ()
<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView  *mainTableView;
@property(nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation MDHAppSandboxController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = self.folderName;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelMethod)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self readAppSandbox];
    
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(@0);
    }];
    
}


- (void)cancelMethod {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Helper

- (void)readAppSandbox {
    
    
    __block NSMutableArray *folderArray = [NSMutableArray array];
    __block NSMutableArray *fileArray   = [NSMutableArray array];

    NSString *firstPath = self.folderPath ? : NSHomeDirectory();

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array = [fileManager contentsOfDirectoryAtPath:firstPath error:nil];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"------%@",obj);
        
        BOOL dir = YES;
        NSString *fullPath = [firstPath stringByAppendingPathComponent:obj];
        
        if ([fileManager fileExistsAtPath:fullPath isDirectory:&dir]) {
            
            [folderArray addObject:obj];
            
        } else {
            [fileArray addObject:obj];
        }
    }];
    
    self.dataSource[kFolder] = folderArray;
    self.dataSource[kFile]   = fileArray;

    [self.mainTableView reloadData];
    
}



#pragma mark - Lazy load

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate   = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        
    }
    return _mainTableView;
}

- (NSMutableDictionary *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableDictionary alloc] init];
    }
    return _dataSource;
}


#pragma mark - Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        NSArray *array = self.dataSource[kFolder];
        return array.count;
    }
    
    NSArray *array = self.dataSource[kFile];
    return array.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"文件夹";
    }
    
    return @"文件";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identify = @"MDHContactsTableCell";
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.section == 0) {
        
        NSArray *array = self.dataSource[kFolder];
        cell.textLabel.text = array[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    } else if (indexPath.section == 1) {
        
        NSArray *array = self.dataSource[kFile];
        cell.textLabel.text = array[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        NSArray *array = self.dataSource[kFolder];
        NSString *name = array[indexPath.row];
        
        NSString *firstPath = self.folderPath ? : NSHomeDirectory();
        NSString *fullPath = [firstPath stringByAppendingPathComponent:name];
        
        MDHAppSandboxController *vc = [[MDHAppSandboxController alloc] init];
        vc.folderPath = fullPath;
        vc.folderName = name;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
