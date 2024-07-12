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

@Observed
export default class ObservedMaskVisibleState {
  private globalShowGuideMask: boolean = false;

  /**
   * 设置引导页蒙版显示状态
   * @param show 是否显示引导页蒙版
   */
  setShowGuideMask(show: boolean): void {
    this.globalShowGuideMask = show;
  }

  /**
   * 获取引导页蒙版显示状态
   * @returns 蒙版是否正在显示
   */
  isShowGuideMask() {
    return this.globalShowGuideMask;
  }
}