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
import Animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import hilog from '@ohos.hilog';
import Controller from './core/Controller';
import HighLightGuideBuilder from './core/HighLightGuideBuilder';
import HighLight from './interface/HighLight';
import OnClickListener from './interface/OnClickListener';
import OnHighLightDrewListener from './interface/OnHighLightDrewListener';
import GuidePage from './model/GuidePage';
import HighLightOptions from './model/HighLightOptions';
import HighLightOptionsBuilder from './model/HighLightOptionsBuilder';
import { HighLightShape } from './model/HighLightShape';
import ObservedMaskVisibleState from './model/ObservedMaskVisibleState';
import ObservedPageIndex from './model/ObservedPageIndex';
import RectF from './model/RectF';
import ComponentRectFUtil from './util/ComponentRectFUtil';
import { GlobalContext } from './util/GlobalContext';

@Component
export struct HighLightGuideComponent {
  // 限制引导页组件的蒙版覆盖的UI组件，同时根据该组件限制引导页组件的size
  @BuilderParam highLightContainer: Function;
  // 每个引导页中的引导层布局，可不设置
  @BuilderParam currentHLIndicator?: Function | null;
  // 引导页的通用配置类，需要非空
  builder: HighLightGuideBuilder | null = null;
  // 通知应用引导页组件即将显示到UI布局上，通知用户获取引导页布局的Controller控制器
  onReady: (controller: Controller) => void = (controller: Controller) => {
  };
  /* ----------------------------------------------------------------------------------------------------------------- */
  // 引导页组件动画的预制参数：当前仅支持透明度
  @State private canvasOp: number = 1;
  // 引导页绘制相关
  private renderingSetting: RenderingContextSettings = new RenderingContextSettings(true);
  private context2d: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSetting);
  // 引导页组件的控制器
  private controller: Controller | null = null;
  // 指示Canvas画布是否准备好
  private canvasAlready: boolean = false;
  // 组件进入及退出动画
  private enterAnimationResult: AnimatorResult | null = null;
  private exitAnimationResult: AnimatorResult | null = null;
  // 时间戳，用于构成引导页组件根布局的全局唯一id
  private timestampForId: number = new Date().getTime();
  // 显示引导页的次数，用于切换更新引导页的引导层布局
  @State private showIndicatorCount: number = -1;
  // 是否显示蒙版引导层
  @State private isShowGuideMask: boolean = false;
  // 监听mask变化
  @Watch('maskVisibleStateChange') @State
  private maskVisibleStateConfig: ObservedMaskVisibleState | null = null;

  maskVisibleStateChange(): void {

    // 退出动画正在执行，不能直接控制蒙版层消失，需要等动画完成
    if (this.exitAnimationResult !== null) {
      return;
    }
    if (this.controller) {
      let observedStateObj: ObservedMaskVisibleState | null = this.controller._getObservedMaskVisibleState();
      if (observedStateObj) {
        let newMaskVisibleState = observedStateObj.isShowGuideMask();
        hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'change component mask visible state, current: ' + this.isShowGuideMask + " changeTo: " + newMaskVisibleState);

        // 更新UI，控制蒙版组件是否显示/移除
        this.isShowGuideMask = newMaskVisibleState;
      }
    }
  }

  @State private currentPageIndex: number = -1;
  @Watch('pageIndexChange') @State
  private pageIndexConfig: ObservedPageIndex | null = null;

  pageIndexChange(): void {
    if (!this.controller || !this.builder) {
      return;
    }
    if (this.enterAnimationResult !== null || this.exitAnimationResult !== null) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'change component page index, animation is running, return.');
      return;
    }

    let isShowMask: boolean = false;
    let observedSateObj: ObservedMaskVisibleState | null = this.controller._getObservedMaskVisibleState();
    if (observedSateObj) {
      isShowMask = observedSateObj.isShowGuideMask();
    }

    let newPageIndex: number = -1;
    let observedPageIndexObj: ObservedPageIndex | null = this.controller._getObservedPageIndex();
    if (observedPageIndexObj) {
      newPageIndex = observedPageIndexObj.getCurrentPageIndex();
    }
    let currentPageIndex = this.currentPageIndex;
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'change component page index, currentIndex: ' + currentPageIndex + " newIndex: " + newPageIndex +
      " mask visible state: " + isShowMask);

    // 首次显示引导页，动画在Canvas的onReady回调完成
    if (!this.canvasAlready || currentPageIndex == -1) {
      this.currentPageIndex = newPageIndex;
      this.currentPage = this.builder.guidePages[newPageIndex];
      return;
    }

    // 引导页退出动画及引导页透明度设置
    this.guidePageAnimation(isShowMask, newPageIndex);
  }

  /**
   * 引导页退出动画及透明度设置
   * @param isShowMask 是否显示引导页蒙版
   * @param newPageIndex 引导页页数
   */
  private guidePageAnimation(isShowMask: boolean, newPageIndex: number): void {
    if (this.currentPage && this.currentPage.getExitAnimation() && isShowMask) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'change component page index, current page has animation, should be play.');
      if (this.controller) {
        this.controller._onAnimationRunning(true);
      }
      this.exitAnimationResult = Animator.create(this.currentPage.getExitAnimation());
      this.exitAnimationResult.onframe = (value) => {
        this.canvasOp = value;
      }
      this.exitAnimationResult.onfinish = () => {
        if (this.controller) {
          this.controller._onAnimationRunning(false);
        }

        // newPageIndex为-1，表示移除引导页蒙版了，可以不用管透明度
        if (newPageIndex === -1) {
          this.exitAnimationResult = null;
          this.isShowGuideMask = false;
          return;
        }
        if (!this.builder) {
          return;
        }
        if (newPageIndex < this.builder.guidePages.length) {
          let nextPage = this.builder.guidePages[newPageIndex];
          let nextPageAnimation: AnimatorOptions | null = nextPage.getEnterAnimation();
          if (nextPageAnimation) {
            if (this.canvasOp != nextPageAnimation.begin) {
              this.canvasOp = nextPageAnimation.begin;
            }
          } else {
            this.canvasOp = 1;
          }
        } else {
          if (this.currentPage && !this.currentPage.getExitAnimation()) {
            let firstPageAnimation: AnimatorOptions | null = this.builder.guidePages[0].getEnterAnimation();
            if (firstPageAnimation) {
              this.canvasOp = firstPageAnimation.begin;
            }
          }
        }

        this.currentPageIndex = newPageIndex;
        this.currentPage = this.builder.guidePages[newPageIndex];
        this.exitAnimationResult = null;
      }
      this.exitAnimationResult.play();
    } else {

      // 没有动画时的透明度设置
      this.pageWithoutAnimation(newPageIndex);
    }
  }

  /**
   * 没有动画时的透明度设置
   * @param newPageIndex 即将显示的引导的index
   */
  private pageWithoutAnimation(newPageIndex: number): void {
    if (!this.builder) {
      return;
    }
    if (newPageIndex !== -1 && newPageIndex < this.builder.guidePages.length) {
      let nextPage = this.builder.guidePages[newPageIndex];
      let nextPageAnimation: AnimatorOptions | null = nextPage.getEnterAnimation();
      if (nextPageAnimation) {
        if (newPageIndex !== 0) {
          this.canvasOp = nextPageAnimation.begin;
        }
      } else {
        this.canvasOp = 1;
      }
      this.currentPageIndex = newPageIndex;
      this.currentPage = this.builder.guidePages[this.currentPageIndex];
    } else {

      // 最后一个引导页没有退出动画，就需要将参数保持为第一个页面额状态一样，否则会发生闪烁
      if (this.currentPage && !this.currentPage.getExitAnimation()) {
        let exitAnimation: AnimatorOptions | null = this.currentPage.getExitAnimation();
        if (!exitAnimation) {
          let firstPageAnimation: AnimatorOptions | null = this.builder.guidePages[0].getEnterAnimation();
          if (firstPageAnimation) {
            this.canvasOp = firstPageAnimation.begin;
          }
        }
      } else if (!this.currentPage) {
        this.canvasOp = 0;
      }
    }
  }

  @Watch('changeCurrentMask') @State
  private currentPage: GuidePage | null = null;

  changeCurrentMask(): void {

    // 引导页显示次数的计数变量
    this.showIndicatorCount = this.showIndicatorCount + 1;
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'change component mask and high light, current page index: ' + this.currentPageIndex);
    if (this.currentPageIndex == -1 || !this.builder || this.currentPageIndex >= this.builder.guidePages.length) {
      return;
    }

    // 更新引导页的引导层
    this.currentHLIndicator = this.builder.guidePages[this.currentPageIndex].getHighLightIndicator();

    if (this.canvasAlready && this.isShowGuideMask && this.controller && this.controller.isShowing()) {

      if (!this.currentPage) {
        return;
      }

      // 开始绘制蒙版及高亮显示区域
      this.drawMask(this.context2d, this.currentPage);

      if (this.currentPage && this.currentPage.getEnterAnimation()) {
        hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'change component mask and high light, play enter animation.');
        this.controller._onAnimationRunning(true);
        this.enterAnimationResult = Animator.create(this.currentPage.getEnterAnimation());
        this.enterAnimationResult.onframe = (value) => {
          this.canvasOp = value;
        }
        this.enterAnimationResult.onfinish = () => {
          hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'change component mask and high light, enter animation finished.');
          this.enterAnimationResult = null;
          if (this.controller) {
            this.controller._onAnimationRunning(false);
          }
        }
        this.enterAnimationResult.play();
      }
    }
  }

  aboutToAppear() {
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component will appear: aboutToAppear.');

    // 创建builder，保证组件不崩溃，但是没办法控制引导页组件
    if (!this.builder) {
      this.builder = new HighLightGuideBuilder();
    }

    // 创建引导页的Controller控制器
    this.controller = new Controller(getContext(this), this.builder);

    // 为应用提供Controller控制类
    this.onReady(this.controller);

    // 实例监听Controller控制类的pageIndex，new Controller()会触发一次 pageIndexChange()方法；
    this.pageIndexConfig = this.controller._getObservedPageIndex();

    // 实例监听Controller控制类的mask可见状态，new Controller()会触发一次 maskVisibleStateChange()方法；
    this.maskVisibleStateConfig = this.controller._getObservedMaskVisibleState();

    // 更新默认的引导层显示状态
    if (this.maskVisibleStateConfig) {
      this.isShowGuideMask = this.maskVisibleStateConfig.isShowGuideMask();
    }
  }

  aboutToDisappear() {
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'The component will appear: aboutToDisAppear.');

    // 清空数据，不能在此回调中更新@State修饰的数据
    this.builder = null;
    this.currentPageIndex = -1;
    this.controller = null;
    this.guideMaskDisAppear();
  }

  build() {
    Column() {
      Stack() {

        // 基础容器布局
        Column() {
          if (this.highLightContainer) {
            this.highLightContainer();
          }
        }.id('__HighLightGuideComponentContainer__' + this.timestampForId)
        .width('100%')
        .height('100%')

        // 蒙版布局
        if (this.isShowGuideMask) {
          Stack({ alignContent: Alignment.TopStart }) {
            Canvas(this.context2d)
              .onReady(() => {
                this.canvasAlready = true;

                // 绘制第一个引导页
                this.drawMask(this.context2d, this.currentPage);

                this.firstPageAnimation();
              })
              .width('100%')
              .height('100%')

            Column() {
              if (this.showIndicatorCount % 2 === 0) {
                if (this.currentHLIndicator) {
                  this.currentHLIndicator();
                }
              } else {
                if (this.currentHLIndicator) {
                  this.currentHLIndicator();
                }
              }
            }
          }
          .width('100%')
          .height('100%')
          .opacity(this.canvasOp)
          .onClick((event: ClickEvent | undefined) => {
            hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'mask component: click container.');
            if (event) {
              this.guideMaskClick(event);
            }
          })
          .onAppear(() => {
            hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'mask component: onAppear.');
            if (this.builder && this.builder.guidePages[0] && this.builder.guidePages[0].getEnterAnimation()) {
              let guideEnterAnimation: AnimatorOptions | null = this.builder.guidePages[0].getEnterAnimation();
              if (guideEnterAnimation) {
                this.canvasOp = guideEnterAnimation.begin; // 透明度需要与进入动画初始值同步
              }
            } else {
              this.canvasOp = 1; // 设置组件的透明度为1，用于退出时有渐出动画，再次进入时没有渐进动画导致的蒙版不显示
            }
          })
          .onDisAppear(() => {
            hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'mask component: onDisAppear.');
            if (this.controller) {
              this.controller._onGuideDisAppear();
            }
            this.guideMaskDisAppear();
          })
        }
      }.width('100%')
    }.height('100%')
  }

  /**
   * 第一个页面的进入动画
   */
  private firstPageAnimation(): void {
    if (this.currentPage && this.currentPage.getEnterAnimation() && this.exitAnimationResult === null) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', "canvas onReady, play first page's enter animation.");
      if (this.controller) {
        this.controller._onAnimationRunning(true);
      }
      this.enterAnimationResult = Animator.create(this.currentPage.getEnterAnimation());
      this.enterAnimationResult.onframe = (value) => {
        this.canvasOp = value;
      }
      this.enterAnimationResult.onfinish = () => {
        hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', "canvas onReady, play first page's enter animation finished.");
        if (this.controller) {
          this.controller._onAnimationRunning(false);
          this.controller._onGuideAppear();
        }
        this.enterAnimationResult = null;
      }
      this.enterAnimationResult.play();
    } else {
      if (this.controller) {
        this.controller._onGuideAppear();
      }
    }
  }

  /**
   * 高亮区域/蒙版的点击事件
   */
  private guideMaskClick(event: ClickEvent): void {
    if (this.enterAnimationResult !== null) {
      return;
    }
    if (this.exitAnimationResult !== null) {
      this.exitAnimationResult.cancel();
      this.exitAnimationResult.play();
      return;
    }
    if (this.currentPage && this.controller && this.builder && this.currentPage.isEverywhereCancelable()) {

      // 设置了点击任意位置可展示下一引导页/移除引导页，优先识别此事件
      if (this.currentPageIndex + 1 >= this.builder.guidePages.length) {
        this.controller.remove();
      } else {
        this.controller.showPage(this.currentPageIndex + 1);
      }
      return;
    }

    // 高亮区域的点击事件
    if (this.currentPage) {
      this.highLightEvent(this.currentPage, true, event);
    }
  }

  /**
   * 组件蒙版移除
   */
  private guideMaskDisAppear(): void {
    this.canvasAlready = false;
    this.currentHLIndicator = null;
    if (this.exitAnimationResult) {
      this.exitAnimationResult.cancel();
      this.exitAnimationResult = null;
    }
    if (this.enterAnimationResult) {
      this.enterAnimationResult.cancel();
      this.enterAnimationResult = null;
    }
  }

  /**
   * 高亮区域的事件：包含点击事件，绘制高亮区域
   * @param guidePage 当前引导页
   * @param isClickEvent 是否为点击事件触发
   * @param event 点击事件
   * @param context2d 绘制上下文
   */
  private highLightEvent(guidePage: GuidePage, isClickEvent: boolean, event?: ClickEvent | null, context2d?: CanvasRenderingContext2D): void {
    if (!guidePage) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'high light event: The guide page is empty, please remove.');
      return;
    }
    let highLightInfoArray = guidePage.getHighLights();
    for (let i = 0; i < highLightInfoArray.length; i++) {
      let highLightInfo = highLightInfoArray[i];
      if (!highLightInfo) {
        hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'high light event: The guide page does not have high light component.');
        continue;
      }
      let highLightRect: RectF | null = null;
      let highLightType: string | boolean = highLightInfo.isComponentHighLight();
      if (typeof highLightType === 'string') {
        highLightRect = highLightInfo.getRectF('__HighLightGuideComponentContainer__' + this.timestampForId, highLightType);
      } else {
        highLightRect = highLightInfo.getRectF();
      }
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'high light event: The high light component vp coordinates: ' + JSON.stringify(highLightRect));
      if (!highLightRect) {
        continue;
      }
      if (isClickEvent && event) {
        let isPointInHighLight = ComponentRectFUtil.pointInRectF(event.x, event.y, highLightRect);
        if (isPointInHighLight) {
          let highLightOptions: HighLightOptions | null = highLightInfo.getOptions();
          if (highLightOptions) {
            let clickListener: OnClickListener | null = highLightOptions.onClickListener;
            if (clickListener) {
              clickListener.onClick();
            }
          }
        }
      } else {
        if (context2d) {

          // 如果设置了重绘图形，优先使用重绘的图形，不会绘制默认的高亮图形
          let highLightOptions: HighLightOptions | null = highLightInfo.getOptions();
          if (highLightOptions) {
            let redrawListener: OnHighLightDrewListener | null = highLightOptions.onHighLightDrewListener;
            if (redrawListener) {
              redrawListener.onHighLightDrew(context2d, highLightRect);
            } else {
              this.drawShape(context2d, highLightInfo, highLightRect);
            }
          } else {

            // 绘制内置高亮区域图形
            this.drawShape(context2d, highLightInfo, highLightRect);
          }
        }
      }
    }
  }

  /**
   * 绘制蒙版
   * @param context2d 画布操作上下文
   * @param pageInfo 当前引导页信息
   */
  private drawMask(context2d: CanvasRenderingContext2D, pageInfo: GuidePage | null): void {
    if (!pageInfo || !this.canvasAlready) {
      hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'canvas draw mask return, guide info is null or canvas not ready.');
      return;
    }
    context2d.clearRect(0, 0, context2d.width, context2d.height);
    let maskColor = pageInfo.getBackgroundColor();
    if (!maskColor) {
      maskColor = '#b2000000'
    }

    // 绘制全屏蒙版
    context2d.fillStyle = maskColor;
    context2d.fillRect(0, 0, context2d.width, context2d.height);
    context2d.globalCompositeOperation = "destination-out";
    context2d.fillStyle = '#ff0000'

    // 高亮区域的绘制高亮图形事件
    this.highLightEvent(pageInfo, false, null, context2d);

    // 还原混合模式：叠加绘制
    context2d.globalCompositeOperation = "source-over";
  }

  /**
   * 按形状绘制高亮显示区域
   * @param context2d 画布操作上下文
   * @param highLightInfo 高亮组件的信息
   * @param highLightRect 高亮组件的矩形区域
   */
  private drawShape(context2d: CanvasRenderingContext2D, highLightInfo: HighLight, highLightRect: RectF): void {
    switch (highLightInfo.getShape()) {

    // 圆形高亮
      case HighLightShape.CIRCLE:
        context2d.beginPath();
        context2d.moveTo(highLightRect.getCenterX(), highLightRect.getCenterY());
        let radius = highLightInfo.getRadius('__HighLightGuideComponentContainer__' + this.timestampForId);
        context2d.arc(highLightRect.getCenterX(), highLightRect.getCenterY(), radius, 0, 360, false);
        context2d.closePath();
        context2d.fill();
        break;

    // 椭圆高亮
      case HighLightShape.OVAL:
        context2d.beginPath();
        context2d.moveTo(highLightRect.getCenterX(), highLightRect.getCenterY());
        context2d.ellipse(highLightRect.getCenterX(), highLightRect.getCenterY(), highLightRect.getWidth() / 2, highLightRect.getHeight() / 2, 0, Math.PI * 0, Math.PI * 2, false);
        context2d.closePath();
        context2d.fill();
        break;

    // 圆角矩形
      case HighLightShape.ROUND_RECTANGLE:
        let round = highLightInfo.getRound();
        let minLength = Math.min(highLightRect.getWidth(), highLightRect.getHeight());
        if (round > minLength / 2) {
          round = minLength / 2;
        }
        if (round < 0) {
          round = 0;
        }
        context2d.beginPath();
        context2d.moveTo(highLightRect.left + round, highLightRect.top);
        context2d.lineTo(highLightRect.right - round, highLightRect.top);
        context2d.arc(highLightRect.right - round, highLightRect.top + round, round, 3 / 2 * Math.PI, 0);
        context2d.lineTo(highLightRect.right, highLightRect.bottom - round);
        context2d.arc(highLightRect.right - round, highLightRect.bottom - round, round, 0, Math.PI / 2);
        context2d.lineTo(highLightRect.left + round, highLightRect.bottom);
        context2d.arc(highLightRect.left + round, highLightRect.bottom - round, round, Math.PI / 2, Math.PI);
        context2d.lineTo(highLightRect.left, highLightRect.top + round);
        context2d.arc(highLightRect.left + round, highLightRect.top + round, round, Math.PI, 3 / 2 * Math.PI);
        context2d.closePath();
        context2d.fill();
        break;

    // 矩形高亮
      case HighLightShape.RECTANGLE:
      default:
        context2d.fillRect(highLightRect.left, highLightRect.top, highLightRect.getWidth(), highLightRect.getHeight());
        break
    }
    hilog.info(0x0000, GlobalContext.HILOG_TAG, '%{public}s', 'canvas draw shape end.');
  }
}