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
import hilog from '@ohos.hilog';
import preferences from '@ohos.data.preferences';
import HighLightGuideBuilder from './HighLightGuideBuilder';
import OnGuideLifeCycleListener from '../interface/OnGuideLifeCycleListener';
import ObservedMaskVisibleState from '../model/ObservedMaskVisibleState';
import ObservedPageIndex from '../model/ObservedPageIndex';
import { GlobalContext } from '../util/GlobalContext';
import { BusinessError } from '@ohos.base';

export default class Controller implements OnGuideLifeCycleListener {
  // 通知组件是否显示Mask蒙层
  private observedMaskVisibleState: ObservedMaskVisibleState | null = null;
  // 通知组件切换引导页
  private observedPageIndex: ObservedPageIndex | null = null;
  // 组件构造设置的参数
  private builder: HighLightGuideBuilder | null = null;
  // 用于指示组件Mask蒙版是否显示，结合isGuideAppear,两者皆为true时，表示组件在显示
  private isGuideShowing: boolean = false;
  // 用于指示组件是否加载完成
  private isGuideAppear = false;
  // 用于指示当前是否有动画显示
  private animationRunning = false;
  // 当前引导页页数
  private guidePageIndex = 0;
  // 用于存储引导页显示次数
  private preferences: preferences.Preferences | null = null;

  /**
   * Controller构造类
   * @param context 用于存储显示次数的上下文
   * @param guideBuilder 组件初始化配置
   */
  constructor(context: Context, guideBuilder: HighLightGuideBuilder) {
    this.observedMaskVisibleState = new ObservedMaskVisibleState();
    this.observedPageIndex = new ObservedPageIndex();
    this.builder = guideBuilder;
    this.createPreferences(context);
  }

  /**
   * 私有方法，不建议用户使用：用于组件通知Controller控制器当前动画状态
   * @param isAnimationRunning 动画状态：正在播放/播放完成
   */
  _onAnimationRunning(isAnimationRunning: boolean): void {
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Animation running state: ' + isAnimationRunning)
    this.animationRunning = isAnimationRunning;
  }

  /**
   * 私有方法，不建议用户使用：用于组件通知Controller控制器当前组件是否加载完成
   */
  _onGuideAppear(): void {
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Component mask and indicator: aboutToAppear');
    this.isGuideShowing = true;
    this.isGuideAppear = true;
  }

  /**
   * 私有方法，不建议用户使用：用于组件通知Controller控制器当前组件是否移除
   */
  _onGuideDisAppear(): void {
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Component mask and indicator: aboutToDisAppear');
    this.isGuideShowing = false;
    this.isGuideAppear = false;
  }

  /**
   * 私有方法，不建议用户使用：用于Controller控制器通知组件是否隐藏mask蒙版
   * @returns mask蒙版状态
   */
  public _getObservedMaskVisibleState(): ObservedMaskVisibleState | null {
    return this.observedMaskVisibleState;
  }

  /**
   * 私有方法，不建议用户使用：用于Controller控制器通知组件页面index切换
   * @returns 页面index
   */
  public _getObservedPageIndex(): ObservedPageIndex | null {
    return this.observedPageIndex;
  }

  /**
   * 开始显示引导页
   */
  public show(): void {

    // 组件名称必须设置，如果没有设置，则不显示组件引导页
    if (!this.builder || !this.builder.label) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'label is empty, please set the label for guide');
      return;
    }

    // 获取组件已经显示过的次数
    let showedCount = 0;
    if (this.preferences) {
      let savedShowedCount: number = this.preferences.getSync(this.builder.label, 0) as number;
      if (typeof savedShowedCount === 'number') {
        showedCount = savedShowedCount;
      }
    }

    // 显示次数控制只在不是永久显示的情况下有效
    if (!this.builder.alwaysShowGuide && showedCount >= this.builder.showCounts) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component has been displayed ' + showedCount + ' times.');
      return;
    }

    // 如果组件已显示，不支持再次显示蒙版
    if (this.isGuideAppear) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component is already appear, can not show again.');
      return;
    }

    if (!this.builder || !this.builder.guidePages || this.builder.guidePages.length === 0) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'There is no guide to show !! Please add at least one page.');
      return;
    }

    if (this.observedMaskVisibleState) {
      this.observedMaskVisibleState.setShowGuideMask(true);
    }

    this.isGuideShowing = true;
    this.guidePageIndex = 0;
    this.showGuidePage();

    if (this.builder && this.builder.visibleStateChangeListener) {
      this.builder.visibleStateChangeListener.onShowed(this);
    }
    if (typeof showedCount === 'number' && !this.builder.alwaysShowGuide) {
      this.savePreferencesData(this.builder.label, (showedCount + 1));
    }
  }

  /**
   * 设置要显示的引导页页数
   * @param position 引导页的index，index 从0开始
   */
  public showPage(position: number): void {
    if (!this.isShowing()) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component is not showing.');
      return;
    }
    if (this.animationRunning) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component animation is running, please wait a minute.');
      return;
    }
    if (position < 0) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The guide page position is out of range. current: ' +
        position + ', range: [ 0, ' + (this.builder!.guidePages!.length - 1) + ' ]');
      return;
    }
    if (this.builder && position > this.builder.guidePages.length - 1) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The guide page position is out of range. current: ' +
        position + ', range: [ 0, ' + (this.builder!.guidePages!.length - 1) + ' ]');
      this.guidePageIndex = position;
      this.remove();
      return;
    }
    if (this.guidePageIndex === position) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The guide page position is same to current. current: ' + position);
      return;
    }
    this.guidePageIndex = position;
    this.showGuidePage();
  }

  /**
   * 显示上一个引导页
   */
  public showPreviewPage(): void {
    if (this.animationRunning) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component animation is running, please wait a minute.');
      return;
    }
    this.showPage(this.guidePageIndex - 1);
  }

  /**
   * 移除引导页蒙版显示
   */
  public remove(): void {
    if (!this.isShowing()) {
      return;
    }
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component should be remove.');
    this.isGuideShowing = false;
    this.guidePageIndex = 0;
    if (this.observedPageIndex) {
      this.observedPageIndex.setCurrentPageIndex(-1);
    }

    if (this.observedMaskVisibleState) {
      this.observedMaskVisibleState.setShowGuideMask(false);
    }

    if (this.builder && this.builder.visibleStateChangeListener) {
      this.builder.visibleStateChangeListener.onRemoved(this);
    }
  }

  /**
   * 判断当前引导页是否正在显示
   * @returns 引导页蒙版层是否正在显示
   */
  public isShowing(): boolean {
    return this.isGuideAppear && this.isGuideShowing;
  }

  /**
   * 当前组件是否有动画运行，如果有，则不支持控制引导页
   * @returns 当前组件是否有动画在运行
   */
  public isAnimationRunning(): boolean {
    return this.animationRunning
  }

  /**
   * 重置组件标签，即重置组件显示次数为0
   */
  public resetLabel(): void;

  /**
   * 重置组件标签，即重置组件显示次数为0
   * @param 组件标签
   */
  public resetLabel(label: string): void;

  /**
   * 重置组件标签，即重置组件显示次数为0
   * @param 组件标签
   */
  public resetLabel(label?: string): void {
    if (!label) {
      if (this.builder) {
        label = this.builder.label;
      } else {
        label = '';
      }
    }
    this.savePreferencesData(label, 0);
  }

  /**
   * 显示组件对应的引导页
   */
  private showGuidePage(): void {
    if (this.observedPageIndex) {
      this.observedPageIndex.setCurrentPageIndex(this.guidePageIndex);
    }

    if (this.builder && this.builder.pageChangedListener) {
      this.builder.pageChangedListener.onPageChanged(this.guidePageIndex);
    }
    this.isGuideShowing = true;
  }

  /**
   * 创建存储显示次数的实例
   * @param context 上下文
   */
  private createPreferences(context: Context): void {
    try {
      preferences.getPreferences(context, 'HighLightGuide')
        .then((object) => {
          this.preferences = object;
          hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Succeeded in getting preference');
        })
        .catch((err: BusinessError) => {
          err = err as BusinessError;
          hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Failed to get preferences. catch error code = ' + err.code + ' , message = ' + err.message);
        })
    } catch (err) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Failed to get preferences. catch error code = ' + err.code + ' , message = ' + err.message);
    }
  }

  /**
   * 更新并保存已显示的引导页次数
   * @param label 引导页组件的标签名称
   * @param count 已显示的组件次数
   */
  private savePreferencesData(label: string, count: number): void {
    if (!this.preferences) {
      return;
    }
    try {
      this.preferences.putSync(label, count)
      this.preferences.flush()
        .then(() => {
          hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Succeeded in flushing.');
        })
        .catch((err: BusinessError) => {
          err = err as BusinessError;
          hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Failed to flush. catch error code = ' + err.code + ' , message = ' + err.message);
        })
    } catch (err) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'Failed to flush. catch error code = ' + err.code + ' , message = ' + err.message);
    }
  }
}