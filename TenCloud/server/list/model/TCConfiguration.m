//
//  TCConfiguration.m
//  TenCloud
//
//  Created by huangdx on 2017/12/21.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCConfiguration.h"
#import "TCClusterProviderRequest.h"
#import "TCClusterProvider+CoreDataClass.h"

@interface TCConfiguration()
- (void) sendProviderConfigurationRequest;
@property (nonatomic, assign)   BOOL                needRetry;
@end

@implementation TCConfiguration

+ (instancetype) shared
{
    static TCConfiguration *instance;
    static dispatch_once_t accountDisp;
    dispatch_once(&accountDisp, ^{
        instance = [[TCConfiguration alloc] init];
    });
    return instance;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        _providerArray = [NSMutableArray new];
        _needRetry = NO;
        TCClusterProviderRequest *providerReq = [[TCClusterProviderRequest alloc] initWithClusterID:@"1"];
        if ([providerReq loadCacheWithError:nil])
        {
            NSDictionary *dataDict = [providerReq.responseJSONObject objectForKey:@"data"];
            [self parseDictionaryData:dataDict];
        }else
        {
            _needRetry = YES;
        }
        [self sendProviderConfigurationRequest];
        
    }
    return self;
}

- (void) sendProviderConfigurationRequest
{
    __weak __typeof(self) weakSelf = self;
    NSLog(@"发送请求pr");
    TCClusterProviderRequest *requst = [[TCClusterProviderRequest alloc] initWithClusterID:@"1"];
    [requst startWithSuccess:^(NSArray<TCClusterProvider *> *aProviderArray) {
        weakSelf.needRetry = NO;
        [weakSelf.providerArray removeAllObjects];
        [weakSelf.providerArray addObjectsFromArray:aProviderArray];
        //NSLog(@"从请求更新providers:%@",aProviderArray);;
    } failure:^(NSString *message) {
        //NSLog(@"message:%@",message);
        if (weakSelf.needRetry)
        {
            [self performSelector:@selector(sendProviderConfigurationRequest)
                       withObject:nil afterDelay:1.5];
        }
    }];
    
    /*
    [YEConfigurationRequest requestWithSuccess:^(NSDictionary *dataDict) {
        NSLog(@"获取conf dict2:%@",dataDict);
        weakSelf.needRetry = NO;
        [self parseDictionaryData:dataDict];
    } failure:^(NSString *message) {
        NSLog(@"get conf failed message:%@",message);
        if (weakSelf.needRetry)
        {
            //[self sendConfigurationRequest];
            NSLog(@"等待重试");
            [self performSelector:@selector(sendConfigurationRequest) withObject:nil afterDelay:1.5];
        }
    }];
     */
}

- (void) parseDictionaryData:(NSDictionary*)dict
{
    [_providerArray removeAllObjects];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *providerObjArray = [TCClusterProvider mj_objectArrayWithKeyValuesArray:dict context:context];
    if (providerObjArray)
    {
        [_providerArray addObjectsFromArray:providerObjArray];
    }
}

- (void) print
{
    
}
@end
