//
//  TCJoinSettingRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCJoinSettingRequest.h"


@interface TCJoinSettingRequest()

@end

@implementation TCJoinSettingRequest

- (void) startWithSuccess:(void(^)(NSArray<NSString*> *settingArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *settingStr = [dataDict objectForKey:@"setting"];
        NSArray *settingArray = [settingStr componentsSeparatedByString:@","];
        success ? success(settingArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
}

- (NSString *)requestUrl {
    NSInteger cid = [[TCCurrentCorp shared] cid];
    NSString *url = [NSString stringWithFormat:@"/api/company/%ld/entry/setting",cid];
    return url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return nil;
}

@end