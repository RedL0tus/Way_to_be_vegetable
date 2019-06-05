---
title: WSL SSH Launcher
layout: post
date: 2019-06-02 13:35:00 +0800
---

<a href="#en">Chinglish version</a>  
<a href="#zh">中文</a>

<div id="en"></div>

I'm a Linux user and recently because of some undeniable reason, I' m using Windows these days. I  haven't been using Windows for about half a year, and I got really used  to those command line tools in Linux (e,g, tmux), it's kind of  uncomfortable without them.
So I enabled WSL, installed openSUSE and Arch. After  setting up my dotfiles, I found out that there is not a single usable  terminal emulator on Windows:
 - Windows version of Alacritty cannot display some character in the right way. Tmux's status line become weird after stretching the window. 
 - Fluent Terminal looks nice but tmux's status line will disappear in some cases. 
 - ConEmu does not support dialog very well, etc.

And vim does not work well in those terminal emulators, especially for syntax highlighting (colors become indistinguishable). Seems these situations are caused by ConHost and people who build those terminal emulators cannot fix that on  their own. I know they tried their best.

~~Macrohard~~ Microsoft said they are going to fix that and released Windows Terminal at Build 2019, I'm very glad they are working on it.  But after I downloading a Dev build from their CI, I found out that:
 - Colors are still not 100% correct in some cases, though it's still a huge improvement from the previous ConHost.
 - Does not support mouse interaction (e.g. tmux's mouse mode and vim).
 - High CPU and RAM usage. After opening 5-6 tabs, it uses 20% of my CPU (which is a 6th-gen Shintel Core i7) and over 3GB of RAM, plus another 20% usage on CPU by Antimalware service.  Performance also become unacceptable in this case, I can even see how  each character is printed out.

After searching for resolutions, I found that someone said we can use SSH clients as there are some decent SSH clients on Windows. But there are still some problems:
 - WSL does not have a real init system and service manager, so distributions with "pure" systemd only cannot start sshd as a daemon unless start by hand.
 - Even though some distribution can start sshd through RC scripts, it still needs some sort of interaction. 

Then I done a little bit of searching and found no suitable tools can start sshd  on boot (maybe it exists, but I just didn't see it). So I wrote one : )

![Screenshot](../img/wsl_ssh_screenshot.png)  
(I think the interface is pretty straight forward)

I was planning to make a UWP one but I don't know how to do it so I just made it with WPF. It's my first WPF program so… Yea it's ugly and I don't really know how to design a UI.

It has the basic functionalities I need, but still, with some issues:
 - Window cannot be resized, because I don't know how to make it resizable in the correct way.
 - Microsoft says WPF supports HiDPi, but I didn't test it since I don't have that kind of device.
 - It cannot stop the sshd process only, instead, it will kill all the WSL instance of that specific distribution:
   - I wrapped the WSL process with BackgroundWorker, but I don’t know how to stop a process inside a BackgroundWorker, my bad.
   - WSL instances are isolated so I cannot start a new process and kill the process in the previous WSL instance.
     - Sometimes it's not... I'm really confused.
   - So I did it in this way.
 - Again, it's extremely ugly.
 - Lacks error handling.

But at least it works!

Source code:  
[https://github.com/RedL0tus/WSL_SSH_Launcher](https://github.com/RedL0tus/WSL_SSH_Launcher)

GitHub Release:  
[https://github.com/RedL0tus/WSL_SSH_Launcher/releases](https://github.com/RedL0tus/WSL_SSH_Launcher/releases)

Macrohard store：  
<a href='//www.microsoft.com/store/apps/9NRPB1HPKK8G?cid=storebadge&ocid=badge'><img src='https://assets.windowsphone.com/85864462-9c82-451e-9355-a3d5f874397a/English_get-it-from-MS_InvariantCulture_Default.png' alt='English badge' style='width: 284px; height: 104px;'/></a>  
Tip: Unlimited free trial is offered.

<div id="en-privacy-policy"></div>

Privacy policy: It does not access anything other than it's configuration and things related to WSL, so you don't need to worry about anything.

<div id="zh"></div>

因为一些不可抗的原因，我这段时间在用 Windows。但是在这之前我已经有半年左右没用过 Windows 了，离开了 Linux 下的那些工具可以说是浑身难受。而且最近这段时间刚刚配了一下 tmux 之类的东西感觉挺好。到了 Windows 下可真算是这也没有那也没有了。

于是装了 openSUSE 和 Arch 两个 WSL(Windows Subsystem Linux) 发行版。装完并设置好自己的 dotfiles 之后用了一段时间才发现 Windows 下根本就没一个好用的终端模拟器：
 - Windows 版的 Alacritty 字符显示不正确，拉伸窗口之后 tmux 的 status line 显示不正常。
 - Fluent Terminal 虽然好看，字符也正常，但是换行多了之后 tmux 的 status line 会丢。
 - ConEmu 对 dialog 的支持好像有问题。

并且 vim 在这些终端模拟器里基本就是不能使用（尤其是配色上面）。这些问题据说是 ConHost 的限制，他们做终端模拟器的人也没办法。

前段时间巨硬的 Build 大会上公布了 Windows Terminal，我也去他们的 CI 上面下了一个 Dev 构建然后试了下，发现：
 - 部分地方的颜色还是不对。
 - 功能倒是没什么大问题了，但是不支持 tmux 的 mouse mode 等等。
 - 占用真的太太太太太太高了，性能也是真的很烂... 我开了 五六个标签页吃了我 3GB+ 的内存和 20+% 的 CPU，Antimalware 的那个服务在此之上又吃了 20+% 的 CPU... 我这还什么都没干呢。而且这个时候性能已经差到了能看到它一个字一个字打出来的程度，实在是遭不住。

这时候又看到说我们可以用 SSH，毕竟 Windows 下还是有不少还算好用的 SSH 客户端的嘛。可是这个方法也不是很完美。一是 WSL 里没有真正意义上的 init，像 Arch 这样只有纯 systemd 的发行版无法通过它自动启动 sshd；二是就算能用 RC 脚本启动 sshd（比如 Ubuntu），也还是需要用户操作，相对麻烦。

然后我就想造一个东西能启动 WSL 里面的 sshd，网上稍微搜了下好像也没有同类程序。我就自己下载了 Visual Studio 试着写了一个。

![截图](../img/wsl_ssh_screenshot.png)

其实本来想做成 UWP 的但是试了一下发现完全没头绪，最后用了 WPF。我总共就没做过几个图形程序，希望大佬们轻点。

现在基本功能在我这边测试是能用了（可以列出发行版，可以启动 sshd，可以开机自动启动），但是还是很不完善：

 - 窗口现在是无法拖大小的，因为我做不来。
 - 现在无法只停止 sshd 服务，只能杀死所有同个发行版的 WSL instance：
   - 我现在把跑了 sshd 的 WSL 进程放进了 BackgroundWorker，但是不知道如何正确结束掉 BackgroundWorker 里面的子进程。
   - 同时由于 WSL instance 之间是独立的，我无法通过再创建一个 WSL 进程来杀死之前的 sshd。
   - 所以最后发现我只能把它做成杀死所有 WSL instance，当然主要是我太菜。
 - 现在的 Logo 很丑，我也没办法，毕竟我不懂设计。
 - 缺少 Error handling。

但是它至少能用了嘛！

源码:  
[https://github.com/RedL0tus/WSL_SSH_Launcher](https://github.com/RedL0tus/WSL_SSH_Launcher)

GitHub Release:  
[https://github.com/RedL0tus/WSL_SSH_Launcher/releases](https://github.com/RedL0tus/WSL_SSH_Launcher/releases)

巨硬商店：  
<a href='//www.microsoft.com/store/apps/9NRPB1HPKK8G?cid=storebadge&ocid=badge'><img src='https://assets.windowsphone.com/42e5aa4a-f19a-4205-9191-a97105ed7663/Chinese_Simplified_get-it-from-MS_InvariantCulture_Default.png' alt='Chinese badge' style='width: 284px; height: 104px;'/></a>  
提示： 提供了不限时间的免费试用，或者可以去 GitHub Release 直接下载 .exe。就把这里这个收费当捐赠吧 ：）

~~绝赞盈利尝试 \#1~~

<div id="zh-privacy-policy"></div>

隐私策略：它不会访问任何它的配置文件和 WSL 以外的东西，所以没什么好担心的。