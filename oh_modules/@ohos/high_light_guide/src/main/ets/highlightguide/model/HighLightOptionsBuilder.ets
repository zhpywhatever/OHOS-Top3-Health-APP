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
import OnClickListener from '../interface/OnClickListener';
import OnHighLightDrewListener from '../interface/OnHighLightDrewListener';
import HighLightOptions from './HighLightOptions';

export default class HighLightOptionsBuilder {
  private options: HighLightOptions;

  constructor() {
    this.options = new HighLightOptions();
  }

  /**
   * 高亮点击事件
   * @param listener 点击事件回调
   * @returns 额外配置构建类
   */
  public setOnClickListener(listener: OnClickListener | null): HighLightOptionsBuilder {
    this.options.onClickListener = listener;
    return this;
  }

  /**
   * 为高亮区域添加重绘监听
   * @param listener 重绘高亮区域图形的firstIndicator监听
   * @returns 额外配置构建类
   */
  public setOnHighLightDrewListener(listener: OnHighLightDrewListener | null): HighLightOptionsBuilder {
    this.options.onHighLightDrewListener = listener;
    return this;
  }

  /**
   * 是否每次显示引导页都重新获取组件坐标
   * @param isFetchLocation 是否每次显示引导页都重新获取组件坐标
   * @returns 额外配置构建类
   */
  public isFetchLocationEveryTime(isFetchLocation: boolean): HighLightOptionsBuilder {
    this.options.fetchLocationEveryTime = isFetchLocation;
    return this;
  }

  /**
   * 获取高亮区域的额外配置项
   * @returns
   */
  public build(): HighLightOptions {
    return this.options;
  }
}