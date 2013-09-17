//
//  CodeCSVService.m
//  Acquirer
//
//  Created by chinapnr on 13-9-17.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#import "CodeCSVService.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation CodeCSVService

-(void)requestForCodeCSVVersion{
    [[Acquirer sharedInstance] showUIPromptMessage:@"请求配置文件版本" animated:YES];
    
    NSString *urlSTR = @"http://posapp.chinapnr.com/interface/shoudanservice.php?act=GetCodeVer&key=SHOUDAN-CHINAPNR";
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlSTR]];
    [req setDidFinishSelector:@selector(codeCSVVersionDidFinished:)];
    req.delegate = self;
    [req startAsynchronous];
}

-(void)codeCSVVersionDidFinished:(ASIHTTPRequest *)req{
    NSDictionary *body = [req.responseString JSONValue];
    
    if (NotNilAndEqualsTo(body, @"return_code", @"1")) {
        NSString *versionSTR = [body objectForKey:@"ver"];
        if (![Helper stringNullOrEmpty:versionSTR]) {
            codeVersion = [versionSTR intValue];
            if (codeVersion > [Acquirer sharedInstance].codeCSVVersion) {
                [self requestForDownloadCodeCSV];
            }else{
                [[Acquirer sharedInstance] hideUIPromptMessage:YES];
            }
        }
    }else{
        [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    }
}

-(void)requestForDownloadCodeCSV{
    [[Acquirer sharedInstance] showUIPromptMessage:@"下载配置文件" animated:YES];
    
    NSString *urlSTR = @"http://posapp.chinapnr.com/appconfig/code.csv";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *destPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"code.csv"];
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlSTR]];
    [req setDownloadDestinationPath:destPath];
    [req setDidFinishSelector:@selector(codeCSVDwonloadDidFinished:)];
    req.delegate = self;
    [req startAsynchronous];
}

-(void)codeCSVDwonloadDidFinished:(ASIHTTPRequest *)req{
    [[Acquirer sharedInstance] hideUIPromptMessage:YES];
    
    [Acquirer sharedInstance].codeCSVVersion = codeVersion;
    [Helper saveValue:[NSString stringWithFormat:@"%d", codeVersion] forKey:CODE_CSV_VERSION];
    
    
}

@end
