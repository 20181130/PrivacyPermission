# __NSAuthorityManager__ &copy;*GREENBANYAN*
![Cocoapods](https://img.shields.io/badge/Cocoapods-Support-green.svg)&nbsp;
![License](https://img.shields.io/badge/License-MIT-orange.svg)&nbsp;
![Platform](https://img.shields.io/badge/Platform-iOS-yellowgreen.svg)&nbsp;
![Support](https://img.shields.io/badge/Support-iOS%208%2B-lightgrey.svg)&nbsp;

>  NSAuthorityManage，是一个iOS设备权限管理器，可以用它来做更友好的设备权限交互体验。
>
>  你可以参考periscope提示设备权限的UI来完成自己的权限提示
>，你也可以自己设计一个UI来完成它。

*__代码目录__*
* NSAuthorityStatus 
* NSAuthoritySingleton
* NSAuthorityProtocol
* NSAuthorityManager
____
*__Example__*
>例如请求开启一个相机权限:
```
 if([NSAuthorityManager isObtainPHPhotoAuthority]){
       NSLog(@"已经开启相机权限");
     }else{
   [[NSAuthorityManager sharedInstance]obtainPHPhotoAuthorizedStatus];
 }
 ```
 ___Installation___
 <pre>
 pod 'NSAuthorityManager'
 </pre>
 
[*__简书__*](http://www.jianshu.com/p/63b6e513456c)
