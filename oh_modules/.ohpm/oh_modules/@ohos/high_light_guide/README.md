# high_light_guide

## 介绍

基于OpenHarmony的高亮型新手引导组件，通过高亮区域与蒙版背景的明暗度对比，使用户快速锁定重点功能，快速掌握应用基本使用方法。

<img src="screenshot/highLightGuide1.gif" width="50%"/>

<img src="screenshot/highLightGuide2.gif" width="50%"/>

## 下载安装

1.安装

```
ohpm install @ohos/high_light_guide
```
OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md) 。

2.在需要使用的页面导入引导页组件，如Index.ets:

```
import { HighLightGuideBuilder,HighLightGuideComponent,Controller,GuidePage,HighLightShape,RectF} from '@ohos/high_light_guide'
```

## 使用说明

```
// 引入引导页
import { Controller, GuidePage, HighLightGuideBuilder, HighLightGuideComponent, RectF } from '@ohos/high_light_guide'

private builder: HighLightGuideBuilder | null = null;
private controller: Controller | null = null;

// 初始化引导页构建类
aboutToAppear() {
  this.builder = new HighLightGuideBuilder()
    .setLabel('guide1')
    .alwaysShow(true)
    .addGuidePage(GuidePage.newInstance()
      .addHighLight('Simple')
      .addHighLight(new RectF(0, 310, 200, 360))
      .setHighLightIndicator(this.SimpleIndicator))
}

build() {
  Column() {
    Stack() {
    
      // 添加引导页布局
      HighLightGuideComponent({
        highLightContainer: this.HighLightComponent, // 引导页覆盖时的内容布局插槽
        currentHLIndicator: null, // 引导页的引导层插槽
        builder: this.builder, // 引导页的通用配置构建类
        onReady: (controller: Controller) => { // 引导页准备好的回调，获取引导页控制器
          this.controller = controller; 
        }
      })
    }
  }
  .width('100%')
}

@Builder
private HighLightComponent() {
  Column() {
    ... // 布局内容
  }.alignItems(HorizontalAlign.Start)
  .width('100%')
  .height('100%');
}

@Builder
private SimpleIndicator() {
  ... // 引导层内容
}
```

## 接口说明

**HighLightGuideBuilder**

引导页组件的通用配置项构建类。

**setLabel**

public setLabel(label: string): HighLightGuideBuilder;

为引导页设置label标签，用于保存引导页的已显示次数。

参数：

| 参数名   | 类型     | 必填 | 说明        |
|-------|--------| ---- |-----------|
| label | string | 是   | 引导页的标签名称。 |

返回值：

| 类型   | 说明            |
| ------ |---------------|
| HighLightGuideBuilder | 引导页通用配置项的构建类。 |

**setShowCounts**

public setShowCounts(count: number): HighLightGuideBuilder;

配合引导页label标签，限制引导页组件的显示次数，显示次数需要设置为正整数，alwaysShow为true时失效。

参数

| 参数名 | 类型   | 必填 | 说明               |
| ------ | ------ | ---- | ------------------ |
| count  | number | 是   | 引导页的显示次数。 |

返回值：

| 类型                  | 说明                       |
| --------------------- | -------------------------- |
| HighLightGuideBuilder | 引导页通用配置项的构建类。 |

**alwaysShow**

public alwaysShow(isAlways: boolean): HighLightGuideBuilder;

设置组件是否永久显示，优先级高于setShowCounts方法，设置为true时，setShowCounts方法失效。

| 参数名   | 类型    | 必填 | 说明                 |
| -------- | ------- | ---- | -------------------- |
| isAlways | boolean | 是   | 引导页是否永久显示。 |

返回值：

| 类型                  | 说明                       |
| --------------------- | -------------------------- |
| HighLightGuideBuilder | 引导页通用配置项的构建类。 |

**addGuidePage**

public addGuidePage(page: GuidePage): HighLightGuideBuilder;

为引导页组件添加引导页配置。

| 参数名 | 类型      | 必填 | 说明         |
| ------ | --------- | ---- | ------------ |
| page   | GuidePage | 是   | 引导页配置。 |

返回值：

| 类型                  | 说明                       |
| --------------------- | -------------------------- |
| HighLightGuideBuilder | 引导页通用配置项的构建类。 |

**setOnGuideChangedListener**

public setOnGuideChangedListener(listener: OnGuideChangedListener | null): HighLightGuideBuilder;

为引导页组件添加显示/移除监听。

参数：

| 参数名   | 类型                                 | 必填 | 说明                     |
| -------- |------------------------------------| ---- | ------------------------ |
| listener | OnGuideChangedListener &#124; null | 是   | 引导页的显示状态监听器。 |

**OnGuideChangedListener**

| 方法名    | 参数                  | 说明       |
| --------- | --------------------- | ---------- |
| onShowed  | controller:Controller | 引导页显示 |
| onRemoved | controller:Controller | 引导页移除 |

返回值：

| 类型                  | 说明                       |
| --------------------- | -------------------------- |
| HighLightGuideBuilder | 引导页通用配置项的构建类。 |

**setOnPageChangedListener**

public setOnPageChangedListener(listener: OnPageChangedListener | null): HighLightGuideBuilder;

为引导页组件添加引导页页面切换监听。

参数：

| 参数名   | 类型                                | 必填 | 说明                     |
| -------- |-----------------------------------| ---- | ------------------------ |
| listener | OnPageChangedListener &#124; null | 是   | 引导页的页面切换监听器。 |

**OnPageChangedListener**

| 方法名        | 参数              | 说明                        |
| ------------- | ----------------- | --------------------------- |
| onPageChanged | pageIndex: number | 引导页当前显示的页面index。 |

返回值：

| 类型                  | 说明                       |
| --------------------- | -------------------------- |
| HighLightGuideBuilder | 引导页通用配置项的构建类。 |

**GuidePage**

引导页页面配置项构建类。

**newInstance**

public static newInstance(): GuidePage;

获取引导页的实例。

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLight(componentId: string): GuidePage;

添加高亮组件（componentId需要整个应用内唯一），默认高亮区域为矩形。

参数：

| 参数名      | 类型   | 必填 | 说明               |
| ----------- | ------ | ---- | ------------------ |
| componentId | string | 是   | 高亮组件的唯一id。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLight(componentId: string, shape: HighLightShape): GuidePage;

添加高亮组件（componentId需要整个应用内唯一），支持设置高亮区域形状，默认形状为矩形。

参数：

| 参数名      | 类型           | 必填 | 说明               |
| ----------- | -------------- | ---- | ------------------ |
| componentId | string         | 是   | 高亮组件的唯一id。 |
| shape       | HighLightShape | 是   | 高亮区域的形状。   |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLight(componentId: string, shape: HighLightShape, padding: number): GuidePage;

添加高亮组件（componentId需要整个应用内唯一），支持设置高亮区域形状，默认形状为矩形，支持设置组件padding。

参数：

| 参数名      | 类型           | 必填 | 说明                             |
| ----------- | -------------- | ---- | -------------------------------- |
| componentId | string         | 是   | 高亮组件的唯一id。               |
| shape       | HighLightShape | 是   | 高亮区域的形状。                 |
| padding     | number         | 是   | 高亮区域距离组件实际坐标的边距。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLight(componentId: string, shape: HighLightShape, round: number, padding: number): GuidePage;

添加高亮组件（componentId需要整个应用内唯一），支持设置高亮区域形状，默认形状为矩形，支持设置组件的圆角弧度（仅在shape=HighLightShape.ROUND_RECTANGLE时有效），支持设置组件padding。

参数：

| 参数名      | 类型           | 必填 | 说明                                 |
| ----------- | -------------- | ---- | ------------------------------------ |
| componentId | string         | 是   | 高亮组件的唯一id。                   |
| shape       | HighLightShape | 是   | 高亮区域的形状。                     |
| round       | number         | 是   | 圆角矩形的圆角弧度。                 |
| padding     | number         | 是   | 高亮区域边缘距离组件实际坐标的边距。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLight(rectF: RectF): GuidePage;

添加指定高亮区域，默认高亮区域为矩形。

参数：

| 参数名 | 类型  | 必填 | 说明           |
| ------ | ----- | ---- | -------------- |
| rectF  | RectF | 是   | 指定高亮区域。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLight(rectF: RectF, shape: HighLightShape): GuidePage;

添加指定高亮区域，支持设置高亮区域形状，默认形状为矩形。

| 参数名 | 类型           | 必填 | 说明             |
| ------ | -------------- | ---- | ---------------- |
| rectF  | RectF          | 是   | 指定高亮区域。   |
| shape  | HighLightShape | 是   | 高亮区域的形状。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLight(rectF: RectF, shape: HighLightShape, round: number): GuidePage;

添加指定高亮区域，支持设置高亮区域形状，默认形状为矩形，支持设置组件的圆角弧度（仅在shape=HighLightShape.ROUND_RECTANGLE时有效）。

参数：

| 参数名 | 类型           | 必填 | 说明                 |
| ------ | -------------- | ---- | -------------------- |
| rectF  | RectF          | 是   | 指定高亮区域。       |
| shape  | HighLightShape | 是   | 高亮区域的形状。     |
| round  | number         | 是   | 圆角矩形的圆角弧度。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLightWithOptions**

public addHighLightWithOptions(componentId: string, options: HighLightOptions): GuidePage;

添加高亮组件（componentId需要整个应用内唯一），默认高亮区域为矩形，支持设置高亮区域的额外配置，包括高亮区域的点击事件，重绘高亮图形，每次显示引导页时更新组件的位置。

参数：

| 参数名      | 类型             | 必填 | 说明                 |
| ----------- | ---------------- | ---- | -------------------- |
| componentId | string           | 是   | 高亮组件的唯一id。   |
| options     | HighLightOptions | 是   | 高亮区域的额外配置。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLightWithOptions**

public addHighLightWithOptions(componentId: string, shape: HighLightShape, options: HighLightOptions): GuidePage;

添加高亮组件（componentId需要整个应用内唯一），支持设置高亮区域形状，默认形状为矩形，支持设置高亮区域的额外配置，包括高亮区域的点击事件，重绘高亮图形，每次显示引导页时更新组件的位置。

参数：

| 参数名      | 类型             | 必填 | 说明                 |
| ----------- | ---------------- | ---- | -------------------- |
| componentId | string           | 是   | 高亮组件的唯一id。   |
| shape       | HighLightShape   | 是   | 高亮区域的形状。     |
| options     | HighLightOptions | 是   | 高亮区域的额外配置。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLightWithOptions**

public addHighLightWithOptions(componentId: string, shape: HighLightShape, round: number, padding: number, options: HighLightOptions): GuidePage;

添加高亮组件（componentId需要整个应用内唯一），支持设置高亮区域形状，默认形状为矩形，支持设置组件的圆角弧度（仅在shape=HighLightShape.ROUND_RECTANGLE时有效），支持设置组件padding，支持设置高亮区域的额外配置，包括高亮区域的点击事件，重绘高亮图形，每次显示引导页时更新组件的位置。

参数：

| 参数名      | 类型             | 必填 | 说明                                 |
| ----------- | ---------------- | ---- | ------------------------------------ |
| componentId | string           | 是   | 高亮组件的唯一id。                   |
| shape       | HighLightShape   | 是   | 高亮区域的形状。                     |
| round       | number           | 是   | 圆角矩形的圆角弧度。                 |
| padding     | number           | 是   | 高亮区域边缘距离组件实际坐标的边距。 |
| options     | HighLightOptions | 是   | 高亮区域的额外配置。                 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLightWithOptions(rectF: RectF, options: HighLightOptions): GuidePage;

添加指定高亮区域，默认高亮区域为矩形，支持设置高亮区域的额外配置，包括高亮区域的点击事件，重绘高亮图形，每次显示引导页时更新组件的位置。

参数：

| 参数名  | 类型             | 必填 | 说明                 |
| ------- | ---------------- | ---- | -------------------- |
| rectF   | RectF            | 是   | 指定高亮区域。       |
| options | HighLightOptions | 是   | 高亮区域的额外配置。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLightWithOptions(rectF: RectF, shape: HighLightShape, options: HighLightOptions): GuidePage;

添加指定高亮区域，支持设置高亮区域形状，默认形状为矩形，支持设置高亮区域的额外配置，包括高亮区域的点击事件，重绘高亮图形，每次显示引导页时更新组件的位置。

参数：

| 参数名  | 类型             | 必填 | 说明                 |
| ------- | ---------------- | ---- | -------------------- |
| rectF   | RectF            | 是   | 指定高亮区域。       |
| shape   | HighLightShape   | 是   | 高亮区域的形状。     |
| options | HighLightOptions | 是   | 高亮区域的额外配置。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**addHighLight**

public addHighLightWithOptions(rectF: RectF, shape: HighLightShape, round: number, options: HighLightOptions): GuidePage;

添加指定高亮区域，支持设置高亮区域形状，默认形状为矩形，支持设置组件的圆角弧度（仅在shape=HighLightShape.ROUND_RECTANGLE时有效），支持设置高亮区域的额外配置，包括高亮区域的点击事件，重绘高亮图形，每次显示引导页时更新组件的位置。

参数：

| 参数名  | 类型             | 必填 | 说明                 |
| ------- | ---------------- | ---- | -------------------- |
| rectF   | RectF            | 是   | 指定高亮区域。       |
| shape   | HighLightShape   | 是   | 高亮区域的形状。     |
| round   | number           | 是   | 圆角矩形的圆角弧度。 |
| options | HighLightOptions | 是   | 高亮区域的额外配置。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**setBackgroundColor**

public setBackgroundColor(backgroundColor: string): GuidePage;

为引导页页面添加蒙版背景色，默认颜色为#b2000000。

参数：

| 参数名          | 类型   | 必填 | 说明                 |
| --------------- | ------ | ---- | -------------------- |
| backgroundColor | string | 是   | 引导页的蒙版背景色。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**getBackgroundColor**

public getBackgroundColor(): string;

获取引导页页面的蒙版背景色，默认颜色为#b2000000。

返回值：

| 类型   | 说明                     |
| ------ | ------------------------ |
| string | 引导页页面的蒙版背景色。 |

**setEnterAnimation**

public setEnterAnimation(enterAnimation: AnimatorOptions | null): GuidePage;

为引导页页面添加进入动画，当前仅支持透明度动画。

参数：

| 参数名         | 类型                          | 必填 | 说明                   |
| -------------- |-----------------------------| ---- | ---------------------- |
| enterAnimation | AnimatorOptions &#124; null | 是   | 引导页页面的进入动画。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**getEnterAnimation**

public getEnterAnimation(): AnimatorOptions | null;

获取引导页页面的进入动画。

返回值：

| 类型                          | 说明               |
|-----------------------------| ------------------ |
| AnimatorOptions &#124; null | 引导页的进入动画。 |

**setExitAnimation**

public setExitAnimation(exitAnimation: AnimatorOptions | null): GuidePage;

为引导页页面添加退出动画，当前仅支持透明度动画。

参数：

| 参数名        | 类型                          | 必填 | 说明                   |
| ------------- |-----------------------------| ---- | ---------------------- |
| exitAnimation | AnimatorOptions &#124; null | 是   | 引导页页面的退出动画。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**getExitAnimation**

public getExitAnimation(): AnimatorOptions | null;

获取引导页页面的退出动画。

返回值：

| 类型                          | 说明               |
|-----------------------------| ------------------ |
| AnimatorOptions &#124; null | 引导页的退出动画。 |

**setEverywhereCancelable**

public setEverywhereCancelable(everywhereCancelable: boolean): GuidePage;

是否支持点击引导页任意位置进入下一个引导页，如果没有下一引导页，则移除引导页。

参数：

| 参数名               | 类型    | 必填 | 说明                                         |
| -------------------- | ------- | ---- | -------------------------------------------- |
| everywhereCancelable | boolean | 是   | 是否支持点击引导页任意位置进入下一个引导页。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**isEverywhereCancelable**

public isEverywhereCancelable(): boolean;

获取是否支持点击引导页任意位置进入下一个引导页。

返回值：

| 类型    | 说明                                         |
| ------- | -------------------------------------------- |
| boolean | 是否支持点击引导页任意位置进入下一个引导页。 |

**isEmpty**

public isEmpty(): boolean;

当前引导页组件是否为空，即引导页页数是否为0。

返回值：

| 类型    | 说明                     |
| ------- | ------------------------ |
| boolean | 当前引导页组件是否为空。 |

**getHighLights**

public getHighLights(): HighLight[];

获取引导页高亮区域的属性信息。

返回值：

| 类型        | 说明                       |
| ----------- | -------------------------- |
| HighLight[] | 引导页高亮区域的属性信息。 |

**setHighLightIndicator**

public setHighLightIndicator(indicator: Function | null): GuidePage;

设置引导页的引导层，引导层布局需要为@Builder注解标准的布局函数。

参数：

| 参数名    | 类型                   | 必填 | 说明                         |
| --------- |----------------------| ---- | ---------------------------- |
| indicator | Function &#124; null | 是   | 当前引导页的引导层布局函数。 |

返回值：

| 类型      | 说明                         |
| --------- | ---------------------------- |
| GuidePage | 引导页页面配置项构建类实例。 |

**getHighLightIndicator**

public getHighLightIndicator(): Function | null;

获取引导页的引导层布局，引导层布局需要为@Builder注解标注的布局函数。

返回值：

| 类型                   | 说明                         |
|----------------------| ---------------------------- |
| Function &#124; null | 当前引导页的引导层布局函数。 |

**Controller**

引导页组件的控制器。

**show**

public show(): void;

显示引导页。

**showPage**

public showPage(position: number): void;

显示指定引导页，postion从0开始。

参数：

| 参数名   | 类型   | 必填 | 说明            |
| -------- | ------ | ---- | --------------- |
| position | number | 是   | 引导页的index。 |

**showPreviewPage**

public showPreviewPage(): void;

显示上一引导页。

**remove**

public remove(): void;

移除引导页。

**isShowing**

public isShowing(): boolean;

指示引导页是否正在显示。

返回值：

| 类型    | 说明                     |
| ------- | ------------------------ |
| boolean | 指示引导页是否正在显示。 |

**isAnimationRunning**

public isAnimationRunning(): boolean;

指示引导页是否有动画正在运行。

返回值：

| 类型    | 说明                           |
| ------- | ------------------------------ |
| boolean | 指示引导页是否有动画正在运行。 |

**resetLabel**

public resetLabel(): void;

重置当前引导页的已显示次数为0。

**resetLabel**

public resetLabel(label: string): void;

重置指定标签名称的引导页的已显示次数为0。

参数：

| 参数名 | 类型   | 必填 | 说明         |
| ------ | ------ | ---- | ------------ |
| label  | string | 是   | 引导页标签。 |

**HighLightShape**

高亮区域的形状类型。

| 类型            | 说明     |
| --------------- | -------- |
| CIRCLE          | 圆形     |
| RECTANGLE       | 矩形     |
| OVAL            | 椭圆     |
| ROUND_RECTANGLE | 圆角矩形 |

**RectF**

矩形区域对象。

**构造函数**

 constructor(rect: RectF);

根据指定RectF对象创建

constructor(left: number, top: number, right: number, bottom: number);

根据坐标创建RectF对象。

参数：

| 参数名 | 类型   | 必填 | 说明                    |
| ------ | ------ | ---- | ----------------------- |
| left   | number | 是   | 矩形区域左上角的X坐标。 |
| top    | number | 是   | 矩形区域左上角的Y坐标。 |
| right  | number | 是   | 矩形区域右下角的X坐标。 |
| bottom | number | 是   | 矩形区域右下角的Y坐标。 |

**getCenterX**

public getCenterX(): number;

获取矩形区域的中心点X坐标。

返回值：

| 类型   | 说明                    |
| ------ | ----------------------- |
| number | 矩形区域的中心点X坐标。 |

**getCenterY**

public getCenterY(): number;

获取矩形区域的中心点Y坐标。

返回值：

| 类型   | 说明                    |
| ------ | ----------------------- |
| number | 矩形区域的中心点Y坐标。 |

**getWidth**

public getWidth(): number;

获取矩形区域的宽。

返回值：

| 类型   | 说明           |
| ------ | -------------- |
| number | 矩形区域的宽。 |

**getHeight**

public getHeight(): number;

获取矩形区域的高。

返回值：

| 类型   | 说明           |
| ------ | -------------- |
| number | 矩形区域的高。 |

**HighLightOptionsBuilder**

高亮区域的额外配置构建类。

**setOnClickListener**

public setOnClickListener(listener: OnClickListener | null): HighLightOptionsBuilder;

参数：

| 参数名   | 类型                           | 必填 | 说明                 |
| -------- |------------------------------| ---- | -------------------- |
| listener | OnClickListener &#124; nulll | 是   | 高亮区域的点击事件。 |

**OnClickListener**

| 方法名  | 参数 | 说明                 |
| ------- | ---- | -------------------- |
| onClick | NA   | 高亮区域的点击事件。 |

返回值：

| 类型                    | 说明                           |
| ----------------------- | ------------------------------ |
| HighLightOptionsBuilder | 高亮区域的额外配置构建类实例。 |

**setOnHighLightDrewListener**

public setOnHighLightDrewListener(listener: OnHighLightDrewListener | null): HighLightOptionsBuilder;

参数：

| 参数名   | 类型                                   | 必填 | 说明                     |
| -------- |--------------------------------------| ---- | ------------------------ |
| listener | OnHighLightDrewListener &#124; nulll | 是   | 高亮区域的图形重绘事件。 |

**OnHighLightDrewListener**

| 方法名          | 参数                                                    | 说明                     |
| --------------- | ------------------------------------------------------- | ------------------------ |
| onHighLightDrew | canvasContext2d: CanvasRenderingContext2D, rectF: RectF | 高亮区域的图形重绘事件。 |

返回值：

| 类型                    | 说明                           |
| ----------------------- | ------------------------------ |
| HighLightOptionsBuilder | 高亮区域的额外配置构建类实例。 |

**isFetchLocationEveryTime**

public isFetchLocationEveryTime(isFetchLocation: boolean): HighLightOptionsBuilder;

是否每次显示引导页时更新组件的位置。

参数：

| 参数名          | 类型    | 必填 | 说明                                 |
| --------------- | ------- | ---- | ------------------------------------ |
| isFetchLocation | boolean | 是   | 是否每次显示引导页时更新组件的位置。 |

返回值：

| 类型                    | 说明                           |
| ----------------------- | ------------------------------ |
| HighLightOptionsBuilder | 高亮区域的额外配置构建类实例。 |

**build**

public build(): HighLightOptions ;

构建高亮区域的额外配置。

返回值：

| 类型             | 说明                   |
| ---------------- | ---------------------- |
| HighLightOptions | 高亮区域的额外配置类。 |

**HighLightGuideComponent**

引导页组件。

参数：

| 参数名             | 类型                          | 必填 | 说明                         |
| ------------------ | ----------------------------- | ---- | ---------------------------- |
| highLightContainer | @Builder                      | 是   | 引导页组件的内容布局插槽。   |
| currentHLIndicator | @Builder&#124;null            | 是   | 引导页的引导层布局插槽       |
| builder            | HighLightGuideBuilder         | 是   | 引导页组件的通用配置项构建类 |
| onReady            | (controller:Controller)=>void | 是   | 引导页准备好时的回调函数     |

**<font color='red'>注意点集锦</font>**

1. 组件不支持焦点穿透事件。

2. 组件label需要必传。
3. 每个组件的id要全局（整个应用内）唯一。
4. 每个组件设置的显示次数，应为正整数。
5. RectF矩形区域设置的坐标要基于父组件的坐标，取相对坐标。
6. RectF矩形区域的坐标，左上角的坐标要小于右下角的坐标。
7. 目前仅支持透明度动画。
8. padding参数只对高亮区域为带有id的组件有效。
9. round参数只在shape=HighLightShape.ROUND_RECTANGLE时有效。
10. alwaysShow的优先级高于showCounts。
11. everywhereCancleable的优先级高于额外配置中的点击事件。
12. HighLightDrewListener的优先级高于HighLightShape配置。

## 约束与限制

在下述版本验证通过：
DevEco Studio: 4.1 Canary2(4.1.3.322), SDK: API11 (4.1.0.36)
DevEco Studio: 4.0 Release(4.0.3.413), SDK: API10 (4.0.10.3)

## 目录结构

```
|---- ohos_highlightguide
|     |---- AppScrope  # 工程信息文件夹
|     |---- entry  # 示例代码文件夹
|     |---- library  # 引导页组件
|           |---- src/main  # 模块代码
|                |---- ets/highlightguide   # 模块代码
|                     |---- HighLightGuideComponent.ets # 高亮引导页对外暴漏组件
|                     |---- core # 高亮引导页组件控制器及通用配置构造类 
|                     |---- interface # 引导页组件的高亮区域点击事件监听、显示/移除监听、页面切换监听、高亮区域重绘监听
|                     |---- model # 用于构建高亮引导页组件的数据模型
|                     |---- util # 用于构建高亮引导页组件的坐标处理工具类
|           |---- index.ets          # 入口文件
|           |---- *.json5      # 配置文件
|     |---- README.md  # 安装使用方法
|     |---- README.OpenSource  # 开源说明
|     |---- CHANGELOG.md  # 更新日志
```

## 贡献代码

使用过程中发现任何问题都可以提 [Issue](https://gitee.com/openharmony-sig/ohos_highlightguide/issues) 给我们，当然，我们也非常欢迎你给我们发 [PR](https://gitee.com/openharmony-sig/ohos_highlightguide/pulls) 。

## 开源协议

本项目基于 [Apache-2.0 License](https://gitee.com/openharmony-sig/ohos_highlightguide/blob/master/LICENSE) ，请自由地享受和参与开源。
