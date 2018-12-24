//
//  BJURLProtocol.m
//  BJJSPatch
//
//  Created by zhangwenjun on 2017/10/27.
//  Copyright © 2017年 zhangwenjun. All rights reserved.
//

#import "BJURLProtocol.h"

@implementation BJURLProtocol

//是否处理传入的request，如果return YES则会执行接下来的startLoading
+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    
    
    NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:@"filteredCssKey" inRequest:request])
            return NO;
        
        return YES;
    }
    return NO;
    
    
//    // 这里是html 渲染时候入口，来处理自定义标签 如 "xadsdk",若return YES 则会执行接下来的 -startLoading方法
//    if ([request.URL.scheme caseInsensitiveCompare:@"zwj"] == NSOrderedSame) {
//        return YES;
//    }
//    return NO;

}


//返回格式化好的request，可以地址重定向
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSLog(@"canonicalRequestForRequest:%@",request.URL.absoluteString);

    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    //截取重定向
    if ([request.URL.absoluteString isEqualToString:@"http://47.95.116.109:8080/"])
    {
        NSURL* url1 = [NSURL URLWithString:@"http://47.95.116.109:8080/"];
        mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
    }
    return mutableReqeust;
    
    return request;

}




//判断两个请求是否为同意一个请求，如果是同一个请求会使用缓存数据
- (void)startLoading{
//    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
//    //给我们处理过的请求设置一个标识符, 防止无限循环,
//    [NSURLProtocol setProperty:@YES forKey:@"key" inRequest:mutableReqeust];
//    
//    BOOL enableDebug = NO;
//    //这里最好加上缓存判断
//    if (enableDebug)
//    {
//        NSString *str = @"写代码是一门艺术";
//        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:mutableReqeust.URL
//                                                            MIMEType:@"text/plain"
//                                               expectedContentLength:data.length
//                                                    textEncodingName:nil];
//        [self.client URLProtocol:self
//              didReceiveResponse:response
//              cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//        [self.client URLProtocol:self didLoadData:data];
//        [self.client URLProtocolDidFinishLoading:self];
//    }
//    else
//    {
//        self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];
//    }
    
    
    // 处理自定义标签 ，并实现内嵌本地资源
    // 当url的scheme是xadsdk开头的，那么加载本地的图片文件并替换,本地的图片在document目录下的test.png
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *path=[docDir stringByAppendingPathComponent:@"ksrz_chenggong@2x.png"];
    
    
    
    //根据路径获取MIMEType   （以下函数方法需要添加.h文件的引用，）
    // Get the UTI from the file's extension:
    CFStringRef pathExtension = (__bridge_retained CFStringRef)[path pathExtension];
    CFStringRef type = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension, NULL);
    CFRelease(pathExtension);
    
    // The UTI can be converted to a mime type:
    NSString *mimeType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass(type, kUTTagClassMIMEType);
    if (type != NULL)
        CFRelease(type);
    
    // 这里需要用到MIMEType
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:super.request.URL
                                                        MIMEType:mimeType
                                           expectedContentLength:-1
                                                textEncodingName:nil];
    //加载本地资源
    NSData *data = [NSData dataWithContentsOfFile:path];
    //硬编码 开始嵌入本地资源到web中
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [[self client] URLProtocol:self didLoadData:data];
    [[self client] URLProtocolDidFinishLoading:self];
}

- (void)stopLoading
{
    if (self.connection != nil)
    {
        [self.connection cancel];
        self.connection = nil;
    }
}


+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}



@end
