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
import RectF from '../model/RectF';

export default class ComponentRectFUtil {
  /**
   * 获取组件的矩形区域
   * @param parentId 父组件Id
   * @param componentId 组件Id
   * @returns 组件的矩形区域
   */
  public static getComponentRectF(parentId: string, componentId: string): RectF | null {
    if (!parentId || !componentId) {
      return null;
    }
    let highLightContainerRect = ComponentRectFUtil.componentGlobalRect(parentId);
    if (!highLightContainerRect) {
      return null;
    }
    let componentRect = ComponentRectFUtil.componentGlobalRect(componentId);
    if (!componentRect) {
      return null;
    }
    let childLeft: number, childTop: number, childRight: number, childBottom: number = 0;
    if (componentRect.left > highLightContainerRect.right || componentRect.right < highLightContainerRect.left) {
      childLeft = 0;
      childRight = 0;
    }
    if (componentRect.top > highLightContainerRect.bottom || componentRect.bottom < highLightContainerRect.top) {
      childTop = 0;
      childBottom = 0;
    }

    childLeft = px2vp(componentRect.left - highLightContainerRect.left);
    childRight = px2vp(componentRect.right - highLightContainerRect.left);
    childTop = px2vp(componentRect.top - highLightContainerRect.top);
    childBottom = px2vp(componentRect.bottom - highLightContainerRect.top);
    return new RectF(childLeft, childTop, childRight, childBottom);
  }

  /**
   * 获取组件的相对于屏幕左上角的px坐标
   * @param id 组件id
   * @returns 组件的矩形区域
   */
  public static componentGlobalRect(id: string): RectF | null {
    if (!id) {
      return null;
    }
    let strJson = getInspectorByKey(id);
    if (strJson) {
      let obj: Record<string, Object> = JSON.parse(strJson);
      let componentRectInfo: Record<string, Object> = JSON.parse('[' + obj.$rect + ']');
      let originLeft: number = JSON.parse('[' + componentRectInfo[0] + ']')[0];
      let originTop: number = JSON.parse('[' + componentRectInfo[0] + ']')[1];
      let originRight: number = JSON.parse('[' + componentRectInfo[1] + ']')[0];
      let originBottom: number = JSON.parse('[' + componentRectInfo[1] + ']')[1];
      let globalRectF = new RectF(originLeft, originTop, originRight, originBottom);
      return globalRectF;
    } else {
      return null;
    }
  }

  /**
   * 获取指定点是否在指定区域内
   * @param pointX 指定点的x坐标
   * @param pointY 指定点的y坐标
   * @param rect 指定区域
   * @returns 指定点是否在指定区域内
   */
  public static pointInRectF(pointX: number, pointY: number, rect: RectF): boolean {
    if (pointX == null || pointX == undefined || pointY == null || pointY == undefined || !rect) {
      return false;
    }
    if (!rect.left) {
      rect.left = 0;
    }
    if (!rect.right) {
      rect.right = 0;
    }
    if (!rect.top) {
      rect.top = 0;
    }
    if (!rect.bottom) {
      rect.bottom = 0;
    }
    if (pointX < rect.left || pointX > rect.right) {
      return false;
    }
    if (pointY < rect.top || pointY > rect.bottom) {
      return false;
    }
    if (rect.left >= rect.right || rect.top >= rect.bottom) {
      return false;
    }
    return true;
  }
}
