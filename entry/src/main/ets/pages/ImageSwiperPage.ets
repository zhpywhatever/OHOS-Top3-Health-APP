import router from '@ohos.router';

@Entry
@Component
struct SwiperPage {
  @State images: ResourceStr[] = []
  @State index: number = 0

  aboutToAppear() {
    let params: object = router.getParams()
    this.images = params["images"]
    this.index = params["index"]
  }

  build() {
    Column() {
      Swiper() {
        ForEach(this.images, (item: ResourceStr) => {
          Image(item)
            .width("100%")
            .objectFit(ImageFit.Auto)
        })
      }
      .height("100%")
      .index(this.index)
      .indicatorStyle({
        color: '#ffffff'
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Black)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      // 点击返回至上一页面
      router.back()
    })
  }
}

