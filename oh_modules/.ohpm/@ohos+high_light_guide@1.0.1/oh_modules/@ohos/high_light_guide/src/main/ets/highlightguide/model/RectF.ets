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

export default class RectF {
  public left: number = 0;
  public top: number = 0;
  public right: number = 0;
  public bottom: number = 0;

  constructor(rect: RectF);

  constructor(left: number, top: number, right: number, bottom: number);

  constructor(left: number | RectF, top?: number, right?: number, bottom?: number) {
    if (typeof left === 'number') {
      this.check(left, top, right, bottom);
      this.left = left ? left : 0;
      this.top = top ? top : 0;
      this.right = right ? right : 0;
      this.bottom = bottom ? bottom : 0;
    } else if (left instanceof RectF) {
      this.createByRectF(left);
    }
  }

  /**
   * 通过rectF对象创建rectF
   * @param rectF 对象
   * @returns
   */
  private createByRectF(rectF: RectF): RectF {
    this.check(rectF.left, rectF.top, rectF.right, rectF.bottom);
    this.left = rectF.left;
    this.top = rectF.top;
    this.right = rectF.right;
    this.bottom = rectF.bottom;
    return this;
  }

  /**
   * 获取矩形中心点X轴坐标
   * @returns x坐标
   */
  public getCenterX(): number {
    this.check(this.left, this.top, this.right, this.bottom);
    return this.left + (this.right - this.left) / 2;
  }

  /**
   * 获取矩形中心点Y轴坐标
   * @returns Y坐标
   */
  public getCenterY(): number {
    this.check(this.left, this.top, this.right, this.bottom);
    return this.top + (this.bottom - this.top) / 2;
  }

  /**
   * 获取矩形的宽
   * @returns 矩形区域的宽
   */
  public getWidth(): number {
    return this.right - this.left;
  }

  /**
   * 获取矩形的高
   * @returns 矩形区域的高
   */
  public getHeight(): number {
    return this.bottom - this.top;
  }

  /**
   * 检测矩形区域坐标数据的有效性
   * @param left 左上角的X坐标
   * @param top 左上角的Y坐标
   * @param right 右下角的X坐标
   * @param bottom 右下角的Y坐标
   */
  private check(left: number | null | undefined, top: number | null | undefined, right: number | null | undefined, bottom: number | null | undefined): void {
    if (left == null || left == undefined ||
      top == null || top == undefined ||
      right == null || right == undefined ||
      bottom == null || bottom == undefined ||
      right < left || bottom < top) {
      throw new Error('please check the rect params');
    }
  }
}