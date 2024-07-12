/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
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
import { RenderingState } from '../../danmaku/renderer/IRenderer';
import { IDanmakuView, OnDanmakuClickListener, THREAD_TYPE_NORMAL_PRIORITY }from '../../controller/IDanmakuView'
import { IDanmakuViewController } from '../../controller/IDanmakuViewController'
import { DrawHandler, Callback, START } from '../../controller/DrawHandler'
import { Message } from '../../../../../compat/Handler'
import { IDanmakus } from '../../danmaku/model/IDanmakus'
import { BaseDanmaku } from '../../danmaku/model/BaseDanmaku'
import { BaseDanmakuParser } from '../../danmaku/parser/BaseDanmakuParser'
import { DanmakuContext } from '../../danmaku/model/ohos/DanmakuContext'
import SystemClock from '../../danmaku/util/SystemClock'
import { DrawHelper } from '../../controller/DrawHelper'
import { DanmakuTouchHelper } from './DanmakuTouchHelper'

const MAX_RECORD_SIZE: number = 50;
const ONE_SECOND: number = 1000;

@Component
struct DanmakuView {
  @State
  refreshGeneration: number = 0
  @Link
  model: DanmakuView.Model
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  ready: boolean = false
  @State @Watch('onRelayout')
  viewWidth: number= 1920
  @State @Watch('onRelayout')
  viewHeight: number= 1080

  build() {
    Stack() {
      Canvas(this.context)
        .onReady(() => {
          this.ready = true
        }).width('100%').height('100%').backgroundColor(Color.Transparent)
    }.width(this.model.getViewWidth() + "px")
    .height(this.model.getViewHeight() + "px")
    .visibility(this.mDanmakuVisible ? Visibility.Visible : Visibility.Hidden)
    .onTouch((event: TouchEvent): void => this.onTouchEvent(event))
  }

  invalidate() {
    this.refreshGeneration = (this.refreshGeneration + 1) % 65536;
    this.onDraw(this.context)
  }

  postInvalidate() {
    setTimeout(() => {
      this.invalidate()
    }, 0)
  }

  aboutToAppear() {
    this.model.delegate = this;
    this.init()
  }

  private mCallback: Callback|ESObject;
  protected handler: DrawHandler|ESObject;
  private mOnDanmakuClickListener: OnDanmakuClickListener|ESObject;
  private mXOff: number = 0;
  private mYOff: number = 0;
  private mTouchHelper: DanmakuTouchHelper|ESObject;
  private mShowFps: boolean = false;
  public mDanmakuVisible: boolean = true;
  protected mDrawingThreadType: number = THREAD_TYPE_NORMAL_PRIORITY;
  protected mRequestRender: boolean = false;

  private init(): void {
    DrawHelper.useDrawColorToClearCanvas(true, false);
    this.mTouchHelper = DanmakuTouchHelper.instance(this.model);
  }

  /**
   * danmaku.isLive == true的情况下,请在非UI线程中使用此方法,避免可能卡住主线程
   *
   * @param item
   */

  public addDanmaku(item: BaseDanmaku): void { // from IDanmakuView
    if (this.handler != null) {
      this.handler.addDanmaku(item);
    }
  }

  public invalidateDanmaku(item: BaseDanmaku, remeasure: boolean): void { // from IDanmakuView
    if (this.handler != null) {
      this.handler.invalidateDanmaku(item, remeasure);
    }
  }

  public removeAllDanmakus(isClearDanmakusOnScreen: boolean): void { // from IDanmakuView
    if (this.handler != null) {
      this.handler.removeAllDanmakus(isClearDanmakusOnScreen);
    }
  }

  public removeAllLiveDanmakus(): void { // from IDanmakuView
    if (this.handler != null) {
      this.handler.removeAllLiveDanmakus();
    }
  }

  public getCurrentVisibleDanmakus(): IDanmakus|null { // from IDanmakuView
    if (this.handler != null) {
      return this.handler.getCurrentVisibleDanmakus();
    }
    return null;
  }

  public setCallback(callback: Callback): void { // from IDanmakuView
    this.mCallback = callback;
    if (this.handler != null) {
      this.handler.setCallback(callback);
    }
  }

  public release(): void { // from IDanmakuView 播放控制
    this.stop();
    if (this.mDrawTimes != null) {
      this.mDrawTimes.length = 0
    }
    ;
  }

  public stop(): void { // from IDanmakuView 播放控制
    this.stopDraw();
  }

  private stopDraw(): void {
    if (this.handler == null) {
      return;
    }
    let handler: DrawHandler = this.handler;
    this.handler = null;
    if (this.handler != null) {
      this.handler.quit();
    }
  }

  private prepareInner(): void {
    if (this.handler == null) {
      this.handler = new DrawHandler(this.model, this.mDanmakuVisible);
    }
  }

  public prepare(parser: BaseDanmakuParser, config: DanmakuContext): void { // from IDanmakuView 播放控制
    this.prepareInner();
    this.handler.setConfig(config);
    this.handler.setParser(parser);
    this.handler.setCallback(this.mCallback);
    this.handler.prepare();
  }

  public isPrepared(): boolean { // from IDanmakuView
    return this.handler != null && this.handler.isPrepared();
  }

  public getConfig(): DanmakuContext|null { // from IDanmakuView
    if (this.handler == null) {
      return null;
    }
    return this.handler.getConfig();
  }

  public showFPS(show: boolean): void { // from IDanmakuView
    this.mShowFps = show;
  }

  private mDrawTimes: number[]|ESObject;
  protected mClearFlag: boolean = false;

  private fps(): number {
    let lastTime: number = SystemClock.uptimeMillis();
    this.mDrawTimes.push(lastTime);
    let first: number = this.mDrawTimes[0];
    if (first === undefined) {
      return 0.0;
    }
    let dtime: number = lastTime - first;
    let frames: number = this.mDrawTimes.length;
    if (frames > MAX_RECORD_SIZE) {
      this.mDrawTimes.shift();
    }
    return dtime > 0 ? this.mDrawTimes.length * ONE_SECOND / dtime : 0.0;
  }

  public drawDanmakus(): number { // from IDanmakuViewController
    if (!this.isShown())
    return -1;
    let stime: number = SystemClock.uptimeMillis();
    this.lockCanvas();
    return SystemClock.uptimeMillis() - stime;
  }

  private postInvalidateCompat(): void {
    this.mRequestRender = true;
    this.postInvalidate();
  }

  protected lockCanvas(): void {
    if (this.mDanmakuVisible == false) {
      return;
    }
    this.postInvalidateCompat();
  }

  protected onDraw(canvas: CanvasRenderingContext2D): number {
    if (!this.ready) {
      return 0
    }
    if ((!this.mDanmakuVisible) && (!this.mRequestRender)) {
      return 0;
    }
    DrawHelper.clearCanvas(canvas)
    if (this.mClearFlag) {
      DrawHelper.clearCanvas(canvas);
      this.mClearFlag = false;
    } else {
      if (this.handler != null) {
        let rs: RenderingState = this.handler.draw(canvas);
        if (this.mShowFps) {
          if (this.mDrawTimes == null)
          this.mDrawTimes = new Array<number>();
          let fps: string =
            "fps " + this.fps().toFixed(2) + ",time:" + Math.floor(this.getCurrentTime() / 1000)
          DrawHelper.drawFPS(canvas, fps);
        }
      }
    }
    this.mRequestRender = false;
    return 0
  }

  protected onRelayout(): void {
    if (this.handler != null) {
      this.handler.notifyDispSizeChanged(this.viewWidth, this.viewHeight);
    }
  }

  public toggle(): void { // from IDanmakuView 播放控制
    if (this.handler == null) {
      this.start();
    }

    else if (this.handler.isStop()) {
      this.resume();
    } else {
      this.pause();
    }
  }

  public pause(): void { // from IDanmakuView 播放控制
    if (this.handler != null) {
      this.handler.removeCallbacks(this.mResumeRunnable);
      this.handler.pause();
    }
  }

  private mResumeTryCount: number = 0;
  private mResumeRunnable = () => {
    let drawHandler: DrawHandler = this.handler;
    if (drawHandler == null) {
      return;
    }
    this.mResumeTryCount++;
    if (this.mResumeTryCount > 4 /*|| DanmakuView.super.isShown()*/
    ) {
      drawHandler.resume();
    } else {
      drawHandler.postDelayed(this.mResumeRunnable, 100 * this.mResumeTryCount);
    }
  };

  public resume(): void { // from IDanmakuView 播放控制
    if (this.handler != null && this.handler.isPrepared()) {
      this.mResumeTryCount = 0;
      this.handler.post(this.mResumeRunnable);
    } else if (this.handler == null) {
      this.restart();
    }
  }

  public isPaused(): boolean { // from IDanmakuView
    if (this.handler != null) {
      return this.handler.isStop();
    }
    return false;
  }

  public restart(): void {
    this.stop();
    this.start();
  }

  public start(position: number = 0): void { // from IDanmakuView 播放控制
    let handlerLocal: DrawHandler = this.handler;
    if (handlerLocal == null) {
      this.prepareInner();
      handlerLocal = this.handler;
    } else {
      handlerLocal.removeCallbacksAndMessages();
    }
    if (handlerLocal != null) {
      handlerLocal.sendMessage(new Message({ what: START, obj: position }))
    }
  }

  public onTouchEvent(event: TouchEvent): void {
    this.mTouchHelper.onTouchEvent(event);
  }

  public seekTo(ms: number): void { // from IDanmakuView 播放控制
    if (this.handler != null) {
      this.handler.seekTo(ms);
    }
  }

  public isViewReady(): boolean { // from IDanmakuViewController
    return this.ready;
  }

  public show(): void{ // from IDanmakuView 播放控制
    this.showAndResumeDrawTask(null);
  }

  /**
   * show the danmakuview again if you called hideAndPauseDrawTask()
   *
   * @param position The position you want to resume
   * @see #hideAndPauseDrawTask
   */

  public showAndResumeDrawTask(position: number|ESObject): void { // from IDanmakuView 播放控制
    this.mDanmakuVisible = true;
    this.mClearFlag = false;
    if (this.handler == null) {
      return;
    }
    this.handler.showDanmakus(position);
  }

  public hide(): void { // from IDanmakuView 播放控制
    this.mDanmakuVisible = false;
    if (this.handler == null) {
      return;
    }
    this.handler.hideDanmakus(false);
  }

  /**
   * hide the danmakuview and pause the drawtask
   *
   * @return the paused position
   * @see #showAndResumeDrawTask
   */

  public hideAndPauseDrawTask(): number { // from IDanmakuView 播放控制
    this.mDanmakuVisible = false;
    if (this.handler == null) {
      return 0;
    }
    return this.handler.hideDanmakus(true);
  }

  public clear(): void { // from IDanmakuViewController
    if (!this.isViewReady()) {
      return;
    }
    this.mClearFlag = true;
    this.postInvalidateCompat();
  }

  public isShown(): boolean { // from IDanmakuView View方法
    return this.mDanmakuVisible
  }

  /**
   * @param type One of THREAD_TYPE_MAIN_THREAD, THREAD_TYPE_HIGH_PRIORITY, THREAD_TYPE_NORMAL_PRIORITY, or THREAD_TYPE_LOW_PRIORITY.
   */

  public setDrawingThreadType(threadType: number): void { // from IDanmakuView
    this.mDrawingThreadType = threadType;
  }

  /**
   * for getting the accurate play-time. use this method instead of parser.getTimer().currMillisecond
   *
   * @return
   */

  public getCurrentTime(): number { // from IDanmakuView
    if (this.handler != null) {
      return this.handler.getCurrentTime();
    }
    return 0;
  }

  public clearDanmakusOnScreen(): void {
    if (this.handler != null) {
      this.handler.clearDanmakusOnScreen();
    }
  }

  public setOnDanmakuClickListener(listener: OnDanmakuClickListener, xOff: number, yOff: number): void { // from IDanmakuView Click Listener
    this.mOnDanmakuClickListener = listener;
    if (xOff !== undefined) {
      this.mXOff = xOff;
    }
    if (yOff !== undefined) {
      this.mYOff = yOff;
    }
  }

  public getOnDanmakuClickListener(): OnDanmakuClickListener { // from IDanmakuView Click Listener
    return this.mOnDanmakuClickListener;
  }

  public getXOff(): number { // from IDanmakuView Click Listener
    return this.mXOff;
  }

  public getYOff(): number { // from IDanmakuView Click Listener
    return this.mYOff;
  }

  public forceRender(): void { // from IDanmakuView Click Listener
    this.mRequestRender = true;
    this.handler.forceRender();
  }
}

namespace DanmakuView {
  export class Model implements IDanmakuView, IDanmakuViewController {
    delegate: DanmakuView|ESObject

    isPrepared(): boolean{
      return this.delegate.isPrepared()
    }

    isPaused(): boolean{
      return this.delegate.isPaused()
    }
    /**
     *
     * @param type One of THREAD_TYPE_MAIN_THREAD, THREAD_TYPE_HIGH_PRIORITY, THREAD_TYPE_NORMAL_PRIORITY, or THREAD_TYPE_LOW_PRIORITY.
     */
    setDrawingThreadType(threadType: number): void{
      this.delegate.setDrawingThreadType(threadType)
    }

    showFPS(show: boolean): void{
      this.delegate.showFPS(show)
    }

    /**
     * danmaku.isLive == true的情况下,请在非UI线程中使用此方法,避免可能卡住主线程
     * @param item
     */
    addDanmaku(item: BaseDanmaku): void{
      this.delegate.addDanmaku(item)
    }

    invalidateDanmaku(item: BaseDanmaku, remeasure: boolean): void{
      this.delegate.invalidateDanmaku(item, remeasure)
    }

    removeAllDanmakus(isClearDanmakusOnScreen: boolean): void{
      this.delegate.removeAllDanmakus(isClearDanmakusOnScreen)
    }

    removeAllLiveDanmakus(): void{
      this.delegate.removeAllLiveDanmakus()
    }

    getCurrentVisibleDanmakus(): IDanmakus{
      return this.delegate.getCurrentVisibleDanmakus()
    }

    setCallback(callback: Callback|ESObject): void{
      this.delegate.setCallback(callback)
    }

    /**
     * for getting the accurate play-time. use this method instead of parser.getTimer().currMillisecond
     * @return
     */
    getCurrentTime(): number{
      return this.delegate.getCurrentTime()
    }

    getConfig(): DanmakuContext{
      return this.delegate.getConfig()
    }

    // ------------- View方法  --------------------
    getView(): IDanmakuView{
      return this
    }

    setWidth(width: number) {
      this.delegate.viewWidth = width
    }

    setHeight(height: number) {
      this.delegate.viewHeight = height
    }

    getWidth(): number {
      return this.delegate.viewWidth
    }

    getHeight(): number {
      return this.delegate.viewHeight
    }

    setVisibility(visibility: boolean): void {
      this.delegate.mDanmakuVisible = visibility
    }

    isShown(): boolean{
      return this.delegate.isShown()
    }

    // ------------- 播放控制 -------------------

    prepare(parser: BaseDanmakuParser, config: DanmakuContext): void{
      this.delegate.prepare(parser, config)
    }

    seekTo(ms: number): void{
      this.delegate.seekTo(ms)
    }

    start(position?: number): void{
      this.delegate.start(position)
    }

    stop(): void{
      this.delegate.stop()
    }

    pause(): void{
      this.delegate.pause()
    }

    resume(): void{
      this.delegate.resume()
    }

    release(): void{
      this.delegate.release()
    }

    toggle(): void{
      this.delegate.toggle()
    }

    show(): void{
      this.delegate.show()
    }

    hide(): void{
      this.delegate.hide()
    }

    /**
     * show the danmakuview again if you called hideAndPauseDrawTask()
     * @param position The position you want to resume
     * @see #hideAndPauseDrawTask
     */
    showAndResumeDrawTask(position: number): void{
      this.delegate.showAndResumeDrawTask(position)
    }

    /**
     * hide the danmakuview and pause the drawtask
     * @return the paused position
     * @see #showAndResumeDrawTask
     */
    hideAndPauseDrawTask(): number{
      return this.delegate.hideAndPauseDrawTask()
    }

    clearDanmakusOnScreen(): void{
      this.delegate.clearDanmakusOnScreen()
    }

    // ------------- Click Listener -------------------


    setOnDanmakuClickListener(listener: OnDanmakuClickListener|ESObject, xOff?: number, yOff?: number): void {
      this.delegate.setOnDanmakuClickListener(listener, xOff, yOff);
    }

    getOnDanmakuClickListener(): OnDanmakuClickListener {
      return this.delegate.getOnDanmakuClickListener()
    }

    getXOff(): number{
      return this.delegate.getXOff();
    }

    getYOff(): number{
      return this.delegate.getYOff();
    }

    forceRender(): void{
      this.delegate.forceRender()
    }

    isViewReady(): boolean{
      return this.delegate.isViewReady();
    }

    getViewWidth(): number{
      return this.getWidth();
    };

    getViewHeight(): number{
      return this.getHeight();
    };

    drawDanmakus(): number{
      return this.delegate?.drawDanmakus()
    };

    clear(): void{
      this.delegate?.clear()
    };
  }
}

export default DanmakuView