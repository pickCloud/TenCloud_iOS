//
//  TCServerWarningRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerWarningRequest.h"
#import "TCServer+CoreDataClass.h"

@interface TCServerWarningRequest()
@end

@implementation TCServerWarningRequest

- (void) startWithSuccess:(void(^)(NSArray<TCServer*> *serverArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        /*
        NSArray *dataDictArray = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        NSArray *sArray = [TCServer mj_objectArrayWithKeyValuesArray:dataDictArray context:context];
        success ? success(sArray) : nil;
         */
        NSArray *resArray = [self resultServerArray];
        success ? success(resArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSArray<TCServer*> *)resultServerArray
{
    NSDictionary *arrayDict = [self.responseJSONObject objectForKey:@"data"];
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *resArray = [TCServer mj_objectArrayWithKeyValuesArray:arrayDict context:context];
    return resArray;
}

- (NSString *)requestUrl {
    return @"/api/cluster/warn/1";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return nil;
}

@end
