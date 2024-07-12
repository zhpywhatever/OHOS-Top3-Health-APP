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
import ComponentRectFUtil from '../util/ComponentRectFUtil';
import HighLight from '../interface/HighLight';
import HighLightOptions from './HighLightOptions';
import { HighLightShape } from './HighLightShape';
import RectF from './RectF';

export default class HighLightInfoOfComponent implements HighLight {
  private rectF: RectF | null = null;
  private componentId: string = '';
  private shape: HighLightShape = HighLightShape.RECTANGLE;
  private round: number = 0;
  private padding: number = 0;
  private options: HighLightOptions | null = null;

  constructor(componentId: string, shape: HighLightShape, round?: number, padding?: number) {
    this.componentId = componentId;
    this.shape = shape;
    this.round = round ? round : 0;
    this.padding = padding ? padding : 0;
  }

  /**
   * 设置高亮区域的额外配置
   * @param options 额外配置
   */
  public setOptions(options: HighLightOptions): void {
    this.options = options;
  }

  /**
   * 获取高亮区域的额外配置
   */
  getOptions(): HighLightOptions | null {
    return this.options;
  }

  /**
   * 获取圆角矩形的圆角弧度，仅当shape = HighLightShape.ROUND_RECTANGLE 时调用此方法
   * @returns 圆角矩形的圆角弧度
   */
  getRound(): number {
    return this.round;
  }

  /**
   * 获取圆形的半径，仅当shape = HighLightShape.CIRCLE时调用此方法获取半径
   * @param parentId 父布局id： __HighLightGuideComponentContainer__ + 组件创建时的时间戳，id需要整个应用内唯一
   * @returns 返回圆的半径
   */
  getRadius(parentId?: string): number {
    if (!parentId || !this.componentId) {
      return 0;
    }

    let rect = ComponentRectFUtil.getComponentRectF(parentId, this.componentId);
    if (!rect) {
      return 0;
    }
    return Math.max(rect.getWidth() / 2, rect.getHeight() / 2) + this.padding;
  }

  /**
   * 获取高亮图形的区域坐标，组件要求必传id,rectF区域需要为相对于父组件的相对坐标，坐标值需要转换为vp,不能直接为px
   * @param parentId 高亮区域为组件时，必传，父组件id:__HighLightGuideComponentContainer__ + 组件创建时的时间戳，id需要整个应用内唯一
   * @param componentId 高亮区域为组件时，必传，组件id需要整个应用内唯一
   * @returns 返回高亮区域的坐标，单位为vp
   */
  getRectF(parentId?: string, componentId?: string): RectF | null {
    if (!parentId || !componentId) {
      return null;
    }
    if (this.rectF == null || this.rectF == undefined) {
      this.rectF = this.fetchLocation(parentId, componentId);
    } else if (this.options && this.options.fetchLocationEveryTime) {
      this.rectF = this.fetchLocation(parentId, componentId);
    }
    return this.rectF;
  }

  /**
   * 更新组件坐标
   * @param parentId 父布局id
   * @param componentId 组件id
   * @returns 高亮区域的坐标
   */
  private fetchLocation(parentId: string, componentId: string): RectF | null {
    let originLocation = ComponentRectFUtil.getComponentRectF(parentId, componentId);
    if (!originLocation) {
      return null;
    }

    let left = originLocation.left - this.padding;
    let top = originLocation.top - this.padding;
    let right = originLocation.right + this.padding;
    let bottom = originLocation.bottom + this.padding;
    return new RectF(left, top, right, bottom);
  }

  /**
   * 获取高亮区域的图形类型
   */
  getShape() {
    return this.shape;
  }

  /**
   * 高亮区域的类型
   * @returns 返回组件id 即高亮区域为组件类型，否则为指定的高亮区域
   */
  isComponentHighLight(): string | boolean {
    return this.componentId;
  }
}