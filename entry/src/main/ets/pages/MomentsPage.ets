import router from '@ohos.router';
import { CommonConstants as Const } from '../common/constants/CommonConstants';
import AddBtn from '../view/home/AddBtnComponent';
import App from '@system.app';

class MomentClass {
  public nickName: string; //昵称
  public head : ResourceStr;
  public content: string; //内容
  public showC: boolean;
  public images: ResourceStr[]; //内容图片列表

  constructor(nickName: string, head:ResourceStr, content: string, showC: boolean, images: ResourceStr[]) {
    this.nickName = nickName;
    this.head = head;
    this.content = content;
    this.showC = showC;
    this.images = images;
  }
}

const verbs = ['喜欢', '我正在', '今天完成了', '开始了', '准备'];
const objects = ['早起', '喝水', '吃苹果', '微笑', '刷牙', '早睡', '吃早饭'];

const images = [$r("app.media.1"), $r("app.media.2"), $r("app.media.3"), $r("app.media.4")];

// 随机选择一个数组中的元素
function getRandomElement(arr: string[]): string {
  return arr[Math.floor(Math.random() * arr.length)];
}

function getRandomElement2(arr: Resource[]): Resource {
  return arr[Math.floor(Math.random() * arr.length)];
}

// 生成随机文案的函数
function generateRandomText(): string {
  const verb = getRandomElement(verbs);
  const object = getRandomElement(objects);

  // 生成随机文案
  const sentence = `${verb}${object}。`;
  return sentence;
}

// 生成随机数组b的函数
function generateRandomImages(): ResourceStr[] {
  // 生成0到9的随机长度
  const length = Math.floor(Math.random() * 10);

  // 生成随机数组b
  const randomArray: Resource[] = [];
  for (let i = 0; i < length; i++) {
    randomArray.push(getRandomElement2(images));
  }

  return randomArray;
}


@Entry
@Component
export struct MomentsIndex {
  @State momentList: MomentClass[] = [
    new MomentClass('Timo', $r("app.media.ic_head_3"),'Seeing much, suffering much, and studying much, are the three pillars of learning.', false,[]),
    new MomentClass('Pill', $r("app.media.ic_head_2"),'今日打卡', false, [$r("app.media.1")]),
    new MomentClass('锤子', $r("app.media.ic_head_1"), '打卡打卡打卡打卡打卡打卡打卡打卡打卡打卡', false, [$r("app.media.1"), $r("app.media.2")])
  ];
  @State showC: boolean[] = [
    false, false, false
  ]
  @StorageLink('LAST_LOGIN') LAST_LOGIN: string = "";


  //计算列数
  calcColumnsTemplate(index:number) {
    console.log(`index =  ${index}, len = ${this.momentList.length}`)
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

  onPageShow() {
    this.checkLoginStatus();
  }

  async checkLoginStatus() {
    try {
      if (!this.LAST_LOGIN) {
        await router.pushUrl({ url: 'pages/MinePage' });
      }
    } catch (error) {
      console.error('检查登录状态时出错:', error);
    }
  }

  getLoginStatus() : boolean {
    return AppStorage.get('LOGIN_FLAG') ?? false;
  }

  build() {
    Stack() {
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
              Text(this.LAST_LOGIN)
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
              Image(item.head)
                .width(50)
                .height(50)
                .borderRadius(6)
                .objectFit(ImageFit.Cover)

              Column({ space: 10 }) {
                Text(`${item.nickName}`)
                  .fontSize(16)
                  .fontColor('#409EFF')
                Text(item.content)
                  .fontSize(16)
                  .lineHeight(22)
                if (index<this.momentList.length && item.images && item.images.length > 0) {
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
                              url: "pages/ImageSwiperPage",
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
                Stack({alignContent:Alignment.End}) {
                  Flex({
                    direction: FlexDirection.Row,
                    justifyContent: FlexAlign.SpaceBetween,
                    alignItems: ItemAlign.Center
                  }) {
                    Text('刚刚')
                      .fontColor("#ffb9b9b9")
                      .fontSize(13)
                    Text('••')
                      .width(35)
                      .height(18)
                      .borderRadius(5)
                      .fontSize(12)
                      .fontWeight(900)
                      .textAlign(TextAlign.Center)
                      .fontColor("#ff5a6d96")
                      .backgroundColor("#fff7f7f7")
                      .onClick(()=> {
                        this.showC[index] = !(this.showC[index]);
                        if(!this.showC[index]){
                          return;
                        }
                        let i:number;
                        for(i = 0; i<this.showC.length;i++){
                          console.info(`momentlist ${i}: ${this.momentList[i].showC}`);
                          if(i!=index){
                            this.showC[i] = false;
                          }
                        }
                      })
                  }
                  Text('删除')
                    .margin({right:"46vp"})
                    .fontColor(this.showC[index]?"#ffffffff":"#00ffffff")
                    .backgroundColor("#ffff0000")
                    .textAlign(TextAlign.Center)
                    .width(this.showC[index]?48:0)
                    .height(28)
                    .borderRadius(3)
                    .onClick(()=>{
                      this.momentList.splice(index, 1);
                      this.showC.splice(index, 1);
                    })
                    .animation({
                      duration: 350,
                      curve: Curve.EaseOut,
                      iterations: 1,
                      playMode: PlayMode.Normal
                    })
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
      .backgroundColor("#ffffffff")
      .scrollBar(BarState.Off)

      AddBtn({
        clickAction: () => {
          console.info(`click add moments, len = ${this.momentList.length}`);
          // this.momentList.splice(0, 1);
          if(Math.random()<0.2){
            this.momentList.splice(0, 0, new MomentClass('Me', $r("app.media.ic_user"), "今天参加了HarmonyOS菁英班", false, [$r("app.media.team_members_1"), $r("app.media.team_members_2")]));
          }
          else{
            this.momentList.splice(0, 0, new MomentClass('Me', $r("app.media.ic_user"), generateRandomText(), false, generateRandomImages()));
          }

          console.info(`after splice, len = ${this.momentList.length}`);
        }
      })
    }
    .width('100%')
    .height(('100%'))
  }
}
