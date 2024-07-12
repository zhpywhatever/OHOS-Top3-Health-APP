import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = '运动健康软件';
  @State dev_message: string = '开发者名单';
  @State dev_names: string = '陈锦源\n' +
    '崔泽仁\n' +
    '董乙灿\n' +
    '吴程辉\n' +
    '杨存远\n' +
    '赵璞琰';

  build() {
    RelativeContainer() {
      Row() {
        Text(this.message)
          .id('HelloWorld')
          .fontSize(50)
          .fontColor('#689D6A')
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
        Text(this.dev_message)
          .id('HelloWorld1')
          .fontSize(30)
          .fontColor(Color.Gray)
          .fontWeight(FontWeight.Bold)
      }
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({
          bottom: 80 //这里如果只设置margin-top，会导致后面TextInput组件在竖直方向上的锚点位置在Text组件中心偏上
        })

      Row(){
        Text(this.dev_names)
          .id('HelloWorld2')
          .fontSize(24)
          .fontColor(Color.Gray)
          .fontWeight(FontWeight.Bold)
      }
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .margin({
          top: 220,
          bottom: 80 //这里如果只设置margin-top，会导致后面TextInput组件在竖直方向上的锚点位置在Text组件中心偏上
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