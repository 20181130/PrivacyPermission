# __NSAuthorityManager__ &copy;*GREENBANYAN*


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
 
[简书](http://www.jianshu.com/p/63b6e513456c)

[简书]:<http://www.jianshu.com/p/63b6e513456c>
[我的博客](http://blog.csdn.net/guodongxiaren)
