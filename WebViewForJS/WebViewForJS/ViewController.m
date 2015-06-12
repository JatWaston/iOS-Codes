//
//  ViewController.m
//  WebViewForJS
//
//  Created by JatWaston on 15/6/12.
//  Copyright (c) 2015年 JatWaston. All rights reserved.
//

#import "ViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ViewController () <UIWebViewDelegate> {
    UIWebView *_webView;
    UIButton *_button;
    UIButton *_injectBtn;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor clearColor];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"info.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.backgroundColor = [UIColor grayColor];
    [_button setTitle:@"点击一下" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.frame = CGRectMake(50, 300, self.view.bounds.size.width-100, 30);
    [_button addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    _injectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _injectBtn.backgroundColor = [UIColor grayColor];
    [_injectBtn setTitle:@"JS注入" forState:UIControlStateNormal];
    [_injectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _injectBtn.frame = CGRectMake(50, 340, self.view.bounds.size.width-100, 30);
    [_injectBtn addTarget:self action:@selector(press:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_injectBtn];
}

/**===========================JS  注入====================================*/
- (void)jsInject {
    [_webView stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function myFunction() { "   //定义myFunction方法
     "var field = document.getElementsByName('word')[0];"
     "field.value='WWDC2014';"
     "document.forms[0].submit();"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];  //添加到head标签中
    [_webView stringByEvaluatingJavaScriptFromString:@"myFunction();"];
}

- (void)press:(id)sender {
    //OC调用网页中的JS代码
    if (_button == (UIButton*)sender) {
        [_webView stringByEvaluatingJavaScriptFromString:@"clickme()"];
    } else if (_injectBtn == (UIButton*)sender) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com/"]]];
        [self performSelector:@selector(jsInject) withObject:nil afterDelay:3.0f];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSLog(@"navigationType = %ld cachePolicy = %ld",navigationType,request.cachePolicy);
    
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/getInfo/name"]) {
        NSString *info = [[UIDevice currentDevice] name];
        NSString *js = [NSString stringWithFormat:@"showInfo(\"name\",\"%@\")",info];
        [webView stringByEvaluatingJavaScriptFromString:js];
        return NO;
    }
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/getInfo/systemVersion"]) {
        NSString *info = [[UIDevice currentDevice] systemVersion];
        NSString *js = [NSString stringWithFormat:@"showInfo(\"systemVersion\",\"%@\")",info];
        [webView stringByEvaluatingJavaScriptFromString:js];
        return NO;
    }
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/getInfo/imei"]) {
        NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSString *js = [NSString stringWithFormat:@"showInfo(\"imei\",\"%@\")",adid];
        [webView stringByEvaluatingJavaScriptFromString:js];
        return NO;
    }
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/getInfo/ip"]) {
        NSString *ip = [self getIPAddress];
        NSString *js = [NSString stringWithFormat:@"showInfo(\"ip\",\"%@\")",ip];
        [webView stringByEvaluatingJavaScriptFromString:js];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title = %@",title);
}

@end
