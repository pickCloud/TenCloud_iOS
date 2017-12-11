//
//  TCServerLogTableViewController.m
//  TenCloud
//
//  Created by huangdx on 2017/12/11.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerLogTableViewController.h"
#import "TCServerLogRequest.h"

@interface TCServerLogTableViewController ()
@property (nonatomic, assign)   NSInteger   serverID;
@end

@implementation TCServerLogTableViewController

- (instancetype) initWithID:(NSInteger)serverID
{
    self = [super init];
    if (self)
    {
        _serverID = serverID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    TCServerLogRequest *request = [[TCServerLogRequest alloc] initWithServerID:_serverID type:0];
    [request startWithSuccess:^(NSArray<TCServerLog *> *logArray) {
        
    } failure:^(NSString *message) {
        
    }];
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
