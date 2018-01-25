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
//@property (nonatomic, strong)   NSString    *phoneNumber;
//@property (nonatomic, strong)   NSString    *password;
@end

@implementation TCServerWarningRequest

/*
- (instancetype) initWithPhoneNumber:(NSString *)phoneNumber password:(NSString *)password
{
    self = [super init];
    if (self)
    {
        _phoneNumber = phoneNumber;
        _password = password;
    }
    return self;
}
 */

/*
+ (TCPasswordLoginRequest *)requestWithPhoneNumber:(NSString *)phoneNumber
                                  password:(NSString *)password
                                   success:(void(^)(NSString *token))success
                                   failure:(void(^)(NSString *message))failure
{
    TCPasswordLoginRequest *request = [[TCPasswordLoginRequest alloc] initWithPhoneNumber:phoneNumber password:password];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *dataDict = [request.responseJSONObject objectForKey:@"data"];
        NSString *token = [dataDict objectForKey:@"token"];
        success ? success(token) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *message = [request.responseJSONObject objectForKey:@"message"];
        failure ? failure(message) : nil;
    }];
    return request;
}
 */

- (void) startWithSuccess:(void(^)(NSArray<TCServer*> *serverArray))success
                  failure:(void(^)(NSString *message))failure
{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *dataDictArray = [request.responseJSONObject objectForKey:@"data"];
        //NSArray *serverListDict = [dataDict objectForKey:@"server_list"];
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        //TCUser *user = [TCUser mj_objectWithKeyValues:userDict context:context];
        //success ? success(user) : nil;
        NSArray *sArray = [TCServer mj_objectArrayWithKeyValuesArray:dataDictArray context:context];
        success ? success(sArray) : nil;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure ? failure([self errorMessaage]) : nil;
    }];
}

- (NSString *)requestUrl {
    return @"/api/cluster/warn/1";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument
{
    /*
    return @{@"mobile":_phoneNumber,
             @"password":_password
             };
     */
    return nil;
}

@end
