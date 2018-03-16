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
#import "TCServerThresholdRequest.h"

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
        if ([[TCLocalAccount shared] isLogin])
        {
            [self startFetch];
        }
        
        _threshold = [TCServerThreshold MR_createEntity];
        _threshold.block_threshold = 0.8;
        _threshold.disk_threshold = 0.8;
        _threshold.memory_threshold = 0.8;
        _threshold.cpu_threshold = 0.8;
        _threshold.net_threshold = 0.8;
    }
    return self;
}

- (void) sendProviderConfigurationRequest
{
    __weak __typeof(self) weakSelf = self;
    TCClusterProviderRequest *requst = [[TCClusterProviderRequest alloc] initWithClusterID:@"1"];
    [requst startWithSuccess:^(NSArray<TCClusterProvider *> *aProviderArray) {
        weakSelf.needRetry = NO;
        [weakSelf.providerArray removeAllObjects];
        [weakSelf.providerArray addObjectsFromArray:aProviderArray];
    } failure:^(NSString *message) {
        if (weakSelf.needRetry)
        {
            [self performSelector:@selector(sendProviderConfigurationRequest)
                       withObject:nil afterDelay:1.5];
        }
    }];
}

- (void) getServerThreshold
{
    __weak __typeof(self) weakSelf = self;
    TCServerThresholdRequest *req = [TCServerThresholdRequest new];
    [req startWithSuccess:^(TCServerThreshold *threshold) {
        NSLog(@"geeeeettt ");
        weakSelf.threshold = threshold;
    } failure:^(NSString *message) {
        NSLog(@"geeeeettt 2");
    }];
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

- (void) startFetch
{
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

- (void) stopFetch
{
    _needRetry = NO;
}
@end
