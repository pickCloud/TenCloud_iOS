//
//  TCClusterRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCClusterRequest.h"
#import "TCServer+CoreDataClass.h"

@interface TCClusterRequest()
@end

@implementation TCClusterRequest

- (void) startWithSuccess:(void(^)(NSArray<TCServer*> *serverArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSArray *serverListDict = [dataDict objectForKey:@"server_list"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *sArray = [TCServer mj_objectArrayWithKeyValuesArray:serverListDict context:context];
        success ? success(sArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/cluster/1";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return nil;
}

@end
