//
//  TCClusterProviderRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCClusterProviderRequest.h"
#import "TCClusterProvider+CoreDataClass.h"

@interface TCClusterProviderRequest()
@property (nonatomic, strong)       NSString    *clusterID;
@end

@implementation TCClusterProviderRequest

- (instancetype) initWithClusterID:(NSString*)clusterID
{
    self = [super init];
    if (self)
    {
        _clusterID = clusterID;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(NSArray<TCClusterProvider*> *providerArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *arrayDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *resArray = [TCClusterProvider mj_objectArrayWithKeyValuesArray:arrayDict context:context];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSString *urlstr = [NSString stringWithFormat:@"/api/cluster/%@/providers",_clusterID];
    return urlstr;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (NSInteger)cacheTimeInSeconds
{
    return  NSIntegerMax;
}

@end
