GYM Activity Gadget [Sina Weibo]
================================

**Desktop Version**

![ScreenShot](https://raw.githubusercontent.com/leonyuzhao/GYMActivityGadget-SinaWeibo-/master/screenshots/overview.jpg)


**Mobile Version**

![ScreenShot](https://raw.githubusercontent.com/leonyuzhao/GYMActivityGadget-SinaWeibo-/master/screenshots/mobile.jpg)


**Success Screenshot**
![ScreenShot](https://raw.githubusercontent.com/leonyuzhao/GYMActivityGadget-SinaWeibo-/master/screenshots/success.jpg)


The aspx page will let you to quick update your daily gym work activities to share with friends.
* Work with Sina Weibo APIs 
* Work on mobile browser 

Setup & Installation
====================

Modify web.config with your Sina Weibo developer account setting:
  
  ```
  <add key="username" value="#WEIBOUSERNAME#"/>
  <add key="password" value="#WEIBOPASSWORD#"/>
  <add key="appkey" value="#WEIBOAPPKEY#"/>
  ```
  
Make sure add following <a href="https://github.com/leonyuzhao/Utility-CodeSnippet-" target="_blank">references</a> into your project before compile. 

Web.cs utility file should be put within the same folder as main aspx page. Or modify the follow link to refect the change:

  ```
  <%@ Assembly Src="Web.cs" %>
  ```

TODO
==== 
* Extend with Twitter APIs
* More items to be recorded
* Add calorie estimation to sum up daily calorie burning amount
* Daily/weekly/monthly report functionality

Author
======
Leon Yu Zhao

