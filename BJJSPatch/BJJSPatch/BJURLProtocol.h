//
//  BJURLProtocol.h
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/10/27.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface BJURLProtocol : NSURLProtocol
@property (nonatomic, strong) NSMutableData   *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@end
