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

import HighLightOptions from '../model/HighLightOptions'
import RectF from '../model/RectF'
import { HighLightShape } from '../model/HighLightShape'

export default interface HighLight {

  /**
   * 获取高亮区域的类型
   * @returns 高亮区域的类型：组件id或指定区域
   */
  isComponentHighLight(): boolean | string;

  /**
   * 获取图形shape类型
   * @returns shape类型
   */
  getShape(): HighLightShape;

  /**
   * 获取高亮图形的区域坐标，组件要求必传id,rectF区域需要为相对于父组件的相对坐标，坐标值需要转换为vp,不能直接为px
   * @param parentId 高亮区域为组件时，必传，父组件id:__HighLightGuideComponentContainer__ + 组件创建时的时间戳，id需要整个应用内唯一
   * @param componentId 高亮区域为组件时，必传，组件id需要整个应用内唯一
   * @returns 返回高亮区域的坐标，单位为vp
   */
  getRectF(parentId?: string, componentId?: string): RectF | null;

  /**
   * 当shape为为CIRCLE时调用此方法获取半径
   * @param parentId 高亮区域为组件时，必传，父组件id: __HighLightGuideComponentContainer__ + 组件创建时的时间戳，id需要整个应用内唯一
   * @returns 圆的半径
   */
  getRadius(parentId?: string): number;

  /**
   * 获取圆角弧度，仅当shape = HighLightShape.ROUND_RECTANGLE才调用此方法
   * @returns 圆角矩形的圆角弧度
   */
  getRound(): number;

  /**
   * 获取高亮区域的额外参数，可设置高亮区域的点击事件，重绘高亮区域的图形，是否强制更新组件坐标（该属性用于高亮区域为组件id时有效）
   * @returns 高亮区域的额外配置
   */
  getOptions(): HighLightOptions | null;
}