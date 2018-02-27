//
//  TCTemplateListRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCTemplateListRequest.h"
#import "TCTemplate+CoreDataClass.h"

@interface TCTemplateListRequest()

@end

@implementation TCTemplateListRequest

- (void) startWithSuccess:(void(^)(NSArray<TCTemplate *> *templateArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dataArray = [request.responseJSONObject objectForKey:@"data"];
        if (dataArray)
        {
            NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
            NSArray *tmplArray = [TCTemplate mj_objectArrayWithKeyValuesArray:dataArray context:context];
            success ? success (tmplArray) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    NSInteger cid = [[TCCurrentCorp shared] cid];
    NSString *url = [NSString stringWithFormat:@"/api/permission/template/list/%ld",cid];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
