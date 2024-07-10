struct preview{build(){ListItem() {
            OpenRemindItem()
            .enabled(this.settingParams?.isOpen)
          }
          .listItemStyle()
          .onClick(() => {
            if(!this.settingParams.isOpen)
              promptAction.showToast({
                message: '请先开启任务'
              });
          })}}