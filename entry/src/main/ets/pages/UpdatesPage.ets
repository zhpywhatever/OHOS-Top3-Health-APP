import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message1: string = '当前版本是';
  @State message2: string = '最新版本';

  build() {
    RelativeContainer() {
      Row(){
        Text(this.message1)
          .id('HelloWorld')
          .fontSize(40)
          .fontWeight(FontWeight.Bold)
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .margin({
        top: -200,
        bottom: 80 //这里如果只设置margin-top，会导致后面TextInput组件在竖直方向上的锚点位置在Text组件中心偏上
      })

      Row(){
        Text(this.message2)
          .id('HelloWorld')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })

      Button() {
        SymbolGlyph($r('sys.symbol.arrow_left'))
          .fontWeight(FontWeight.Bold)
          .fontSize(30)
      }
      .type(ButtonType.Capsule)
      .margin({
        top: 20
      })
      .backgroundColor(Color.Transparent)
      .width('20%')
      .height('5%')
      .onClick(() => {
        router.back()
      })
    }
    .height('100%')
    .width('100%')
  }
}