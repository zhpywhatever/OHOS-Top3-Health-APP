import router from '@ohos.router';
import { CommonConstants as Const } from '../common/constants/CommonConstants';

class MomentClass {
  public nickName: string; //昵称
  public content: string; //内容
  public images: ResourceStr[]; //内容图片列表

  constructor(nickName: string, content: string, images: ResourceStr[]) {
    this.nickName = nickName;
    this.content = content;
    this.images = images;
  }
}


@Entry
@Component
export struct MomentsIndex {
  @State momentList: MomentClass[] = [
    new MomentClass('Timo', 'Seeing much, suffering much, and studying much, are the three pillars of learning.', []),
    new MomentClass('Pill', '今日打卡', [$r("app.media.1")]),
    new MomentClass('锤子', '打卡打卡打卡打卡打卡打卡打卡打卡打卡打卡', [$r("app.media.1"), $r("app.media.2")]),
  ];


  //计算列数
  calcColumnsTemplate(index:number) {
    let result: string = '1fr'
    let length: number = this.momentList[index].images.length || 0
    if (length == 1) {
      result = '1fr'
    } else if (length == 2 || length == 4) {
      result = '1fr 1fr'
    } else {
      result = '1fr 1fr 1fr'
    }
    return result
  }

  //计算行数
  calcRowsTemplate(index:number) {
    let result: string = '1fr'
    let length: number = this.momentList[index].images.length || 0
    if (length == 1) {
      result = '1fr'
    } else if (length >= 2 && length <= 6 && length != 3) {
      result = '1fr 1fr'
    } else {
      result = '1fr 1fr 1fr'
    }
    return result
  }

  //计算宽度
  calcGridWidth(index:number) {
    let result: number = 0
    let length: number = this.momentList[index].images.length || 0
    if (length == 1) {
      result = 70
    } else if (length == 2 || length == 4) {
      result = 145
    } else {
      result = 220
    }
    return result
  }

  //计算高度
  calcGridHeight(index:number) {
    let result: number = 0
    let length: number = this.momentList[index].images.length || 0
    if (length <= 3) {
      result = 70
    } else if (length > 3 && length <= 6) {
      result = 145
    } else {
      result = 220
    }
    return result
  }

  build() {
    Column() {
      List({ space: 20 }) {
        ListItem() {
          Stack({ alignContent: Alignment.BottomEnd }) {
            Column() {
              Image($r("app.media.ic_moments_bg"))
                .width('100%')
                .height(276)
                .objectFit(ImageFit.Cover)
            }
            .width('100%')
            .height(300)

            Row({ space: 10 }) {
              Text(Const.NICK_NAME)
                .fontSize(20)
                .fontColor(0xffffff)
                .margin({ bottom: 10 })
              Image($r("app.media.ic_user"))
                .width(80)
                .height(80)
                .borderRadius(8)
                .objectFit(ImageFit.Cover)
            }
            .height(80)
            .justifyContent(FlexAlign.End)
            .padding(14)
          }
          .width('100%')
          .height(300)
        }

        ForEach(this.momentList, (item: MomentClass, index: number) => {
          ListItem() {
            Row({ space: 10 }) {
              Image($r("app.media.ic_user"))
                .width(50)
                .height(50)
                .borderRadius(6)
                .objectFit(ImageFit.Cover)

              Column({ space: 10 }) {
                Text(`${item.nickName} - ${index}图`)
                  .fontSize(16)
                  .fontColor('#409EFF')
                Text(item.content)
                  .fontSize(16)
                  .lineHeight(22)
                if (item.images && item.images.length > 0) {
                  Grid() {
                    ForEach(item.images, (img: ResourceStr, index: number) => {
                      GridItem() {
                        Image(img)
                          .height(70)
                          .width(70)
                          .objectFit(ImageFit.Cover)
                          .borderRadius(2)
                          .onClick(() => {
                            router.pushUrl({
                              url: "pages/SwiperPage",
                              params: {
                                images: item.images,
                                index: index
                              }
                            })
                          })
                      }
                    })
                  }
                  .columnsTemplate(this.calcColumnsTemplate(index))
                  .rowsTemplate(this.calcRowsTemplate(index))
                  .columnsGap(5)
                  .rowsGap(5)
                  .width(this.calcGridWidth(index))
                  .height(this.calcGridHeight(index))
                }
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Start)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .width('100%')
          .padding(10)
        })

      }
      .divider({ strokeWidth: 1 })
      .width('100%')
    }
    .width('100%')
    .height(('100%'))
  }
}
