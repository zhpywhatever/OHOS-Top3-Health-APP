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

import Controller from '../core/Controller';

export default interface OnGuideChangedListener {

  /**
   * 当前引导页组件显示时回调
   * @param controller 引导页组件控制器
   */
  onShowed: (controller: Controller) => void;

  /**
   * 当前引导页组件消失时回调
   * @param controller 引导页组件控制器
   */
  onRemoved: (controller: Controller) => void;
}