//
//  TCInviteInfoRequest.m
//
//
//  Created by huangdx on 2017/12/05.
//  Copyright © 2017年 10.com. All rights reserved.
//

#import "TCInviteInfoRequest.h"
#import "TCInviteInfo+CoreDataClass.h"

@interface TCInviteInfoRequest()
@property (nonatomic, strong)   NSString    *code;
@end

@implementation TCInviteInfoRequest

- (instancetype) initWithCode:(NSString*)code
{
    self = [super init];
    if (self)
    {
        _code = code;
    }
    return self;
}

- (void) startWithSuccess:(void(^)(TCInviteInfo *info))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        //TCServerConfig *config = [TCServerConfig mj_objectWithKeyValues:configDict context:context];
        //success ? success(config) : nil;
        TCInviteInfo *info = [TCInviteInfo mj_objectWithKeyValues:dataDict context:context];
        success ? success(info) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        //NSString *message = [request.responseJSONObject objectForKey:@"message"];
        //failure ? failure(message) : nil;
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/company/application";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    return @{@"code":_code};
}
@end
