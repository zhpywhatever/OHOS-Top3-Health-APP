# DanmakuFlameMaster

## 简介
> DanmakuFlameMaster是一款弹幕框架，支持发送纯文本弹幕、设置弹幕在屏幕的显示区域、控制弹幕播放状态等功能
<img src="./gifs/演示效果.gif"/>

## 下载安装
````
ohpm install @ohos/danmakuflamemaster
````

OpenHarmony ohpm环境配置等更多内容，请参考 [如何安装OpenHarmony ohpm包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)
## 使用说明

### 初始化：并设置弹幕显示相关属性
```
 this.model.setWidth(lpx2px(720))
    this.model.setHeight(lpx2px(720))
    let maxLinesPair: Map<number, number> = new Map();
    maxLinesPair.set(BaseDanmaku.TYPE_SCROLL_RL, 5);
    let overlappingEnablePair: Map<number, boolean> = new Map();
    overlappingEnablePair.set(BaseDanmaku.TYPE_SCROLL_RL, true);
    overlappingEnablePair.set(BaseDanmaku.TYPE_FIX_TOP, true);
    this.mContext = DanmakuContext.create();
    this.mContext.setDanmakuStyle(DANMAKU_STYLE_STROKEN, 3)
      .setDuplicateMergingEnabled(false)
      .setScrollSpeedFactor(1.2)
      .setScaleTextSize(1.2)
      .setCacheStuffer(new SpannedCacheStuffer(), this.mCacheStufferAdapter) // 图文混排使用SpannedCacheStuffer
      .setMaximumLines(maxLinesPair)
      .preventOverlapping(overlappingEnablePair)
      .setDanmakuMargin(40);
    let that = this
    if (this.model != null) {
      this.mParser = this.createParser();
      this.model.setCallback(new Call(that));
      this.model.setOnDanmakuClickListener(new OnDanMu(that))
      this.model.prepare(this.mParser, this.mContext);
      this.model.showFPS(true);
    }
  class Call implements Callback {
  private that: ESObject;

  constructor(that: ESObject) {
    this.that = that
  }

  public updateTimer(timer: DanmakuTimer): void {
  }

  public drawingFinished(): void {

  }

  public danmakuShown(danmaku: BaseDanmaku): void {
  }

  public prepared(): void {
    this.that.model.start();
  }
}
class OnDanMu implements OnDanmakuClickListener {
  private that:ESObject;
  constructor(that :ESObject) {
    this.that = that
  }
  onDanmakuClick(danmakus: IDanmakus): boolean{
    console.log('DFM onDanmakuClick: danmakus size:' + danmakus.size())
    let latest: BaseDanmaku = danmakus.last()
    if (null != latest) {
      console.log('DFM onDanmakuClick: text of latest danmaku:' + latest.text)
      return true
    }
    return false
  };

  onDanmakuLongClick(danmakus: IDanmakus): boolean{
    return false
  };

  onViewClick(view: IDanmakuView): boolean{
    this.that.isVisible = true
    return false
  };
}

```
### 添加弹幕
```
let danmaku: BaseDanmaku = this.mContext.mDanmakuFactory.createDanmaku(BaseDanmaku.TYPE_SCROLL_RL);
    danmaku.text = "这是一条弹幕" + SystemClock.uptimeMillis();
    danmaku.padding = 5;
    danmaku.priority = 0; // 可能会被各种过滤器过滤并隐藏显示
    danmaku.isLive = isLive.valueOf();
    danmaku.setTime(this.model.getCurrentTime() + 1200);
    danmaku.textSize = 25 * (this.mParser.getDisplayer().getDensity() * 0.8);
    danmaku.textColor = 0xffff0000;
    danmaku.textShadowColor = 0xffffffff;
    danmaku.borderColor = 0xff00ff00;
    this.model.addDanmaku(danmaku);
```
## 接口说明
` model: DanmakuView.Model = new DanmakuView.Model()`
1. 添加弹幕
   `model.addDanmaku(danmaku)`
2. 获取当前弹幕时间
   `model.getCurrentTime()`
3. 隐藏弹幕显示
   `model.hide()`
4. 弹幕显示
   `model.show()`
5. 弹幕暂停播放
   `model.pause()`
6. 弹幕继续播放
   `model.resume()`
7. 设置弹幕显示区域宽度
   `model.setWidth(lpx2px(1280))`
8. 设置弹幕显示区域高度
   `model.setHeight(lpx2px(720))`
9. 启动弹幕播放
   `model.prepare(this.mParser, this.mContext)`
10. 显示弹幕播放的fps
    `model.showFPS(true)`
11. 设置弹幕点击回调
    `model.setOnDanmakuClickListener()`

`DanmakuContext()`
1. DanmakuContext构造器
   `public static create(): DanmakuContext`
2. 获取弹幕排序器
   `public getBaseComparator(): BaseComparator`
3. 设置弹幕排序器
   `public setBaseComparator(baseComparator: BaseComparator)`
4. 获取弹幕显示器
   `public getDisplayer(): AbsDisplayer<ESObject, ESObject>`
5. 设置字体样式
   `public setTypeface(font: string): DanmakuContext`
6. 设置弹幕透明度
   `public setDanmakuTransparency(p: number): DanmakuContext`
7. 设置缩放字体大小
   `public setScaleTextSize(p: number): DanmakuContext`
8. 设置弹幕显示外边距
   `public setDanmakuMargin(m: number): DanmakuContext`
9. 设置弹幕显示上边距
   `public setMarginTop(m: number): DanmakuContext`
10. 获取是否显示顶部弹幕
   `public getFTDanmakuVisibility(): boolean`
11. 设置是否显示底部弹幕
   `public setFBDanmakuVisibility(visible: boolean): DanmakuContext`
12. 获取是否显示左右滚动弹幕
   `public getL2RDanmakuVisibility(): boolean`
13. 设置是否显示左右滚动弹幕
   `public setL2RDanmakuVisibility(visible: boolean): DanmakuContext`
14. 获取是否显示右左滚动弹幕
   `public getR2LDanmakuVisibility(): boolean`
15. 设置是否显示右左滚动弹幕
   `public setR2LDanmakuVisibility(visible: boolean): DanmakuContext`
16. 获取是否显示特殊弹幕
   `public getSpecialDanmakuVisibility(): boolean`
17. 设置是否显示特殊弹幕
   `public setSpecialDanmakuVisibility(visible: boolean): DanmakuContext`
18. 设置同屏弹幕密度，-1自动 0无限制
   `public setMaximumVisibleSizeInScreen(maxSize: number): DanmakuContext`
19. 设置描边样式
   `public setDanmakuStyle(style: number, ...values: number[]): DanmakuContext`
20. 设置弹幕是否粗体显示
   `public setDanmakuBold(bold: boolean): DanmakuContext`
21. 设置色彩过滤弹幕白名单
   `public setColorValueWhiteList(colors: number[]): DanmakuContext`
22. 获取色彩过滤弹幕白名单
   `public getColorValueWhiteList(): number[]`
23. 设置屏蔽特定用户的弹幕
   ` public setUserHashBlackList(hashes: string[]): DanmakuContext`
24. 移除黑名单的用户
   `public removeUserHashBlackList(hashes: string[]): DanmakuContext`
25. 增加黑名单的用户
   `public addUserHashBlackList(hashes: string[]): DanmakuContext`
26. 获取黑名单用户
   `public getUserHashBlackList(): string[]`
27. 是否屏蔽游客弹幕
   `public blockGuestDanmaku(block: boolean): DanmakuContext`
28. 设置滚动弹幕速率
   `public setScrollSpeedFactor(p: number): DanmakuContext`
29. 设置是否启用合并重复弹幕
   `public setDuplicateMergingEnabled(enable: boolean): DanmakuContext`
30. 获取是否启用合并重复弹幕
   `public isDuplicateMergingEnabled(): boolean`
31. 设置底部是否可以有弹幕
   `public alignBottom(enable: boolean): DanmakuContext`
32. 获取底部是否可以有弹幕的状态
   `public isAlignBottom(): boolean`
33. 设置最大弹幕显示行数
   `public setMaximumLines(pairs: Map<number, number>): DanmakuContext`
34. 设置防止弹幕重叠
   `public setOverlapping(pairs: Map<number, boolean>): DanmakuContext`
35. 获取是否有最大行数限制
   ` public isMaxLinesLimited(): boolean`
36. 获取是否开启防止弹幕重叠功能
   ` public isPreventOverlappingEnabled(): boolean`
37. 设置弹幕同步器
   `public setDanmakuSync(danmakuSync: AbsDanmakuSync): DanmakuContext`
38. 设置弹幕缓存填充器
   `public setCacheStuffer(cacheStuffer: BaseCacheStuffer, cacheStufferAdapter: Proxy): DanmakuContext`
39. 设置配置信息改变回调接口
   `public registerConfigChangedCallback(listener: ConfigChangedCallback): void`
40. 取消配置信息改变回调接口
   `public unregisterConfigChangedCallback(listener: ConfigChangedCallback): void`
41. 设置弹幕过滤器
   `public registerFilter(filter: BaseDanmakuFilter<ESObject>): DanmakuContext`
42. 取消弹幕过滤器
   `public unregisterFilter(filter: BaseDanmakuFilter<ESObject>): DanmakuContext`
43. 重置DanmakuContext
   `public resetContext(): DanmakuContext`

`Proxy()`
1. 预绘制缓存弹幕
   `public abstract prepareDrawing(danmaku: BaseDanmaku, fromWorkerThread: boolean)`
2. 释放弹幕资源
   `public abstract releaseResource(danmaku: BaseDanmaku)`

`DanmakuTimer()`
1. 更新定时器时间
   `public update(curr: number): number`
2. 增加计时的时间
   `public add(mills: number): number`
3. 获取距离计时结束剩余的时间
   ` public getLastInterval(): number`

`Duration()`
1. 设置弹幕初始持续时间
   `public setValue(initialDuration: number)`
2. 设置弹幕初始持续时间系数
   `public setFactor(f: number)`

`SpecialDanmaku()`
1. 获取顶部固定弹幕的左边距
   `public getLeft(): number`
2. 获取顶部固定弹幕的上边距
   `public getTop(): number`
3. 获取顶部固定弹幕的右边距
   `public getRight(): number`
4. 获取顶部固定弹幕的下边距
   `public getBottom(): number`
5. 获取弹幕的类型
   `public getType(): number`
6. 设置特效弹幕平移数据
   `public setTranslationData(beginX: number, beginY: number, endX: number, endY: number,
   translationDuration: number, translationStartDelay: number)`
7. 设置特效弹幕透明度变化数据
   `public setAlphaData(beginAlpha: number, endAlpha: number, alphaDuration: number)`

`DanmakuUtils()`
1. 比较两个弹幕是否相同
   `public static compare(obj1: BaseDanmaku, obj2: BaseDanmaku): number`
2. 弹幕是否重复
   `public static isDuplicate(obj1: BaseDanmaku, obj2: BaseDanmaku): boolean`
3. 创建弹幕工厂
   `public static create(): DanmakuFactory`

## 约束与限制

在下述版本验证通过：

- DevEco Studio 版本： 4.1 Canary(4.1.3.317),OpenHarmony SDK:API11 (4.1.0.36)。

## 目录结构
````
|---- DanmakuFlameMaster  
|     |---- entry  # 示例代码文件夹
|     |---- library  # DanmakuFlameMaster库文件夹
|           |---- src\main\ets\components\common\master\flame\danmaku  # 源代码文件夹
|           		|---- control   # 弹幕状态控制实现
|           		|---- danmaku 	# 弹幕基础类库
|           		|---- ui 		# 弹幕自定义显示控件
|           |---- index.ets  # 对外接口
|     |---- README.md  # 安装使用方法                    
````

## 贡献代码
使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-sig/DanmakuFlameMaster/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-sig/DanmakuFlameMaster/pulls) 。

## 开源协议
本项目基于 [Apache License 2.0](https://gitee.com/openharmony-sig/DanmakuFlameMaster/blob/master/LICENSE) ，请自由地享受和参与开源。