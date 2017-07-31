---
data: '2017-07-31 22:59:43 -0800'
layout: post
title: Using IBM RT3200 on modern Linux systems
---

I just bought a IBM SpaceSaver II RT3200 (P/N: 37L0888) on [Taobao](https://item.taobao.com/item.htm?id=19702143286) for just 129 CNY (about 20 USD) instead on making my own mechanical keyboard.   
It was announced in the middle of 1999, and here is the official [info](http://ps-2.kev009.com/pcpartnerinfo/ctstips/10762.htm).

I choose it because of:  
- It has UltraNav.
- Most mechanical keyboard DIY kits doesn't include trackpoint.
- Those kits like TEX Yoda which has trackpoint support are tooooooooooooo expensive to me.
- Modern ThinkPad keyboards' keys are too "soft" for me.
- Classic ThinkPad keyboards includes palm rests which I don't need.

And here is how it looks:  
![RT3200](https://img.vim-cn.com/7b/f4675db0fd01ef0756cbb6a52715333839b7ab.jpg)
(I use a sticker from AOSCC 2017 to cover up Windows logo.)  
(Ugh... Looks like a Windows 2000 logo.)

It comes in good shape and looks just like  normal 80% keyboard with UltraNav, isn't it?

-----

It is a pretty good keyboard but with several problems:  
- It uses **two** PS/2 ports (one for keyboard it self and one for UltraNav) which are rare to see on modern laptops (Of course at that time most keyboards and mice use PS/2 ports). It means you have to buy a USB to PS/2 adapter in order to use it.
- Sometimes the CapLocks key is too hard to press (Maybe it's just my own problem).
- It's UltraNav has little differences from modern ones. It's left and right keys are softer than modern ones and it use a classic "cat-tongue" TrackPoint cap.

And after I connect to my X220, everything works fine except the middle button of UltraNav, it doesn't simulate wheel like the modern ones. It probably because it's connected using an adapter so Linux cannot recognize keyboard correctly.

!["Barcode reader"](https://img.vim-cn.com/7d/396a9f0de5220d5ca8f3571f27add704c04a39.png)

(An interesting thing is Linux recognize one of my adapters as a barcode reader... Orz) 

As I said before, it's hard to identify between the keyboards connected with adapters, so I think the best solution I could find is to enable wheel emulation on all of the pointing devices that connected to this computer.

After searching on the Internet, I found a solution from [Felix Yan](https://felixc.at/) on [Arch Linux Forums](https://bbs.archlinux.org/viewtopic.php?id=133298):

Just modify XOrg's config to make all pointing devices use evdev drivers and enable wheel emulation:

    Section "InputClass"
            Identifier "evdev pointer catchall"
            MatchIsPointer "on"
            MatchDevicePath "/dev/input/event*"
            Driver "evdev"
            Option      "EmulateWheel"      "true"
            Option      "EmulateWheelButton"    "2"
            Option      "XAxisMapping"      "6 7"
            Option      "YAxisMapping"      "4 5"
    EndSection

After this, just restart XOrg and everything will be fine :)

(If you have any better idea, please comment below :)

-----

Anyway, it is a really a **GREAT** keyboard for a low price, it's old but not obsolete. ~~If you like it, you can go and get one from eBay or other places, it's not rare and expensive until now, but maybe several years later it will be another IBM Model M~~ XD