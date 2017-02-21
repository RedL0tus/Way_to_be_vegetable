---
layout: post
title: Unofficial LineageOS build (SFMod)
date: '2016-01-09 16:08 -0800'
published: true
---
Several days ago, Cyngn shut down all services for CyanogenMod, and those developers created a fork of CyanogenMod called [LineageOS](https://lineageos.org). And at now, though we can visit their download site but they didn't start build official builds yet (2017.01.09). So I built a build from their [source code on GitHub](https://github.com/LineageOS) for my Nexus 5X(bullhead) -- Of course, with some changes.

    Changes:
    1. Change default kernel to flar2's ElementalX-4.04.
    2. Add Brevent(3.1.2).
    3. Change color theme to blue, just like Pixel (From Pure Nexus Project)
    4. Add Masquerade and Substratum.
    5. System embedded Magisk Manager
    
And... I call it SFMod, you can find source code [here](https://github.com/SFMod)

(The reason why I stop using Pure Nexus is that the maintainer of Pure Nexus allways reset repo's HEAD and `git push -f` so when I merge from those repo, it always make many conflicts; And always fail to build it from source.)

Here is the download link: [Google Drive](https://drive.google.com/file/d/0B5BS_3kBfTlkLWRZaENGOHN1NTg/view?usp=sharing)

![About](https://img.vim-cn.com/8e/85681240d1c07a4f410de749592faa05c81cc3.png)
