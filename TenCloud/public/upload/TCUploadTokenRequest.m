//
//  TCUploadTokenRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCUploadTokenRequest.h"

@interface TCUploadTokenRequest()

@end

@implementation TCUploadTokenRequest

- (void) startWithSuccess:(void(^)(NSString *token))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        if (dataDict)
        {
            NSString *tokenStr = [dataDict objectForKey:@"token"];
            success ? success(tokenStr) : nil;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/user/token";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end
