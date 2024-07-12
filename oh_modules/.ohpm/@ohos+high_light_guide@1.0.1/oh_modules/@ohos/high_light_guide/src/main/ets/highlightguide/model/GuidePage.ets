/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { AnimatorOptions } from '@ohos.animator';
import HighLight from '../interface/HighLight';
import HighLightInfoOfComponent from './HighLightInfoOfComponent';
import HighLightInfoOfRectF from './HighLightInfoOfRectF';
import HighLightOptions from './HighLightOptions';
import { HighLightShape } from './HighLightShape';
import RectF from './RectF';

export default class GuidePage {
  // 是否点击任意位置切换到下一页，如果没有没有下一页，则移除
  private everywhereCancelable: boolean = true;
  // 引导页蒙版背景色
  private backgroundColor: string = '#b2000000';
  // 引导页进入动画
  private enterAnimation: AnimatorOptions | null = null;
  // 引导页退出动画
  private exitAnimation: AnimatorOptions | null = null;
  // 高亮组件/区域集合
  private highLights: HighLight[] = new Array();
  // 高亮指示层
  private highLightIndicator: Function | null = null;

  private constructor() {
  }

  /**
   * 创建引导页实例
   * @returns
   */
  public static newInstance(): GuidePage {
    return new GuidePage();
  }

  /**
   * 添加高亮显示组件，高亮区域形状为矩形
   * @param componentId 组件id(整个应用唯一)
   * @returns 当前引导页
   */
  public addHighLight(componentId: string): GuidePage;

  /**
   * 添加高亮显示组件，可设置高亮区域形状
   * @param componentId 组件id(整个应用唯一)
   * @param shape 高亮区域形状
   * @returns 当前引导页
   */
  public addHighLight(componentId: string, shape: HighLightShape): GuidePage;

  /**
   * 添加高亮显示组件，可设置高亮区域形状
   * @param componentId 组件id(整个应用唯一)
   * @param shape 高亮区域形状
   * @param padding 高亮区域边缘相对于组件实际区域的边距（该属性只针对高亮区域为组件时有效）
   * @returns 当前引导页
   */
  public addHighLight(componentId: string, shape: HighLightShape, padding: number): GuidePage;

  /**
   * 添加高亮显示组件，可设置高亮区域形状
   * @param componentId 组件id(整个应用唯一)
   * @param shape 高亮区域形状
   * @param round 圆角矩形的圆角弧度，只在shape为HighLightShape.ROUND_RECTANGLE时有效
   * @param padding 高亮区域边缘相对于组件实际区域的边距（该属性只针对高亮区域为组件时有效）
   * @returns 当前引导页
   */
  public addHighLight(componentId: string, shape: HighLightShape, round: number, padding: number): GuidePage;

  /**
   * 添加高亮显示区域，高亮区域形状为矩形
   * @param rectF 高亮显示区域：坐标为相对于父组件（__HighLightGuideComponentContainer__ + 创建组件时的时间戳）的相对坐标，单位为vp
   * @returns 当前引导页
   */
  public addHighLight(rectF: RectF): GuidePage;

  /**
   * 添加高亮显示区域，可配置高亮区域形状
   * @param rectF 高亮显示区域：坐标为相对于父组件（__HighLightGuideComponentContainer__ + 创建组件时的时间戳）的相对坐标，单位为vp
   * @param shape 高亮区域形状
   * @returns 当前引导页
   */
  public addHighLight(rectF: RectF, shape: HighLightShape): GuidePage;

  /**
   * 添加高亮显示区域，可配置高亮区域形状
   * @param rectF 高亮显示区域：坐标为相对于父组件（__HighLightGuideComponentContainer__ + 创建组件时的时间戳）的相对坐标，单位为vp
   * @param shape 高亮区域形状
   * @param round 圆角矩形的圆角弧度，只在shape为HighLightShape.ROUND_RECTANGLE时有效
   * @returns 当前引导页
   */
  public addHighLight(rectF: RectF, shape: HighLightShape, round: number): GuidePage;

  /**
   * 添加高亮显示组件/区域
   * @param highLight 组件id/高亮区域
   * @param shape 高亮区域形状
   * @param round 圆角矩形的圆角弧度，只在shape为HighLightShape.ROUND_RECTANGLE时有效
   * @param padding 高亮区域边缘相对于组件实际区域的边距（该属性只针对高亮区域为组件时有效）
   * @returns
   */
  public addHighLight(highLight: string | RectF, shape?: HighLightShape, round?: number, padding?: number): GuidePage {
    let hlShape: HighLightShape = HighLightShape.RECTANGLE;
    let hlRound: number = 0;
    let hlPadding: number = 0;

    if (shape === null || shape === undefined) {
      hlShape = HighLightShape.RECTANGLE;
    } else {
      hlShape = shape;
    }

    if (highLight instanceof RectF) {
      hlRound = round ? round : 0;
    } else {
      if ((round !== null && round !== undefined) && (padding === null || padding === undefined)) {
        hlPadding = round;
        hlRound = 0;
      } else if ((round !== null && round !== undefined) && (padding !== null || padding !== undefined)) {
        hlRound = round;
        hlPadding = padding ? padding : 0;
      } else {
        hlRound = 0;
        hlPadding = 0;
      }
    }

    let highLightInfo: HighLight | null = null;
    if (highLight instanceof RectF) {
      highLightInfo = new HighLightInfoOfRectF(highLight, hlShape, hlRound);
    } else {
      highLightInfo = new HighLightInfoOfComponent(highLight, hlShape, hlRound, hlPadding);
    }
    this.highLights.push(highLightInfo);
    return this;
  }

  /**
   * 添加带有额外参数的高亮组件
   * @param componentId 组件id（整个应用内唯一）
   * @param options 额外参数
   * @returns 当前引导页
   */
  public addHighLightWithOptions(componentId: string, options: HighLightOptions): GuidePage;

  /**
   * 添加带有额外参数的高亮组件
   * @param componentId 组件id（整个应用内唯一）
   * @param shape 高亮区域形状
   * @param options 额外参数
   * @returns 当前引导页
   */
  public addHighLightWithOptions(componentId: string, shape: HighLightShape, options: HighLightOptions): GuidePage;

  /**
   * 添加带有额外参数的高亮组件
   * @param componentId 组件id（整个应用内唯一）
   * @param shape 高亮区域形状
   * @param round 圆角矩形的圆角弧度，只在shape为HighLightShape.ROUND_RECTANGLE时有效
   * @param padding 高亮区域边缘相对于组件实际区域的边距（该属性只针对高亮区域为组件时有效）
   * @param options 额外参数
   * @returns 当前引导页
   */
  public addHighLightWithOptions(componentId: string, shape: HighLightShape, round: number, padding: number, options: HighLightOptions): GuidePage;

  /**
   * 添加带有额外参数的高亮区域
   * @param rectF 高亮区域
   * @param options 额外参数
   * @returns 当前引导页
   */
  public addHighLightWithOptions(rectF: RectF, options: HighLightOptions): GuidePage;

  /**
   * 添加带有额外参数的高亮区域
   * @param rectF 高亮区域
   * @param shape 高亮区域形状
   * @param options 额外参数
   * @returns 当前引导页
   */
  public addHighLightWithOptions(rectF: RectF, shape: HighLightShape, options: HighLightOptions): GuidePage;

  /**
   * 添加带有额外参数的高亮区域
   * @param rectF 高亮区域
   * @param shape 高亮区域形状
   * @param round 圆角矩形的圆角弧度，只在shape为HighLightShape.ROUND_RECTANGLE时有效
   * @param options 额外参数
   * @returns 当前引导页
   */
  public addHighLightWithOptions(rectF: RectF, shape: HighLightShape, round: number, options: HighLightOptions): GuidePage;

  public addHighLightWithOptions(highLight: string | RectF, shape: HighLightShape | HighLightOptions, round?: number | HighLightOptions, padding?: number | HighLightOptions, options?: HighLightOptions): GuidePage {
    let hlShape: HighLightShape = HighLightShape.RECTANGLE;
    let hlRound: number = 0;
    let hlPadding: number = 0;
    let hlOptions = options;
    if (shape === null || shape === undefined) {
      hlShape = HighLightShape.RECTANGLE;
    } else {
      if (shape instanceof HighLightOptions) {
        hlOptions = shape;
      } else {
        hlShape = shape;
      }
    }

    if (!round) {
      hlRound = 0;
    } else {
      if (round instanceof HighLightOptions) {
        hlOptions = round;
      } else {
        hlRound = round;
      }
    }

    if (!padding) {
      hlPadding = 0;
    } else {
      if (padding instanceof HighLightOptions) {
        hlOptions = padding;
      } else {
        hlPadding = padding;
      }
    }

    let highLightInfo: HighLightInfoOfRectF | HighLightInfoOfComponent | null = null;
    ;
    if (highLight instanceof RectF) {
      highLightInfo = new HighLightInfoOfRectF(highLight, hlShape, hlRound);
    } else {
      highLightInfo = new HighLightInfoOfComponent(highLight, hlShape, hlRound, hlPadding);
    }
    if (hlOptions) {
      highLightInfo.setOptions(hlOptions);
    }
    this.highLights.push(highLightInfo);
    return this;
  }

  /**
   * 设置引导页的背景色
   * @param backgroundColor 背景色，默认：#b2000000
   * @returns 当前引导页
   */
  public setBackgroundColor(backgroundColor: string): GuidePage {
    this.backgroundColor = backgroundColor;
    return this;
  }

  /**
   * 获取引导页蒙版背景色
   * @returns 引导页蒙版背景色
   */
  public getBackgroundColor(): string {
    return this.backgroundColor;
  }

  /**
   * 设置引导页进入动画
   * @param enterAnimation 引导页进入动画
   * @returns 当前引导页
   */
  public setEnterAnimation(enterAnimation: AnimatorOptions | null): GuidePage {
    this.enterAnimation = enterAnimation;
    return this;
  }

  /**
   * 获取引导页进入动画
   * @returns 引导页进入动画
   */
  public getEnterAnimation(): AnimatorOptions | null {
    return this.enterAnimation;
  }

  /**
   * 设置引导页退出动画
   * @param exitAnimation 引导页的退出动画
   * @returns 当前引导页
   */
  public setExitAnimation(exitAnimation: AnimatorOptions | null): GuidePage {
    this.exitAnimation = exitAnimation;
    return this;
  }

  /**
   * 获取引导页退出动画
   * @returns 引导页退出动画
   */
  public getExitAnimation(): AnimatorOptions | null {
    return this.exitAnimation;
  }

  /**
   * 设置当前引导页是否支持点击任意位置切换下一页或移除
   * @param everywhereCancelable 是否支持点击任意位置切换下一页或移除
   * @returns 当前引导页
   */
  public setEverywhereCancelable(everywhereCancelable: boolean): GuidePage {
    this.everywhereCancelable = everywhereCancelable;
    return this;
  }

  /**
   * 获取当前引导页是否支持点击任意位置切换下一页或移除
   * @returns 是否支持点击任意位置切换下一页或移除
   */
  public isEverywhereCancelable(): boolean {
    return this.everywhereCancelable;
  }

  /**
   * 获取当前引导页是否有高亮区域
   * @returns 当前引导页是否有高亮区域
   */
  public isEmpty(): boolean {
    return (this.highLights.length === 0);
  }

  /**
   * 获取当前引导页中所有高亮对象
   * @returns 高亮区域对象集合
   */
  public getHighLights(): HighLight[] {
    return this.highLights;
  }

  /**
   * 设置当前引导页的引导层
   * @param indicator 引导层插槽，对应@Builder注解修饰的布局
   * @returns 引导层布局
   */
  public setHighLightIndicator(indicator: Function | null): GuidePage {
    this.highLightIndicator = indicator;
    return this;
  }

  /**
   * 获取当前引导页的引导层
   * @returns 引导层布局
   */
  public getHighLightIndicator(): Function | null {
    return this.highLightIndicator;
  }
}