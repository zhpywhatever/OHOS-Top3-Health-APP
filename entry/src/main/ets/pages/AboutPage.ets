import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = '运动健康软件';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
      Button() {
        SymbolGlyph($r('sys.symbol.arrow_left'))
          .fontWeight(FontWeight.Bold)
          .fontSize(30)
        // Text('返回')
        //   .fontSize(30)
        //   .fontWeight(FontWeight.Bold)
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