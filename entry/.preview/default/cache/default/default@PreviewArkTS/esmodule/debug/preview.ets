struct preview{build(){Column() {
      UserBaseInfo({
        nickname: this.nickname,
        signature: this.signature
      });

      ListInfo();
    }
    .height(Const.FULL_HEIGHT)
    .backgroundColor($r('app.color.mineBgColor'))}}