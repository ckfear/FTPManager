//
//  ViewController.m
//  FTPManager
//
//  Created by 兴业 on 16/5/31.
//  Copyright © 2016年 ckfear. All rights reserved.
//

#import "ViewController.h"
#import <CFNetwork/CFNetwork.h>
#import "FTPManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, FTPManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) FTPManager *ftpManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupDataSource];
    [self setupFTPManager];
    
    [_ftpManager listRemoteDirectory];
    [self.view addSubview:self.tableView];
}

#pragma mark - setupProperty
- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)setupDataSource {
    _dataSource = [NSMutableArray array];
}

- (void)setupFTPManager {
    _ftpManager = [[FTPManager alloc] initWithServer:@"192.168.1.109" userName:@"xingye" password:@"123456"];
    _ftpManager.delegate = self;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"access to %@", _dataSource[indexPath.row]);
    NSString *fileName = _dataSource[indexPath.row];
    [_ftpManager gotoNextFile:fileName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

#pragma mark 
- (void)uploadDataWithSuccess:(BOOL)success{
    
}

- (void)downloadDataWithSuccess:(BOOL)success{
    
}

- (void)directoryListingSuccess:(BOOL)success fileNames:(NSArray *)fileNames{
    if (success) {
        _dataSource = [NSMutableArray arrayWithArray:fileNames];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)ftpError:(NSString *)error{
    NSLog(@"ftpErr = %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
