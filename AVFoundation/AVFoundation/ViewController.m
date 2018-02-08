//
//  ViewController.m
//  AVFoundation
//
//  Created by luowei on 18/2/6.
//  Copyright © 2018年 luowei. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>//录制视频
#import <AssetsLibrary/AssetsLibrary.h>//保存视频
@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic) MPMoviePlayerController *mpVC;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayerPlaybackDidFinishNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    /*
     测试
     */
    
    /*
     小明改写测试
     */
    
    /*
     项目改写测试
     */
    
    /*
     v1.0修复
     v3.0
     */
}

-(void)test {

    NSLog(@"v2.0");
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

//    NSString *title = NSLocalizedString(@"title", nil);
//    NSString *message = NSLocalizedString(@"message", nil);
//    NSString *commit = NSLocalizedString(@"commit", nil);
    
    NSString *title = NSLocalizedStringFromTable(@"title", @"en", nil);
    NSString *message = NSLocalizedStringFromTable(@"message", @"en", nil);
    NSString *commit = NSLocalizedStringFromTable(@"commit", @"en", nil);
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:commit otherButtonTitles:nil, nil];
    
    [alert show];
    
}

-(void)moviePlayerPlaybackDidFinishNotification:(NSNotification *)notification{

    NSLog(@"调用通知:%@",notification.userInfo);
    
    NSInteger integ = [notification.userInfo[MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue];
    
    /*MPMovieFinishReasonPlaybackEnded,
     MPMovieFinishReasonPlaybackError,
     MPMovieFinishReasonUserExited
     */
    
    switch (integ) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"播放完成");
//            [self.mpVC.view removeFromSuperview];
            break;
            
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"播放错误");
            break;
            
        case MPMovieFinishReasonUserExited:
            NSLog(@"播放退出");
//            [self.mpVC.view removeFromSuperview];
            break;
        default:
            break;
    }
    [self.mpVC.view removeFromSuperview];
}
//视频录制
- (IBAction)recordVideo:(id)sender {
    
    //判断是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    //创建图片选择器
    UIImagePickerController *imagPicker = [UIImagePickerController new];
    
    //设置类型
    imagPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //设置媒体类型
    imagPicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    //设置相机的检测模式(可选)
    imagPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    //设置视频质量(可选)
    imagPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置代理
    imagPicker.delegate = self;
    
    //模态弹出
    [self presentViewController:imagPicker animated:YES completion:nil];
    
}
//视频压缩
- (IBAction)compression:(id)sender {
    //判断是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    
    //创建图片选择器
    UIImagePickerController *imagPicker = [UIImagePickerController new];
    
    //设置类型
    imagPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //设置媒体类型
    imagPicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    //设置相机的检测模式(可选)
    imagPicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    //设置视频质量(可选)
    imagPicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置代理
    imagPicker.delegate = self;
    
    //模态弹出
    [self presentViewController:imagPicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //判断是否为视频媒体类型
    id url = info[UIImagePickerControllerMediaURL];
    
    //开始导出压缩
    [self exportVideo:url];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    /*-------------------------视频录制----------------------------*/
    /*
    //播放视频
    
    //获取媒体类型
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    //判断是否为视频媒体类型
    id url = info[UIImagePickerControllerMediaURL];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        
        if (self.mpVC == nil) {
            self.mpVC = [MPMoviePlayerController new];
            self.mpVC.view.frame = CGRectMake(30, 200, self.view.bounds.size.width-60, 300);
            [self.view addSubview:self.mpVC.view];
            
        }
        
        self.mpVC.contentURL = url;
        [self.mpVC play];
    }
    
    //保存视频
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        ALAssetsLibrary *assetLib = [ALAssetsLibrary new];
        [assetLib writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
     */
}

-(void)exportVideo:(NSURL *)url{

    //获取资源
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    //根据资源，创建资源导出会话对象
    AVAssetExportSession *assetEx = [[AVAssetExportSession alloc]initWithAsset:asset presetName:AVAssetExportPresetLowQuality];
    
    //设置导出路径
    assetEx.outputURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"1234.mov"]];
    
    //设置导出类型
    assetEx.outputFileType = AVFileTypeQuickTimeMovie;
    
    //开始导出
    [assetEx exportAsynchronouslyWithCompletionHandler:^{
        NSLog(@"导出成功");
    }];
}

//AV截图
- (IBAction)screenshotsAVKit:(id)sender {
    //获取URL
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"9533522808.f4v.mp4" withExtension:nil];
    //获取资源
    AVAsset *asset = [AVAsset assetWithURL:url];
    
    //创建资源图片生成器
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    
    //开始生成图像
    CMTime time = CMTimeMake(30, 1);
    NSValue *value = [NSValue valueWithCMTime:time];
    [generator generateCGImagesAsynchronouslyForTimes:@[value] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        //主线程中更新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.imgView.image = [UIImage imageWithCGImage:image];
        });
        
    }];
    
}

//AV播放
- (IBAction)avkitTest:(id)sender {
    
    AVPlayerViewController *aVC = [[AVPlayerViewController alloc]init];
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"9533522808.f4v.mp4" withExtension:nil];
    aVC.player = [AVPlayer playerWithURL:url];
    [aVC.player play];
    [self presentViewController:aVC animated:YES completion:nil];
}

-(IBAction)test2{
    //不带VIEW的播放器 --->需要强引用属性，设置frame,添加到View上，开始播放
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"9533522808.f4v.mp4" withExtension:nil];
    self.mpVC = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //设置frame
    self.mpVC.view.frame = CGRectMake(0, 0, 400, 400);
    
    
    //添加到VIEW
    [self.view addSubview:self.mpVC.view];
    
    //准备播放  调用play时候会自动调用prepareToPlay
    [self.mpVC prepareToPlay];
    
    //开始播放
    [self.mpVC play];
    
    //播放模式设置
    self.mpVC.controlStyle = MPMovieControlStyleFullscreen;
}

-(IBAction)test1{
    //带VIEW的播放器
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"9533522808.f4v.mp4" withExtension:nil];
    MPMoviePlayerViewController *mpVC = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    [self presentViewController:mpVC animated:YES completion:nil];
    
}

-(void)dealloc{

    //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
