//
//  ViewController.m
//  MessageAFNDemo
//
//  Created by WindXu on 17/3/8.
//  Copyright © 2017年 YJKJ-CaoXu. All rights reserved.
//

#import "ViewController.h"

#import <MessageUI/MessageUI.h>

@interface ViewController ()<MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) UITextField * photoText;

@property (nonatomic, strong) UITextField * messageText;

@property (nonatomic, strong) UIImage     * imageCache;

@property (nonatomic, strong) NSString    * urlStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSetupView];
    //http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg
    //http://img02.tooopen.com/images/20140504/sy_60294738471.jpg
    //http://pic78.huitu.com/res/20160604/1029007_20160604114552332126_1.jpg
    _urlStr = @"http://pic78.huitu.com/res/20160604/1029007_20160604114552332126_1.jpg";
    
    _imageCache = [self getImageFromURL:_urlStr];
    
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"保存路径:%@",documentsDirectoryPath);
    
    //Save Image to Directory
    [self saveImage:_imageCache withFileName:@"MyImage" ofType:@"png" inDirectory:documentsDirectoryPath];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 280, 80, 80)];
    imageView.backgroundColor = [UIColor orangeColor];
    imageView.image = _imageCache;
    [self.view addSubview:imageView];
    

    
}
-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    
    return result;
}
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    
    //清空历史图片
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]]]) {
        [fileManager removeItemAtPath:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] error:nil];
    }
    
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}
- (void)configureSetupView {
    _photoText = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, CGRectGetWidth(self.view.frame)-40, 30)];
    _photoText.borderStyle = UITextBorderStyleRoundedRect;
    _photoText.placeholder = @"手机号码";
    _photoText.text = @"13914";
    [self.view addSubview:_photoText];
    
    _messageText = [[UITextField alloc]initWithFrame:CGRectMake(20, 130, CGRectGetWidth(self.view.frame)-40, 30)];
    _messageText.borderStyle = UITextBorderStyleRoundedRect;
    _messageText.placeholder = @"短信息";
    _messageText.text = @"今天是3月8日妇女节，祝妇女节快乐";
    [self.view addSubview:_messageText];
    
    UIButton * sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sendBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-45, 180, 90, 30);
    [sendBtn setTitle:@"发送文字短信" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    UIButton * sendPicBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    sendPicBtn.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2-45, 230, 90, 30);
    [sendPicBtn setTitle:@"发送彩信" forState:UIControlStateNormal];
    [sendPicBtn addTarget:self action:@selector(sendPicBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendPicBtn];
}
- (void)sendBtnClick:(UIButton *)send {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * messageVC = [[MFMessageComposeViewController alloc]init];
        messageVC.recipients = @[self.photoText.text];
        
        messageVC.body = self.messageText.text;
        messageVC.messageComposeDelegate = self;
        /** 取消按钮的颜色(附带,可不写) */
        messageVC.navigationBar.tintColor = [UIColor redColor];
        [self presentViewController:messageVC animated:YES completion:nil];
    }else{
        NSLog(@"模拟器不支持发送短信");
    }
}
- (void)sendPicBtnClick:(UIButton *)sendPic {
    if ([MFMessageComposeViewController canSendAttachments]) {
        MFMessageComposeViewController * messageVC = [[MFMessageComposeViewController alloc]init];
        messageVC.recipients = @[self.photoText.text];
        
        messageVC.body = self.messageText.text;
        //本地图片
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//        if ([messageVC addAttachmentURL:[NSURL fileURLWithPath:path] withAlternateFilename:nil])
//        {
//            NSLog(@"添加成功");
//        }else{
//            NSLog(@"失败");
//        }
        //网络图片
//        NSData * imageData = UIImageJPEGRepresentation(_imageCache, 1.0);
         NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * path = [documentsDirectoryPath stringByAppendingPathComponent:@"MyImage.png"];
        if ([messageVC addAttachmentURL:[NSURL fileURLWithPath:path] withAlternateFilename:nil])
        {
            NSLog(@"添加成功");
        }else{
            NSLog(@"失败");
        }
//        NSData * imageData = UIImagePNGRepresentation(_imageCache);
//        if ([messageVC addAttachmentData:imageData typeIdentifier:@"png" filename:@""]) {
//            NSLog(@"添加成功");
//        }else{
//            NSLog(@"添加失败");
//        }
        messageVC.messageComposeDelegate = self;
        /** 取消按钮的颜色(附带,可不写) */
        messageVC.navigationBar.tintColor = [UIColor redColor];
        [self presentViewController:messageVC animated:YES completion:nil];
    }else{
        NSLog(@"模拟器不支持发送短信");
    }
}
#pragma mark - MFMessageComposeViewControllerDelegate
/**
 *  协议方法,在信息界面处理完信息结果时调用(比如点击发送,取消发送,发送失败)
 *
 *  @param controller 信息控制器
 *  @param result     返回的信息发送成功与否状态
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    /** 发送完信息就回到原程序*/
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"发送取消");
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
