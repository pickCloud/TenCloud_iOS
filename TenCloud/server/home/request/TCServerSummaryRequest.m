//
//  TCServerSummaryRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCServerSummaryRequest.h"
#import "TCServerSummary+CoreDataClass.h"


@interface TCServerSummaryRequest()

@end

@implementation TCServerSummaryRequest

- (void) startWithSuccess:(void(^)(TCServerSummary *summary))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        TCServerSummary *summary = [TCServerSummary mj_objectWithKeyValues:dataDict context:context];
        success ? success(summary) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/cluster/summary";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return nil;
}

@end
